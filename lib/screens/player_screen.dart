import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../services/radio_audio_handler.dart';
import '../theme/app_theme.dart';
import '../widgets/mountain_visualizer.dart';
import '../widgets/sleep_timer_sheet.dart';
import '../data/schedule_data.dart';

class PlayerScreen extends StatefulWidget {
  final RadioAudioHandler audioHandler;

  const PlayerScreen({super.key, required this.audioHandler});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with SingleTickerProviderStateMixin {
  double _volume = 0.8;
  bool _isMuted = false;
  double _previousVolume = 0.8;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      if (_isMuted) {
        _isMuted = false;
        _volume = _previousVolume;
        widget.audioHandler.setVolume(_volume);
      } else {
        _previousVolume = _volume;
        _isMuted = true;
        _volume = 0.0;
        widget.audioHandler.setVolume(0.0);
      }
    });
  }

  void _shareRadio() {
    Share.share(
      'Słucham Radia BB – Beskidzkie brzmienia na żywo! Dołącz do mnie: https://radiobb.pl',
      subject: 'Radio BB – Posłuchaj na żywo!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: widget.audioHandler.playbackState,
      builder: (context, playbackSnapshot) {
        final playbackState = playbackSnapshot.data;
        final isPlaying = playbackState?.playing ?? false;
        final isBuffering = playbackState?.processingState == AudioProcessingState.buffering ||
            playbackState?.processingState == AudioProcessingState.loading;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.4),
                radius: 1.2,
                colors: [
                  Color(0xFF0F324B),
                  AppTheme.navyDark,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: [
                    // Nagłówek ze stacją i statusem NA ŻYWO
                    _buildTopBar(isPlaying),
                    const SizedBox(height: 12),

                    // Centralna grafika / Logo z poświatą
                    Expanded(
                      flex: 6,
                      child: Center(
                        child: _buildArtworkCard(isPlaying),
                      ),
                    ),

                    // Animowana grań Beskidów (Wizualizer)
                    MountainVisualizer(isPlaying: isPlaying, height: 50),
                    const SizedBox(height: 12),

                    // Informacje o audycji i utworze (RDS / Now Playing)
                    _buildNowPlayingInfo(isPlaying, isBuffering),
                    const SizedBox(height: 16),

                    // Suwak głośności
                    _buildVolumeSlider(),
                    const SizedBox(height: 16),

                    // Główny przycisk PLAY / PAUSE
                    _buildPlayButton(isPlaying, isBuffering),
                    const SizedBox(height: 20),

                    // Pasek dolny: Sleep Timer, Jakość strumienia, Udostępnij
                    _buildBottomActionRow(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(bool isPlaying) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/radio-bb-logo.png',
              height: 38,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.radio, color: AppTheme.bluePrimary, size: 32),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RADIO BB',
                  style: GoogleFonts.archivoBlack(
                    fontSize: 16,
                    color: AppTheme.paperWhite,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Beskidzkie brzmienia',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppTheme.blueSoft,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Badge NA ŻYWO
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isPlaying ? AppTheme.liveRed.withOpacity(0.18) : AppTheme.navyCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPlaying ? AppTheme.liveRed : AppTheme.textMuted.withOpacity(0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPlaying ? AppTheme.liveRed : AppTheme.textMuted,
                      boxShadow: isPlaying
                          ? [
                              BoxShadow(
                                color: AppTheme.liveRed.withOpacity(_pulseController.value * 0.8),
                                blurRadius: 8,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                  );
                },
              ),
              const SizedBox(width: 7),
              Text(
                'NA ŻYWO',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isPlaying ? AppTheme.paperWhite : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArtworkCard(bool isPlaying) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250, maxWidth: 280),
      decoration: BoxDecoration(
        color: AppTheme.navyCard,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isPlaying ? AppTheme.bluePrimary.withOpacity(0.25) : Colors.black38,
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isPlaying ? AppTheme.bluePrimary.withOpacity(0.4) : AppTheme.navyCardLight,
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/beskidzkie-brzmienia.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/radio-bb-logo.png',
                fit: BoxFit.contain,
                width: 180,
              ),
            ),
            // Subtelny gradient na dole karty
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppTheme.navyDark.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Radio BB Online',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: AppTheme.blueSoft,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Bielsko-Biała',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.amberAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNowPlayingInfo(bool isPlaying, bool isBuffering) {
    return StreamBuilder<MediaItem?>(
      stream: widget.audioHandler.mediaItem,
      builder: (context, snapshot) {
        final item = snapshot.data;
        final title = item?.title ?? 'Radio BB – Włącz dobre brzmienie';
        final artist = item?.artist ?? 'Radio BB';
        final currentProg = ScheduleData.getCurrentOrNextProgramme();

        final hasDistinctArtist = isPlaying &&
            artist.isNotEmpty &&
            artist.toLowerCase() != 'radio bb' &&
            artist.toLowerCase() != 'beskidzkie brzmienia';

        return Column(
          children: [
            if (currentProg != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: AppTheme.navyCardLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'AUDYCJA: ${currentProg.title.toUpperCase()} (${currentProg.time})',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: AppTheme.amberAccent,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            if (isBuffering) ...[
              Text(
                'Łączenie ze studiem Radia BB...',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.paperWhite,
                ),
              ),
            ] else if (!isPlaying) ...[
              Text(
                'Dotknij Play, aby włączyć radio',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.paperWhite,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Beskidzkie brzmienia na żywo',
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  color: AppTheme.textMuted,
                ),
              ),
            ] else if (hasDistinctArtist) ...[
              // Dedykowana, wyróżniona linia dla WYKONAWCY
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.music_note_rounded, size: 16, color: AppTheme.bluePrimary),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      artist.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppTheme.blueSoft,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // TYTUŁ UTWORU
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.paperWhite,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Beskidzka Grupa Medialna · Bielsko-Biała',
                style: GoogleFonts.manrope(
                  fontSize: 11.5,
                  color: AppTheme.textMuted,
                ),
              ),
            ] else ...[
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.paperWhite,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Beskidzka Grupa Medialna · Bielsko-Biała',
                style: GoogleFonts.manrope(
                  fontSize: 12.5,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildVolumeSlider() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _isMuted || _volume == 0 ? Icons.volume_off_rounded : Icons.volume_down_rounded,
            color: AppTheme.textLight,
            size: 22,
          ),
          onPressed: _toggleMute,
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.bluePrimary,
              inactiveTrackColor: AppTheme.navyCardLight,
              thumbColor: AppTheme.paperWhite,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: _volume,
              min: 0.0,
              max: 1.0,
              onChanged: (val) {
                setState(() {
                  _volume = val;
                  _isMuted = val == 0;
                });
                widget.audioHandler.setVolume(val);
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.volume_up_rounded,
            color: AppTheme.textLight,
            size: 22,
          ),
          onPressed: () {
            setState(() {
              _volume = 1.0;
              _isMuted = false;
            });
            widget.audioHandler.setVolume(1.0);
          },
        ),
      ],
    );
  }

  Widget _buildPlayButton(bool isPlaying, bool isBuffering) {
    return GestureDetector(
      onTap: () {
        if (isPlaying) {
          widget.audioHandler.pause();
        } else {
          widget.audioHandler.play();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1AA4E2),
              Color(0xFF0C6B99),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.bluePrimary.withOpacity(isPlaying ? 0.6 : 0.3),
              blurRadius: isPlaying ? 28 : 14,
              spreadRadius: isPlaying ? 4 : 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isBuffering
              ? const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppTheme.paperWhite,
                  ),
                )
              : Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: AppTheme.paperWhite,
                  size: 46,
                ),
        ),
      ),
    );
  }

  Widget _buildBottomActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Sleep Timer
        StreamBuilder<int>(
          stream: widget.audioHandler.sleepTimerStream,
          initialData: widget.audioHandler.sleepSecondsRemaining,
          builder: (context, snapshot) {
            final sec = snapshot.data ?? 0;
            final isActive = sec > 0;
            final min = (sec / 60).ceil();

            return OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: isActive ? AppTheme.amberAccent : AppTheme.textLight,
                side: BorderSide(
                  color: isActive ? AppTheme.amberAccent : AppTheme.navyCardLight,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              icon: Icon(
                isActive ? Icons.timer_rounded : Icons.bedtime_outlined,
                size: 18,
              ),
              label: Text(
                isActive ? '$min min' : 'Sleep',
                style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => SleepTimerSheet(audioHandler: widget.audioHandler),
                );
              },
            );
          },
        ),

        // Stream Quality Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.navyCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.navyCardLight),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.graphic_eq_rounded, size: 16, color: AppTheme.bluePrimary),
              const SizedBox(width: 6),
              Text(
                '128 kbps · STEREO',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.blueSoft,
                ),
              ),
            ],
          ),
        ),

        // Udostępnij
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.textLight,
            side: const BorderSide(color: AppTheme.navyCardLight),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
          icon: const Icon(Icons.share_outlined, size: 18),
          label: Text(
            'Udostępnij',
            style: GoogleFonts.manrope(fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          onPressed: _shareRadio,
        ),
      ],
    );
  }
}
