import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/radio_audio_handler.dart';
import '../theme/app_theme.dart';

class SleepTimerSheet extends StatelessWidget {
  final RadioAudioHandler audioHandler;

  const SleepTimerSheet({super.key, required this.audioHandler});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: const BoxDecoration(
        color: AppTheme.navyPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.bedtime_outlined, color: AppTheme.bluePrimary, size: 26),
                const SizedBox(width: 12),
                Text(
                  'Wyłącznik czasowy',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.paperWhite,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Aplikacja samoczynnie zatrzyma odtwarzanie po wybranym czasie.',
              style: GoogleFonts.manrope(
                fontSize: 13.5,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder<int>(
              stream: audioHandler.sleepTimerStream,
              initialData: audioHandler.sleepSecondsRemaining,
              builder: (context, snapshot) {
                final seconds = snapshot.data ?? 0;
                final minutes = (seconds / 60).ceil();

                return Column(
                  children: [
                    if (seconds > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.navyCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.bluePrimary.withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_outlined, color: AppTheme.amberAccent, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Aktywny: wyłączenie za $minutes min',
                                style: GoogleFonts.manrope(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.paperWhite,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                audioHandler.cancelSleepTimer();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Anuluj',
                                style: GoogleFonts.manrope(
                                  color: AppTheme.liveRed,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildTimerOption(context, 15),
                        _buildTimerOption(context, 30),
                        _buildTimerOption(context, 45),
                        _buildTimerOption(context, 60),
                        _buildTimerOption(context, 90),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerOption(BuildContext context, int minutes) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.navyCard,
        foregroundColor: AppTheme.paperWhite,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppTheme.blueDeep.withOpacity(0.35)),
        ),
        elevation: 0,
      ),
      onPressed: () {
        audioHandler.setSleepTimer(minutes);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.navyCard,
            content: Text(
              'Wyłącznik czasowy ustawiony na $minutes minut.',
              style: GoogleFonts.manrope(color: AppTheme.paperWhite),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Text(
        '$minutes min',
        style: GoogleFonts.jetBrainsMono(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
