import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_item.dart';
import '../services/radio_api_service.dart';
import '../theme/app_theme.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final RadioApiService _apiService = RadioApiService();
  late Future<List<NewsItem>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _apiService.fetchNews();
  }

  Future<void> _refresh() async {
    setState(() {
      _newsFuture = _apiService.fetchNews();
    });
    await _newsFuture;
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url.trim());
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        final uri = Uri.parse(url.trim());
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {}
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wiadomości z regionu',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 19),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppTheme.bluePrimary,
        backgroundColor: AppTheme.navyCard,
        child: FutureBuilder<List<NewsItem>>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.bluePrimary),
              );
            }

            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.newspaper_rounded, size: 48, color: AppTheme.textMuted),
                    const SizedBox(height: 12),
                    Text(
                      'Brak aktualnych wiadomości',
                      style: GoogleFonts.manrope(color: AppTheme.textLight, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _refresh,
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.bluePrimary),
                      child: const Text('Odśwież'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.navyCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.bluePrimary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.rss_feed_rounded, color: AppTheme.amberAccent, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Wiadomości dostarcza portal Beskidzka24.pl – Beskidzka Grupa Medialna',
                            style: GoogleFonts.manrope(
                              fontSize: 12.5,
                              color: AppTheme.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final item = items[index - 1];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.navyCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.navyCardLight.withOpacity(0.6)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => _launchUrl(item.link),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.bluePrimary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.author.toUpperCase(),
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.blueSoft,
                                  ),
                                ),
                              ),
                              if (item.pubDate.isNotEmpty) ...[
                                Text(
                                  _formatDate(item.pubDate),
                                  style: GoogleFonts.manrope(
                                    fontSize: 11.5,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.title,
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.paperWhite,
                              height: 1.3,
                            ),
                          ),
                          if (item.description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              item.description,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: AppTheme.textMuted,
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Czytaj cały artykuł',
                                style: GoogleFonts.manrope(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.bluePrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_outward_rounded,
                                size: 16,
                                color: AppTheme.bluePrimary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(String rawDate) {
    if (rawDate.length > 16) {
      return rawDate.substring(0, 16);
    }
    return rawDate;
  }
}
