import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/radio_audio_handler.dart';
import '../theme/app_theme.dart';
import 'player_screen.dart';
import 'schedule_screen.dart';
import 'news_screen.dart';
import 'media_group_screen.dart';
import 'contact_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final RadioAudioHandler audioHandler;

  const MainNavigationScreen({super.key, required this.audioHandler});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      PlayerScreen(audioHandler: widget.audioHandler),
      const ScheduleScreen(),
      const NewsScreen(),
      const MediaGroupScreen(),
      const ContactScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: widget.audioHandler.playbackState,
      builder: (context, playbackSnapshot) {
        final isPlaying = playbackSnapshot.data?.playing ?? false;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          bottomSheet: _currentIndex != 0
              ? _buildMiniPlayer(isPlaying)
              : null,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.radio_rounded),
                  activeIcon: Icon(Icons.radio_rounded, color: AppTheme.bluePrimary),
                  label: 'Słuchaj',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined),
                  activeIcon: Icon(Icons.calendar_month_rounded, color: AppTheme.bluePrimary),
                  label: 'Ramówka',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_outlined),
                  activeIcon: Icon(Icons.newspaper_rounded, color: AppTheme.bluePrimary),
                  label: 'Wiadomości',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.hub_outlined),
                  activeIcon: Icon(Icons.hub_rounded, color: AppTheme.bluePrimary),
                  label: 'Grupa BGM',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contact_support_outlined),
                  activeIcon: Icon(Icons.contact_support_rounded, color: AppTheme.bluePrimary),
                  label: 'Kontakt',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniPlayer(bool isPlaying) {
    return StreamBuilder<MediaItem?>(
      stream: widget.audioHandler.mediaItem,
      builder: (context, snapshot) {
        final title = snapshot.data?.title ?? 'Radio BB';

        return GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = 0; // Przełącz na odtwarzacz
            });
          },
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.navyCard,
              border: Border(
                top: BorderSide(color: AppTheme.bluePrimary.withOpacity(0.5), width: 1.5),
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2)),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/radio-bb-logo.png',
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.radio, color: AppTheme.bluePrimary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.paperWhite,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        isPlaying ? 'Nadaje na żywo' : 'Zatrzymano',
                        style: GoogleFonts.jetbrainsMono(
                          fontSize: 11,
                          color: isPlaying ? AppTheme.amberAccent : AppTheme.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                    color: AppTheme.bluePrimary,
                    size: 38,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      widget.audioHandler.pause();
                    } else {
                      widget.audioHandler.play();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
