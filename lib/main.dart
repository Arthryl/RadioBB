import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/main_navigation_screen.dart';
import 'services/radio_audio_handler.dart';
import 'theme/app_theme.dart';

late RadioAudioHandler _audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Konfiguracja paska stanu systemu Android
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.navyPrimary,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Inicjalizacja AudioService do odtwarzania w tle i powiadomień
  _audioHandler = await AudioService.init(
    builder: () => RadioAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'pl.radiobb.app.channel.audio',
      androidNotificationChannelName: 'Radio BB Live',
      androidNotificationChannelDescription: 'Odtwarzanie strumienia Radia BB na żywo w tle',
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: true,
      notificationColor: Color(0xFF0B2436),
    ),
  );

  runApp(const RadioBBApp());
}

class RadioBBApp extends StatelessWidget {
  const RadioBBApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radio BB – Beskidzkie brzmienia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: MainNavigationScreen(audioHandler: _audioHandler),
    );
  }
}
