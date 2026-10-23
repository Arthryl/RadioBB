# 📋 DOKUMENTACJA PRZEKAZANIA PROJEKTU I WYTYCZNE DO AUDYTU
# Projekt: Oficjalna Aplikacja Mobilna „Radio BB – Beskidzkie brzmienia”
> **Data wygenerowania:** Październik 2026  
> **Aktualna wersja kodu:** `1.0.4+5`  
> **Docelowy odbiorca dokumentu:** Model Gemini (sesja „4 Argon”) / Starszy Architekt Systemów Mobilnych Flutter & Android  
> **Status:** Gotowa, w pełni przetestowana wersja produkcyjna APK i AAB z historią kluczowych poprawek architektonicznych.

---

## 1. WPROWADZENIE I KONTEKST BIZNESOWY

### 1.1. Geneza projektu
Aplikacja została stworzona jako dedykowany projekt dla **Dariusza Moskały** – założyciela i właściciela **Radia BB** oraz **Beskidzkiej Grupy Medialnej** (wydawcy m.in. *Kroniki Beskidzkiej*, portalu *Beskidzka24.pl*, *Beskidzkiej TV*, portalu *Bielsko.Biala.pl* oraz *Głosu Ziemi Cieszyńskiej*).

### 1.2. Misja i profil stacji
**Radio BB** (*Beskidzkie brzmienia*, oficjalny portal: [radiobb.pl](https://radiobb.pl)) to lokalna, regionalna stacja radiowa nadająca z Bielska-Białej, obejmująca zasięgiem Podbeskidzie, Ziemię Cieszyńską i Żywiecczyznę. Stacja stawia na najlepszą selekcję muzyczną (pop, rock, brzmienia lokalne) oraz rzetelne, cogodzinne serwisy informacyjne z regionu (*„Dzieje się w Beskidach”*).

### 1.3. Kluczowe wymagania użytkowe
1. **Stabilność odtwarzania w tle**: radio nie może przerywać grania po zablokowaniu ekranu, wygaszeniu telefonu czy przełączeniu do innych aplikacji (np. nawigacji Google Maps w aucie).
2. **Pełna integracja systemowa**: powiadomienie `MediaStyle` z okładką, tytułem i przyciskami Play/Pause/Stop, obsługa słuchawek przewodowych i Bluetooth (AVRCP), integracja z radiami samochodowymi i bazą Android Auto.
3. **Brak opóźnień (True Live Edge)**: radio musi grać w czasie rzeczywistym. Pauza i wznowienie nie mogą powodować odtwarzania przestarzałego bufora.
4. **Elegancki, regionalny design**: motyw Dark Navy AMOLED, nawiązania do Beskidów (animowany wizualizer grani górskich), czytelna typografia i 100% spójności z identyfikacją Radia BB.
5. **Czystość i brak spamu**: brak zewnętrznych banerów reklamowych, szybki start, niskie zużycie baterii i danych mobilnych.

---

## 2. STOS TECHNOLOGICZNY I ARCHITEKTURA KODU

### 2.1. Technologie bazowe
- **Framework:** Flutter 3.24.x (Channel Stable)
- **Język:** Dart >= 3.0.0 < 4.0.0
- **System docelowy:** Android (API 23–34+), architektura przygotowana pod rozszerzenie na iOS
- **Zarządzanie kompilacją CI/CD:** GitHub Actions (`.github/workflows/build_apk.yml`) na obrazie `ubuntu-latest` z automatycznym generowaniem wersji APK i AAB

### 2.2. Główne biblioteki (`pubspec.yaml`)
| Biblioteka | Wersja | Zastosowanie w projekcie |
|---|---|---|
| `just_audio` | `^0.9.36` | Silnik audio, obsługa strumienia Icecast/Shoutcast, buforowanie i dekodowanie |
| `audio_service` | `^0.18.12` | Architektura Android Background Service, `MediaSessionCompat`, lockscreen, AVRCP |
| `http` | `^1.2.1` | Zapytania REST do API WordPressa oraz pobieranie statystyk serwera radiowego |
| `xml` | `^6.5.0` | Parsowanie kanału informacyjnego RSS z portalu *Beskidzka24.pl* |
| `url_launcher` | `^6.3.0` | Bezpieczne otwieranie zewnętrznych linków www, połączeń telefonicznych (`tel:`) i e-maili |
| `google_fonts` | `^6.2.1` | Typografia: *Manrope* (UI), *Archivo Black* (branding), *JetBrains Mono* (dane/RDS) |
| `flutter_svg` | `^2.0.10+1` | Renderowanie wektorowych logotypów marek Beskidzkiej Grupy Medialnej |
| `intl` | `^0.19.0` | Formatowanie dat i godzin w ramówce i wiadomościach |
| `share_plus` | `^9.0.0` | Natywne udostępnianie stacji w systemie Android (WhatsApp, Messenger, SMS itp.) |
| `flutter_local_notifications` | `^17.2.1` | Wsparcie kanałów powiadomień systemu Android |

---

## 3. STRUKTURA KATALOGÓW I KOMPONENTÓW

```
c:\Users\Admin\Desktop\ANTIGRAVITY -PROJEKT - RadioBB\
├── android/                         # Natywna warstwa Androida
│   ├── app/
│   │   ├── build.gradle             # compileSdk 34, targetSdk 34, minSdk 23
│   │   └── src/main/
│   │       ├── AndroidManifest.xml  # Uprawnienia, Foreground Service, deklaracje <queries>
│   │       └── kotlin/pl/radiobb/app/MainActivity.kt
│   └── build.gradle
├── assets/
│   ├── icons/                       # Ikona 512x512 Google Play Store, launchery mipmap
│   └── images/                      # radio-bb-logo.png, beskidzkie-brzmienia.png, wektory BGM
├── Gotowa_Aplikacja_Android/        # Gotowe binaria produkcyjne v1.0.4 (.apk, .aab)
├── lib/
│   ├── main.dart                    # Punkt wejścia, konfiguracja paska stanu i AudioService.init
│   ├── data/
│   │   └── schedule_data.dart       # Baza tygodniowej ramówki z algorytmem wykrywania audycji na żywo
│   ├── models/
│   │   ├── news_item.dart           # Model pojedynczej wiadomości regionalnej z RSS
│   │   └── programme_model.dart     # Model pozycji ramówki oraz model NowPlayingInfo (RDS)
│   ├── screens/
│   │   ├── contact_screen.dart      # Kontakt ze studiem, dedykacja dla Dariusza Moskały, parametry techniczne
│   │   ├── main_navigation_screen.dart # Pasek nawigacji dolnej (5 zakładek) + trwały MiniPlayer
│   │   ├── media_group_screen.dart  # Prezentacja ekosystemu Beskidzkiej Grupy Medialnej z linkami
│   │   ├── news_screen.dart         # Wiadomości regionalne Beskidzka24.pl z odnośnikami do pełnych artykułów
│   │   ├── player_screen.dart       # Główny ekran odtwarzacza, góra Beskidów, sterowanie, pasek akcji
│   │   └── schedule_screen.dart     # Interaktywna ramówka tygodniowa z podziałem na dni (Pon-Nd)
│   ├── services/
│   │   ├── radio_api_service.dart   # Klient HTTP dla API WordPressa, serwera Slotex oraz parser RSS
│   │   └── radio_audio_handler.dart # Mózg audio: just_audio + audio_service, auto-reconnect, live-edge
│   ├── theme/
│   │   └── app_theme.dart           # Kolory Dark Navy, typografia, style przycisków i kart
│   └── widgets/
│       ├── mountain_visualizer.dart # Autorski CustomPainter animacji grani Beskidów
│       └── sleep_timer_sheet.dart   # Dolny arkusz wyłącznika czasowego (Sleep Timer)
├── .github/workflows/
│   └── build_apk.yml                # CI/CD pipeline budujący automatycznie APK i AAB w chmurze
├── preview/                         # Lekki symulator HTML5/PWA do natychmiastowego testowania w przeglądarce
├── pubspec.yaml                     # Manifest zależności i zasobów Fluttera
└── README.md                        # Główna prezentacja projektu
```

---

## 4. SZCZEGÓŁOWY OPIS KLUCZOWYCH MODUŁÓW

### 4.1. Silnik Audio i Zarządzanie Strumieniem (`radio_audio_handler.dart`)
- **Klasa:** `RadioAudioHandler extends BaseAudioHandler with SeekHandler`
- **Adres strumienia:** `https://s3.slotex.pl/shoutcast/7010/stream?sid=1` (128 kbps STEREO, Shoutcast v1/v2).
- **Zarządzanie stanem odtwarzacza:**
  - `play()`:
    1. Przestawia flagę `_isConnecting = true` oraz emituje stan `AudioProcessingState.buffering`.
    2. Bezwzględnie wywołuje `_player.stop()` – czyści wszelkie zastałe bufory pamięci.
    3. Wywołuje `_player.setUrl(streamUrl)` – nawiązuje świeże połączenie z aktualnym punktem czasowym transmisji radiowej.
    4. Rozpoczyna odtwarzanie `_player.play()` i uruchamia cykliczne odpytywanie metadanych `_startMetadataPolling()`.
  - `pause()` i `stop()`:
    1. Przestawiają flagę `_isUserPaused = true` i zatrzymują polling metadanych.
    2. Wywołują `await _player.stop()`. W radiu na żywo zatrzymanie strumienia natychmiast zwalnia gniazdo sieciowe oraz usuwa zbuforowany dźwięk, eliminując efekt przesunięcia czasowego (time-shift) po wznowieniu.
    3. Emitują stan `AudioProcessingState.idle` oraz kontrolki `[MediaControl.play, MediaControl.stop]`.
- **Auto-reconnect:**
  - Nasłuchuje `_player.playerStateStream` oraz `playbackEventStream.onError`. Jeśli połączenie zostanie przerwane (np. przełączenie z Wi-Fi na LTE w podróży), a użytkownik nie nacisnął pauzy (`!_isUserPaused`), odtwarzacz podejmuje automatyczną próbę ponownego połączenia ze strumieniem na żywo.
- **Metadane (Tytuł i Wykonawca):**
  - Strumień odbiera bezpośrednie nagłówki ICY (`_player.icyMetadataStream`).
  - Co 10 sekund (podczas grania) odpytywane jest oficjalne API WordPressa Radia BB.
  - Wykonawca i tytuł są inteligentnie dzielone (obsługa separatorów ` - `, ` — `, ` – ` oraz czyszczenie prefiksów radiowych).

### 4.2. Usługi Sieciowe i API (`radio_api_service.dart`)
1. **`fetchNowPlaying()`**:
   - Primary endpoint: `https://radiobb.pl/wp-json/radio-bb/v1/now-playing` (oficjalne API WordPress stacji).
   - Secondary / Fallback: `http://s3.slotex.pl:7010/stats?sid=1&json=1` (statystyki serwera Shoutcast).
   - Zwraca model `NowPlayingInfo` z wyodrębnionym polem `artist` oraz `songTitle`.
2. **`fetchNews()`**:
   - Pobiera kanał RSS: `https://beskidzka24.pl/feed/`.
   - Parsuje strukturę XML, wyciąga tytuły, opisy (oczyszczając znaczniki HTML i encje `&quot;`, `&#8211;`), datę publikacji oraz miniatury zdjęć z tagów `<enclosure>` lub `<media:content>`.
   - W przypadku braku połączenia zwraca elegancki zestaw wiadomości fallbackowych informujących o rozgłośni.

### 4.3. Ekran Odtwarzacza (`player_screen.dart`)
- **Struktura pionowa (Safe Area):**
  1. Górny pasek: Logo Radia BB, nazwa stacji, pulsujący wskaźnik „NA ŻYWO”.
  2. Karta centralna: Grafika stacji z subtelnym gradientem i poświatą świetlną reagującą na granie.
  3. `MountainVisualizer`: 50-pikselowy animowany wizualizer fal pasm beskidzkich.
  4. Sekcja RDS: Aktualna audycja z ramówki, wyróżniony wykonawca w kolorze błękitnym (`AppTheme.blueSoft`) oraz tytuł utworu w bieli.
  5. Suwak głośności z przyciskiem szybkiego wyciszenia (Mute).
  6. Centralny, podświetlany przycisk Play / Pause ze wskaźnikiem buforowania.
  7. Dolna kapsuła akcji: 3 równe kolumny (`Expanded`):
     - Kolumna 1: Wyłącznik czasowy (`Sleep` / czas pozostały).
     - Kolumna 2: Wskaźnik jakości (`STEREO` z ikoną korektora).
     - Kolumna 3: Przycisk **Udostępnij** (`Icons.share_rounded`).
- **Modalny arkusz udostępniania:**
  - Opcja 1: Natywne udostępnienie przez aplikacje Androida (`Share.share`) z gotowym komunikatem: *„Słucham [Wykonawca] – [Tytuł] w Radiu BB! Posłuchaj na żywo: https://radiobb.pl”*.
  - Opcja 2: Kopiowanie linku radia do schowka z powiadomieniem `SnackBar`.
  - Opcja 3: Bezpośrednie przejście do portalu `radiobb.pl`.

### 4.4. Ramówka Tygodniowa (`schedule_screen.dart` & `schedule_data.dart`)
- Podział na dni tygodnia (Poniedziałek – Niedziela) z wygodnymi kapsułami wyboru dnia.
- Algorytm `ScheduleData.isCurrentProgramme(item)`: sprawdza bieżący dzień tygodnia i godzinę urządzenia, dynamicznie oznaczając trwającą audycję plakietką **„TRWA TERAZ”** ze złotą ramką i ikoną audio.
- Wyróżnienie cogodzinnych serwisów informacyjnych *„Dzieje się w Beskidach”*.

### 4.5. Wiadomości Regionalne i Grupa Medialna (`news_screen.dart`, `media_group_screen.dart`)
- Pełna integracja z `url_launcher` w trybie `LaunchMode.externalApplication`.
- Każdy artykuł oraz medium grupy (np. *Kronika Beskidzka*, *Beskidzka TV*, *Bielsko.Biala.pl*) można otworzyć jednym kliknięciem w przeglądarce telefonu.
- W `AndroidManifest.xml` dodano pełny blok `<queries>` dla protokołów `https`, `http`, `tel`, `mailto` oraz akcji `android.intent.action.SEND`, co gwarantuje natychmiastowe działanie na Androidzie 11, 12, 13 i 14.

---

## 5. HISTORIA ROZWIĄZANYCH PROBLEMÓW (LESSONS LEARNED)

Podczas prac wdrożeniowych i testów na fizycznych smartfonach zidentyfikowano i wyeliminowano 4 kluczowe problemy:

### 1. Problem wyświetlania wykonawcy (Rozwiązany w v1.0.1)
- *Objaw:* Wcześniej na telefonie pokazywał się jedynie statyczny lub surowy ciąg tekstowy bez podziału na artystę i tytuł.
- *Rozwiązanie:* Wprowadzono podwójne źródło metadanych (API WordPressa + strumień ICY) oraz reguły parsowania w `NowPlayingInfo.fromString()`, które dzielą ciągi `Artysta - Tytuł` i formatują artystę w dedykowanej linii z ikoną nuty.

### 2. Otwieranie linków na Androidzie 11+ (Rozwiązany w v1.0.1)
- *Objaw:* Kliknięcie w artykuł wiadomości lub portal grupy medialnej nie otwierało przeglądarki na nowszych telefonach.
- *Rozwiązanie:* Android 11 wprowadził restrykcje widoczności pakietów (*Package Visibility*). Dodano sekcję `<queries>` w `AndroidManifest.xml` z deklaracją intencji `VIEW`, `DIAL`, `SENDTO` i `SEND`.

### 3. Znikający i nieklikalny przycisk „Udostępnij” (Rozwiązany w v1.0.3)
- *Objaw:* Przycisk udostępniania po prawej stronie obok napisu STEREO był częściowo ucięty za krawędzią ekranu i nie reagował na dotyk.
- *Przyczyna:* Wiersz dolny składał się z 3 sztywnych przycisków o sumarycznej szerokości ok. 385 px. Na ekranach o szerokości 360 px występował overflow (przepełnienie wiersza). Elementy wyrenderowane poza obszarem rodzica tracą w silniku Flutter możliwość obsługi gestów (*hit-testing*).
- *Rozwiązanie:* Całkowita przebudowa paska w jednolitą kapsułę z trzema sekcjami `Expanded(child: ...)`. Elementy dzielą przestrzeń w proporcji 1:1:1, a przycisk „Udostępnij” został bezpiecznie cofnięty w lewo z pełną obsługą dotyku (`InkWell`).

### 4. Opóźnienie czasowe dźwięku po pauzie i rozjazd z RDS (Rozwiązany w v1.0.4)
- *Objaw:* Użytkownik zatrzymywał radio przyciskiem „Pauza”. Po pewnym czasie (np. 2 minutach) włączał odtwarzanie. Na ekranie pojawiał się nowy utwór z internetu, ale w głośniku leciał stary utwór z momentu pauzy. Powstawało trwałe przesunięcie czasowe (dźwięk był opóźniony o czas trwania pauzy).
- *Przyczyna:* W odtwarzaczu `just_audio` (ExoPlayer) standardowe `pause()` zatrzymywało tylko rendering audio, ale zachowywało pobrany strumień w buforze pamięci. Po wywołaniu `play()` odtwarzacz nie łączył się na nowo, lecz kontynuował odtwarzanie starego bufora. W tym samym czasie serwis metadanych pobierał bieżący utwór ze strony www.
- *Rozwiązanie:* W radiu na żywo wprowadzono zasadę **Zero Latency Live Edge**. Metoda `pause()` i `stop()` wywołuje `_player.stop()`, co natychmiast czyści bufor pamięci telefonu. Każde wywołanie `play()` otwiera **nowe, świeże połączenie HTTP ze studiem na żywo**, gwarantując 0 sekund opóźnienia i natychmiastową synchronizację dźwięku z napisami.

---

## 6. ZADANIA I PYTANIA DLA AUDYTU GEMINI (SESJA „4 ARGON”)

Model Gemini przeprowadzający audyt proszony jest o wnikliwą analizę kodu źródłowego w repozytorium i odniesienie się do poniższych obszarów:

### Obszar 1: Architektura i Zarządzanie Stanem
- Obecnie aplikacja korzysta z reaktywnych strumieni `AudioHandler` (`playbackState`, `mediaItem`, `sleepTimerStream`) oraz `StreamBuilder` / `StatefulWidget` bez zewnętrznych bibliotek typu Bloc, Riverpod czy Provider.
- **Pytanie audytowe:** Czy obecna architektura jest optymalna i wystarczająca dla aplikacji radiowej, czy sugerowane jest wprowadzenie dedykowanego zarządcy stanu (np. Riverpod)? Jakie byłyby zyski, a jakie koszty/ryzyka?

### Obszar 2: Odporność Sieciowa i Trudne Warunki Górskie
- Beskidy to specyficzny region z dolinami (np. Wisła, Szczyrk, Istebna, Brenna), gdzie telefony często przełączają się między masztami BTS, tracą zasięg LTE lub wpadają w zasięg przygraniczny (Czechy/Słowacja).
- **Pytanie audytowe:** Czy mechanizmy w `radio_audio_handler.dart` (reconnect, buforowanie wstępne, wykrywanie utraty pakietów) są maksymalnie odporne? Czy warto skonfigurować dedykowane parametry `LoadControl` lub `DefaultHttpDataSource` w ExoPlayerze?

### Obszar 3: Tryb Offline i Pamięć Podręczna (Cache)
- Obecnie wiadomości RSS oraz ramówka są pobierane na żywo z sieci.
- **Pytanie audytowe:** Czy należy wdrożyć lokalną bazę danych (np. `Hive` lub `shared_preferences`) do buforowania ostatnich 20 wiadomości oraz harmonogramu, aby użytkownik bez dostępu do sieci mógł przeczytać wiadomości i sprawdzić ramówkę?

### Obszar 4: Zgodność ze Sklepem Google Play i Android 15
- Plik `android/app/build.gradle` ma ustawione `compileSdk 34` i `targetSdk 34`.
- **Pytania audytowe:**
  1. Jakie wymagania nakłada Google Play w 2026 roku (np. Target SDK 35, wsparcie stron pamięci 16 KB w NDK dla Androida 15)?
  2. Jakie kroki należy podjąć w kwestii podpisania wersji produkcyjnej (Keystore, `key.properties`, Google Play App Signing)?
  3. Czy polityka prywatności (*Privacy Policy*) spełnia wymogi dla aplikacji z uprawnieniami Foreground Service?

### Obszar 5: Android Auto i Samochód
- Wielu słuchaczy Radia BB słucha stacji w samochodzie.
- **Pytanie audytowe:** `audio_service` udostępnia podstawy `MediaBrowserServiceCompat`. Co należy dopracować w `MainActivity.kt` i w strukturze `MediaItem`, aby Radio BB pojawiło się na ekranie głównym Android Auto jako ikona stacji z możliwością bezpośredniego włączenia?

### Obszar 6: Ekspansja na Apple iOS
- Kod napisano we Flutterze, ale konfiguracja natywna skupiała się na Androidzie.
- **Pytanie audytowe:** Co dokładnie jest potrzebne, aby zbudować aplikację na iPhone'a (iOS):
  - Konfiguracja `Info.plist` (Background Modes: Audio, AirPlay).
  - Obsługa `AVAudioSession` w iOS.
  - Generowanie certyfikatów i profili w Apple Developer Program.

### Obszar 7: Jakość Kodu, Bezpieczeństwo i Testy
- W projekcie nie ma obecnie katalogu `test/`.
- **Pytanie audytowe:** Jakie kluczowe testy jednostkowe i widżetowe należy napisać w pierwszej kolejności (np. testy parsera RSS, testy algorytmu wykrywania trwającej audycji, testy podziału RDS wykonawca-tytuł)?
- Czy włączenie R8 / ProGuard (`minifyEnabled true`, `shrinkResources true`) jest zalecane i czy nie wpłynie na odbicie klas `just_audio`?

---

## 7. OCZEKIWANY FORMAT ODPOWIEDZI / RAPORTU Z AUDYTU

Prosimy, aby model audytujący w sesji **4 Argon** przedstawił swój raport w następującym podziale:

1. **Ocena Ogólna (Executive Summary)**: Ocena dojrzałości projektu w skali 1–10, główne mocne strony i kluczowe ryzyka.
2. **Szczegółowy Audyt Architektury i Kodu**:
   - Silnik audio i synchronizacja Live
   - Zarządzanie stanem i interfejs UI
   - Obsługa sieci, błędów i RSS
   - Warstwa natywna Androida i uprawnienia
3. **Zestawienie Znalezionych Usprawnień (Findings & Recommendations)**:
   - Tabela z podziałem na wagę (Krytyczna / Ważna / Drobna), opisem i proponowanym rozwiązaniem.
4. **Strategiczna Mapa Drogowa (Actionable Roadmap)**:
   - **Krok 1: Wdrożenia Natychmiastowe (Quick Wins)** – np. testy jednostkowe, optymalizacja R8, Polityka Prywatności.
   - **Krok 2: Usprawnienia Kluczowe (Core Improvements)** – np. Android Auto, cache offline wiadomości, auto-retry w tunelach.
   - **Krok 3: Rozszerzenia Przyszłościowe (Future Features)** – np. wersja iOS, powiadomienia Push o ulubionych audycjach, podcasty / archiwum audycji.

---
*Dokumentacja przygotowana dla projektu Radia BB (Beskidzka Grupa Medialna).*
