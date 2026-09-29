import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'radio_api_service.dart';

class RadioAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final RadioApiService _apiService = RadioApiService();

  Timer? _metadataTimer;
  Timer? _sleepTimer;
  int _sleepSecondsRemaining = 0;
  final _sleepTimerController = StreamController<int>.broadcast();

  Stream<int> get sleepTimerStream => _sleepTimerController.stream;
  int get sleepSecondsRemaining => _sleepSecondsRemaining;

  static const String streamUrl = 'https://s3.slotex.pl/shoutcast/7010/stream?sid=1';

  RadioAudioHandler() {
    _initAudioSession();
    _listenPlayerStates();
  }

  void _initAudioSession() {
    mediaItem.add(
      MediaItem(
        id: streamUrl,
        album: 'Beskidzka Grupa Medialna',
        title: 'Radio BB – Włącz dobre brzmienie',
        artist: 'Beskidzkie brzmienia',
        artUri: Uri.parse('https://radiobb.pl/wp-content/themes/radio-bb/assets/images/radio-bb-logo.png'),
      ),
    );
  }

  void _listenPlayerStates() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
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
    });

    // Auto-reconnect w przypadku zerwania połączenia sieciowego
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Stream radiowy nie powinien się normalnie kończyć, więc wznawiamy
        reconnect();
      }
    });
  }

  @override
  Future<void> play() async {
    try {
      if (_player.processingState == ProcessingState.idle) {
        await _player.setUrl(streamUrl);
      }
      await _player.play();
      _startMetadataPolling();
    } catch (e) {
      // Automatyczna próba ponownego połączenia przy błędzie sieci
      await Future.delayed(const Duration(seconds: 2));
      await reconnect();
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    _stopMetadataPolling();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    _stopMetadataPolling();
    cancelSleepTimer();
    await super.stop();
  }

  Future<void> reconnect() async {
    try {
      await _player.stop();
      await _player.setUrl(streamUrl);
      await _player.play();
      _startMetadataPolling();
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
    _metadataTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      _updateMetadata();
    });
  }

  void _stopMetadataPolling() {
    _metadataTimer?.cancel();
    _metadataTimer = null;
  }

  Future<void> _updateMetadata() async {
    final info = await _apiService.fetchNowPlaying();
    final currentItem = mediaItem.value;

    if (currentItem != null && currentItem.title != info.title) {
      mediaItem.add(
        currentItem.copyWith(
          title: info.title.isNotEmpty ? info.title : 'Radio BB – Beskidzkie brzmienia',
          artist: 'Radio BB · Na Żywo',
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
