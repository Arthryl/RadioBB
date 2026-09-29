import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launch(String schemeUrl) async {
    try {
      final uri = Uri.parse(schemeUrl.trim());
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        final uri = Uri.parse(schemeUrl.trim());
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } catch (_) {}
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kontakt i Redakcja',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 19),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Karta studia
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppTheme.navyCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppTheme.bluePrimary.withOpacity(0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/radio-bb-logo.png',
                      height: 48,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.radio, color: AppTheme.bluePrimary, size: 40),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Studio Radia BB',
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.paperWhite,
                            ),
                          ),
                          Text(
                            'Beskidzkie brzmienia · Bielsko-Biała',
                            style: GoogleFonts.manrope(
                              fontSize: 12.5,
                              color: AppTheme.blueSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Masz ciekawą historię z regionu, chcesz zaproponować temat do audycji lub skontaktować się ze studiem emisyjnym? Jesteśmy blisko Ciebie!',
                  style: GoogleFonts.manrope(
                    fontSize: 13.5,
                    color: AppTheme.textLight,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),

                // Przyciski szybkiego kontaktu
                _buildContactButton(
                  icon: Icons.language_rounded,
                  label: 'Oficjalna strona internetowa',
                  value: 'radiobb.pl',
                  onTap: () => _launch('https://radiobb.pl'),
                ),
                const SizedBox(height: 10),
                _buildContactButton(
                  icon: Icons.alternate_email_rounded,
                  label: 'Napisz do redakcji',
                  value: 'redakcja@radiobb.pl',
                  onTap: () => _launch('mailto:redakcja@radiobb.pl'),
                ),
                const SizedBox(height: 10),
                _buildContactButton(
                  icon: Icons.location_on_outlined,
                  label: 'Lokalizacja',
                  value: 'Bielsko-Biała, Beskidy',
                  onTap: () => _launch('https://maps.google.com/?q=Bielsko-Bia%C5%82a'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Karta Dedykacji dla Dariusza Moskały
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF143B57), Color(0xFF0C2436)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppTheme.amberAccent.withOpacity(0.5), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.card_giftcard_rounded, color: AppTheme.amberAccent, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'PREZENT SPECJALNY',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        color: AppTheme.amberAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Dla Dariusza Moskały',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.paperWhite,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Aplikacja dedykowana twórcy i właścicielowi Radia BB oraz Beskidzkiej Grupy Medialnej. Stworzona z pasji do nowoczesnych technologii radiowych i miłości do Podbeskidzia.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppTheme.textLight,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Informacje techniczne
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.navyCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildTechRow('Wersja aplikacji', '1.0.2 (Najnowsza aktualizacja)'),
                const Divider(color: AppTheme.navyCardLight, height: 18),
                _buildTechRow('Silnik audio', 'just_audio + audio_service'),
                const Divider(color: AppTheme.navyCardLight, height: 18),
                _buildTechRow('Odtwarzanie w tle', 'Foreground MediaService'),
                const Divider(color: AppTheme.navyCardLight, height: 18),
                _buildTechRow('Kompatybilność', 'Android 8.0+ / Android Auto / BT'),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.navyPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.navyCardLight),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.bluePrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.manrope(fontSize: 11, color: AppTheme.textMuted),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.manrope(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.paperWhite,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTechRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(fontSize: 12.5, color: AppTheme.textMuted),
        ),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.blueSoft,
          ),
        ),
      ],
    );
  }
}
