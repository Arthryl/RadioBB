# 🚀 PROMPT DLA NOWEJ KONWERSACJI (GEMINI 4 / SESJA „4 ARGON”)

> **Instrukcja dla użytkownika:**  
> Skopiuj poniższą treść w ramce i wklej ją jako pierwszą wiadomość w nowym oknie czatu z modelem **Gemini 4** (sesja *4 Argon*). Model natychmiast przeczyta przygotowane pliki, przeprowadzi pełny audyt aplikacji i przygotuje profesjonalną mapę drogową (roadmap).

---

```markdown
Cześć! Przejmujesz projekt oficjalnej aplikacji mobilnej Radia BB – Beskidzkie brzmienia (stacji Beskidzkiej Grupy Medialnej, należącej do Dariusza Moskały). 

Aplikacja jest napisana we Flutterze (wersja v1.0.4+5), działa w oparciu o silnik just_audio + audio_service, posiada działający stream live Shoutcast, dynamiczny RDS, ramówkę tygodniową, wiadomości RSS z portalu Beskidzka24 oraz prezentację grupy mediowej. Została już skompilowana i pomyślnie przetestowana na telefonie z Androidem.

Twoim zadaniem jest przeprowadzenie kompleksowego audytu technicznego i architektonicznego tej aplikacji oraz przygotowanie strategicznej mapy drogowej (roadmapy) pokazującej co jeszcze warto zrobić, naprawić lub rozbudować.

Przed rozpoczęciem audytu przeczytaj proszę szczegółową dokumentację przekazania, którą przygotował poprzedni inżynier w pliku:
👉 AUDYT_PRZEKAZANIE_PROJEKTU.md
oraz:
👉 README.md
oraz przejrzyj kluczowe pliki źródłowe w katalogu lib/:
- lib/services/radio_audio_handler.dart (silnik audio, obsługa live-edge, czyszczenie bufora)
- lib/services/radio_api_service.dart (pobieranie RDS i RSS)
- lib/screens/player_screen.dart (główny ekran odtwarzacza i pasek akcji)
- lib/screens/schedule_screen.dart i lib/data/schedule_data.dart (ramówka)
- android/app/src/main/AndroidManifest.xml i android/app/build.gradle

W swoim raporcie audytowym uwzględnij:
1. Ocenę architektury i zarządzania stanem (czy StreamBuilder/AudioHandler wystarcza, czy warto wdrożyć Riverpod/Bloc).
2. Odporność silnika audio na specyficzne warunki górskie Beskidów (doliny, przełączanie masztów BTS, zasięg graniczny, auto-reconnect).
3. Pamięć podręczną i tryb offline (buforowanie wiadomości i ramówki).
4. Zgodność z Google Play Store (Target SDK 34/35, Android 15 i strony pamięci 16 KB, podpisanie kluczem Keystore, polityka prywatności).
5. Wsparcie dla Android Auto i odtwarzania w samochodzie.
6. Przygotowanie do wydania wersji na iOS (Apple App Store).
7. Jakość kodu, testy jednostkowe (katalog test/) oraz optymalizację R8/ProGuard.

Na koniec przygotuj przejrzystą, priorytetyzowaną Roadmapę (kroki natychmiastowe P0, ulepszenia kluczowe P1, funkcje przyszłościowe P2).

Czekam na Twój szczegółowy raport z audytu!
```

---
*Plik wygenerowany w projekcie Radio BB.*
