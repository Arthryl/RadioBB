class ProgrammeItem {
  final String time;
  final String title;
  final String description;
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final String? category;
  final bool isHourlyNews;

  const ProgrammeItem({
    required this.time,
    required this.title,
    this.description = '',
    required this.dayOfWeek,
    this.category,
    this.isHourlyNews = false,
  });

  int get hour {
    final parts = time.split(':');
    return int.tryParse(parts[0]) ?? 0;
  }

  int get minute {
    final parts = time.split(':');
    if (parts.length > 1) {
      return int.tryParse(parts[1]) ?? 0;
    }
    return 0;
  }

  int get totalMinutes => hour * 60 + minute;
}

class NowPlayingInfo {
  final String artist;
  final String songTitle;
  final String title; // Pełny ciąg lub tytuł
  final bool isOnline;
  final DateTime timestamp;

  const NowPlayingInfo({
    required this.artist,
    required this.songTitle,
    required this.title,
    required this.isOnline,
    required this.timestamp,
  });

  factory NowPlayingInfo.fromString(String raw) {
    var cleaned = raw.trim();
    if (cleaned.isEmpty) {
      return NowPlayingInfo.initial();
    }

    // Usunięcie prefiksów numerów utworów np. "16. ", "01. ", "[02] "
    cleaned = cleaned.replaceFirst(RegExp(r'^\d+[\.\-\s]+\s*'), '');
    cleaned = cleaned.replaceFirst(RegExp(r'^\[\d+\]\s*'), '');

    String artist = 'Radio BB';
    String song = cleaned;

    if (cleaned.contains(' - ')) {
      final parts = cleaned.split(' - ');
      artist = parts[0].trim();
      song = parts.sublist(1).join(' - ').trim();
    } else if (cleaned.contains(' — ')) {
      final parts = cleaned.split(' — ');
      artist = parts[0].trim();
      song = parts.sublist(1).join(' — ').trim();
    } else if (cleaned.contains(' – ')) {
      final parts = cleaned.split(' – ');
      artist = parts[0].trim();
      song = parts.sublist(1).join(' – ').trim();
    } else if (cleaned.contains('-') && !cleaned.toLowerCase().contains('radio-bb')) {
      final parts = cleaned.split('-');
      artist = parts[0].trim();
      song = parts.sublist(1).join('-').trim();
    }

    if (cleaned.toLowerCase().contains('radioboss') || cleaned.isEmpty) {
      artist = 'Radio BB';
      song = 'Beskidzkie brzmienia na żywo';
    }

    return NowPlayingInfo(
      artist: artist,
      songTitle: song,
      title: cleaned,
      isOnline: true,
      timestamp: DateTime.now(),
    );
  }

  factory NowPlayingInfo.fromJson(Map<String, dynamic> json) {
    final raw = json['title'] as String? ?? json['songtitle'] as String? ?? '';
    final isOnline = json['online'] as bool? ?? true;
    final info = NowPlayingInfo.fromString(raw);
    return NowPlayingInfo(
      artist: info.artist,
      songTitle: info.songTitle,
      title: info.title,
      isOnline: isOnline,
      timestamp: DateTime.now(),
    );
  }

  factory NowPlayingInfo.initial() {
    return NowPlayingInfo(
      artist: 'Radio BB',
      songTitle: 'Beskidzkie brzmienia na żywo',
      title: 'Radio BB – Beskidzkie brzmienia',
      isOnline: true,
      timestamp: DateTime.now(),
    );
  }
}
