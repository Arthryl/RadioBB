import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class MediaGroupScreen extends StatelessWidget {
  const MediaGroupScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beskidzka Grupa Medialna',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 19),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Baner główny BGM
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F3652), AppTheme.navyPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppTheme.bluePrimary.withOpacity(0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.navyCard,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.hub_rounded, color: AppTheme.bluePrimary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RAZEM WIEMY WIĘCEJ',
                            style: GoogleFonts.jetbrainsMono(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.amberAccent,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            'Beskidzka Grupa Medialna',
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.paperWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Radio BB stanowi integralną część Beskidzkiej Grupy Medialnej – wiodącego wydawcy mediów regionalnych na Podbeskidziu. Łączymy tradycję rzetelnego dziennikarstwa z nowoczesnymi mediami cyfrowymi i radiem internetowym.',
                  style: GoogleFonts.manrope(
                    fontSize: 13.5,
                    color: AppTheme.textLight,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'NASZE MEDIA',
            style: GoogleFonts.jetbrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppTheme.blueSoft,
            ),
          ),
          const SizedBox(height: 12),

          // Lista podmiotów grupy BGM
          _buildMediaCard(
            context,
            title: 'Kronika Beskidzka',
            type: 'TYGODNIK REGIONALNY',
            description: 'Kultowy tygodnik lokalny z wieloletnią tradycją na Podbeskidziu, zapewniający rzetelny fundament dziennikarski.',
            svgAsset: 'assets/images/kronika-beskidzka.svg',
            url: 'https://kronika.beskidzka.pl/',
          ),
          _buildMediaCard(
            context,
            title: 'Beskidzka24.pl',
            type: 'PORTAL INFORMACYJNY',
            description: 'Jeden z największych i najchętniej odwiedzanych serwisów informacyjnych w regionie Bielska-Białej, Żywca i Cieszyna.',
            svgAsset: 'assets/images/beskidzka24.svg',
            url: 'https://beskidzka24.pl/',
          ),
          _buildMediaCard(
            context,
            title: 'Beskidzka TV',
            type: 'TELEWIZJA INTERNETOWA',
            description: 'Telewizja realizująca materiały wideo, wywiady, profesjonalne reportaże oraz transmisje z najważniejszych wydarzeń lokalnych.',
            svgAsset: 'assets/images/beskidzka-tv.svg',
            url: 'https://bielsko.biala.pl/tv',
          ),
          _buildMediaCard(
            context,
            title: 'Bielsko.Biala.pl',
            type: 'PORTAL MIEJSKI I REGIONALNY',
            description: 'Popularny portal miejski oferujący bieżące wiadomości z życia stolicy Podbeskidzia i okolicznych gmin.',
            svgAsset: 'assets/images/bielsko-biala.svg',
            url: 'https://bielsko.biala.pl/',
          ),
          _buildMediaCard(
            context,
            title: 'Głos Ziemi Cieszyńskiej',
            type: 'PRASA I PORTAL',
            description: 'Zasłużony lokalny tytuł prasowy i portal internetowy wzmacniający przekaz informacyjny na Śląsku Cieszyńskim.',
            svgAsset: 'assets/images/glos-ziemi-cieszynskiej.svg',
            url: 'https://gzc.cieszyn.pl/',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMediaCard(
    BuildContext context, {
    required String title,
    required String type,
    required String description,
    required String svgAsset,
    required String url,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.navyCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.navyCardLight.withOpacity(0.6)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _launchUrl(url),
        child: Padding(
          padding: const EdgeInsets.all(18),
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
                      type,
                      style: GoogleFonts.jetbrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.blueSoft,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_outward_rounded, size: 18, color: AppTheme.bluePrimary),
                ],
              ),
              const SizedBox(height: 12),
              // Logo podmiotu
              Container(
                height: 38,
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  svgAsset,
                  height: 32,
                  colorFilter: const ColorFilter.mode(AppTheme.paperWhite, BlendMode.srcIn),
                  placeholderBuilder: (_) => Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.paperWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Odwiedź stronę www',
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.bluePrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
