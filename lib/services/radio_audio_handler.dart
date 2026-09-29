import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../models/programme_model.dart';
import 'radio_api_service.dart';

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final RadioApiService _apiService = RadioApiService();

  Timer? _metadataTimer;
  Timer? _sleepTimer;
  int _sleepSecondsRemaining = 0;
  final _sleepTimerController = StreamController<int>.broadcast();

  bool _isConnecting = false;
  bool _isUserPaused = true;

  Stream<int> get sleepTimerStream => _sleepTimerController.stream;
  int get sleepSecondsRemaining => _sleepSecondsRemaining;

  static const String streamUrl = 'https://s3.slotex.pl/shoutcast/7010/stream?sid=1';

  RadioAudioHandler() {
    _initAudioSession();
    _listenPlayerStates();
    _listenIcyMetadata();
    _updateMetadata();
  }

  void _initAudioSession() {
    mediaItem.add(
      MediaItem(
        id: streamUrl,
        album: 'Beskidzka Grupa Medialna',
        title: 'Radio BB – Włącz dobre brzmienie',
        artist: 'Radio BB',
        artUri: Uri.parse('https://radiobb.pl/wp-content/themes/radio-bb/assets/images/radio-bb-logo.png'),
      ),
    );
  }

  void _listenIcyMetadata() {
    _player.icyMetadataStream.listen((IcyMetadata? icy) {
      if (_isUserPaused) return;
      final streamTitle = icy?.info?.title;
      if (streamTitle != null && streamTitle.trim().isNotEmpty) {
        _applyNewTrackInfo(NowPlayingInfo.fromString(streamTitle));
      }
    });
  }

  void _listenPlayerStates() {
    _player.playbackEventStream.listen(
      (PlaybackEvent event) {
        final playing = _player.playing;
        playbackState.add(
          playbackState.value.copyWith(
            controls: [
              if (playing) MediaControl.pause else MediaControl.play,
              MediaControl.stop,
            ],
            systemActions: const {
              MediaAction.seek,
              MediaAction.seekForward,
              MediaAction.seekBackward,
            },
            androidCompactActionIndices: const [0, 1],
            processingState: const {
              ProcessingState.idle: AudioProcessingState.idle,
              ProcessingState.loading: AudioProcessingState.loading,
              ProcessingState.buffering: AudioProcessingState.buffering,
              ProcessingState.ready: AudioProcessingState.ready,
              ProcessingState.completed: AudioProcessingState.completed,
            }[_player.processingState]!,
            playing: playing,
          ),
        );
      },
      onError: (Object e, StackTrace st) {
        if (!_isUserPaused) {
          reconnect();
        }
      },
    );

    // Auto-reconnect w przypadku zerwania połączenia sieciowego
    _player.playerStateStream.listen((state) {
      if (!_isUserPaused && state.processingState == ProcessingState.completed) {
        // Stream radiowy na żywo nie powinien się normalnie kończyć, więc wznawiamy
        reconnect();
      }
    });
  }

  @override
  Future<void> play() async {
    if (_isConnecting) return;
    _isUserPaused = false;
    _isConnecting = true;

    // Natychmiast informujemy UI o buforowaniu
    playbackState.add(
      playbackState.value.copyWith(
        playing: true,
        processingState: AudioProcessingState.buffering,
        controls: [MediaControl.pause, MediaControl.stop],
      ),
    );

    try {
      // 1. Zatrzymujemy stary odtwarzacz i całkowicie czyścimy bufor pamięci
      await _player.stop();
      // 2. Łączymy się ze świeżym strumieniem bezpośrednio NA ŻYWO (zero opóźnienia czasowego)
      await _player.setUrl(streamUrl);
      if (!_isUserPaused) {
        await _player.play();
        _startMetadataPolling();
      }
    } catch (e) {
      if (!_isUserPaused) {
        await Future.delayed(const Duration(seconds: 2));
        if (!_isUserPaused) {
          await reconnect();
        }
      }
    } finally {
      _isConnecting = false;
    }
  }

  @override
  Future<void> pause() async {
    _isUserPaused = true;
    _stopMetadataPolling();
    try {
      // W radiu na żywo pauza oznacza całkowite zatrzymanie i wyczyszczenie bufora,
      // aby po ponownym włączeniu odtwarzać od razu aktualny czas na żywo, a nie zaległy bufor.
      await _player.stop();
    } catch (_) {}
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
        controls: [MediaControl.play, MediaControl.stop],
      ),
    );
  }

  @override
  Future<void> stop() async {
    _isUserPaused = true;
    _stopMetadataPolling();
    cancelSleepTimer();
    try {
      await _player.stop();
    } catch (_) {}
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
        controls: [MediaControl.play],
      ),
    );
    await super.stop();
  }

  Future<void> reconnect() async {
    if (_isUserPaused) return;
    try {
      await _player.stop();
      await _player.setUrl(streamUrl);
      if (!_isUserPaused) {
        await _player.play();
        _startMetadataPolling();
      }
    } catch (_) {}
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  // --- Sleep Timer (Wyłącznik czasowy) ---
  void setSleepTimer(int minutes) {
    cancelSleepTimer();
    if (minutes <= 0) return;

    _sleepSecondsRemaining = minutes * 60;
    _sleepTimerController.add(_sleepSecondsRemaining);

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sleepSecondsRemaining > 0) {
        _sleepSecondsRemaining--;
        _sleepTimerController.add(_sleepSecondsRemaining);
      } else {
        cancelSleepTimer();
        pause();
      }
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepSecondsRemaining = 0;
    _sleepTimerController.add(0);
  }

  // --- Dynamiczne pobieranie tytułu utworu z RDS / API ---
  void _startMetadataPolling() {
    _updateMetadata();
    _metadataTimer?.cancel();
    _metadataTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (!_isUserPaused) {
        _updateMetadata();
      }
    });
  }

  void _stopMetadataPolling() {
    _metadataTimer?.cancel();
    _metadataTimer = null;
  }

  Future<void> _updateMetadata() async {
    final info = await _apiService.fetchNowPlaying();
    _applyNewTrackInfo(info);
  }

  void _applyNewTrackInfo(NowPlayingInfo info) {
    if (info.songTitle.trim().isEmpty) return;
    final currentItem = mediaItem.value;
    if (currentItem == null) return;

    if (currentItem.title != info.songTitle || currentItem.artist != info.artist) {
      mediaItem.add(
        currentItem.copyWith(
          title: info.songTitle,
          artist: info.artist,
          album: 'Radio BB · Bielsko-Biała',
        ),
      );
    }
  }

  Future<void> dispose() async {
    _metadataTimer?.cancel();
    _sleepTimer?.cancel();
    await _sleepTimerController.close();
    await _player.dispose();
  }
}
