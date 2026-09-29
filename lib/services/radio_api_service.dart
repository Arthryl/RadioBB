import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/programme_model.dart';
import '../models/news_item.dart';

class RadioApiService {
  static const String metadataUrl = 'https://radiobb.pl/wp-json/radio-bb/v1/now-playing';
  static const String newsFeedUrl = 'https://beskidzka24.pl/feed/';
  static const String streamUrl = 'https://s3.slotex.pl/shoutcast/7010/stream?sid=1';

  /// Pobiera aktualnie odtwarzany utwór lub audycję z oficjalnego API RadioBB lub serwera Shoutcast
  Future<NowPlayingInfo> fetchNowPlaying() async {
    // 1. Główne API Radia BB (WordPress)
    try {
      final response = await http.get(
        Uri.parse(metadataUrl),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Linux; Android 14) RadioBB/1.0',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final title = data['title'] as String?;
        if (title != null && title.trim().isNotEmpty) {
          return NowPlayingInfo.fromString(title);
        }
      }
    } catch (_) {}

    // 2. Bezpośrednie zapytanie do serwera strumieniowego Slotex Shoutcast
    try {
      final slotexResponse = await http.get(
        Uri.parse('http://s3.slotex.pl:7010/stats?sid=1&json=1'),
        headers: {'User-Agent': 'Mozilla/5.0 RadioBB/1.0'},
      ).timeout(const Duration(seconds: 4));

      if (slotexResponse.statusCode == 200) {
        final data = json.decode(utf8.decode(slotexResponse.bodyBytes));
        final songtitle = data['songtitle'] as String?;
        if (songtitle != null && songtitle.trim().isNotEmpty) {
          return NowPlayingInfo.fromString(songtitle);
        }
      }
    } catch (_) {}

    return NowPlayingInfo.initial();
  }

  /// Pobiera najnowsze wiadomości regionalne z Beskidzka24.pl (RSS)
  Future<List<NewsItem>> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse(newsFeedUrl),
        headers: {'User-Agent': 'Mozilla/5.0 (Linux; Android 14) RadioBB-News/1.0'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(utf8.decode(response.bodyBytes));
        final items = document.findAllElements('item');

        return items.map((node) {
          final title = node.findElements('title').firstOrNull?.innerText.trim() ?? '';
          final link = node.findElements('link').firstOrNull?.innerText.trim() ?? '';

          final pubDate = node.findElements('pubDate').firstOrNull?.innerText ?? '';
          var description = node.findElements('description').firstOrNull?.innerText ?? '';

          // Oczyszczenie HTML z opisu
          description = description.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();
          if (description.length > 180) {
            description = '${description.substring(0, 180)}...';
          }

          // Poszukiwanie obrazka w enclosure lub mediach
          String? imageUrl;
          final enclosure = node.findElements('enclosure').firstOrNull;
          if (enclosure != null && enclosure.getAttribute('type')?.contains('image') == true) {
            imageUrl = enclosure.getAttribute('url');
          }

          return NewsItem(
            title: title.replaceAll('&quot;', '"').replaceAll('&#8211;', '–'),
            link: link,
            pubDate: pubDate,
            description: description,
            imageUrl: imageUrl,
            author: 'Beskidzka24.pl',
          );
        }).toList();
      }
    } catch (e) {
      // W razie błędu zwracamy domyślne wpisy
    }
    return _fallbackNews();
  }

  List<NewsItem> _fallbackNews() {
    return [
      const NewsItem(
        title: 'Nowe Radio BB nadaje z Bielska-Białej i Beskidów!',
        link: 'https://radiobb.pl',
        pubDate: 'Bieżące wydanie',
        description: 'Beskidzkie brzmienia na żywo w nowej rozgłośni radiowej Beskidzkiej Grupy Medialnej.',
        author: 'Radio BB',
      ),
      const NewsItem(
        title: 'Kronika Beskidzka: Najświeższe doniesienia z regionu',
        link: 'https://kronika.beskidzka.pl',
        pubDate: 'Wydanie tygodnika',
        description: 'Polecamy najnowszy numer tradycyjnego tygodnika Podbeskidzia.',
        author: 'Kronika Beskidzka',
      ),
    ];
  }
}
