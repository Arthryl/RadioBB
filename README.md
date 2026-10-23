# 📻 Radio BB – Oficjalna Aplikacja Mobilna (Android)

> **Projekt stworzony jako specjalny prezent dla Dariusza Moskały**  
> Twórcy i Właściciela **Radia BB** oraz **Beskidzkiej Grupy Medialnej**  
> (*Kronika Beskidzka*, *Beskidzka24.pl*, *Beskidzka TV*, *Bielsko.Biala.pl*, *Głos Ziemi Cieszyńskiej*).

---

## 📌 Aktualna Wersja: `v1.0.4+5` (Produkcyjna)

Pliki instalacyjne gotowe do wgrania na telefon lub do Sklepu Google Play znajdują się w katalogu:
📁 **[`Gotowa_Aplikacja_Android/`](Gotowa_Aplikacja_Android/)**
- **`RadioBB_v1.0.4.apk`** *(oraz `RadioBB.apk`)* – gotowy pakiet APK dla systemu Android.
- **`RadioBB_v1.0.4.aab`** *(oraz `RadioBB-GooglePlay.aab`)* – pakiet produkcyjny Google Play App Bundle.

> 🔍 **Audyt kodu i przekazanie projektu:**  
> Szczegółowa dokumentacja architektoniczna i wytyczne do audytu dla modelu Gemini / zespołu deweloperskiego znajdują się w pliku:  
> 📄 **[`AUDYT_PRZEKAZANIE_PROJEKTU.md`](AUDYT_PRZEKAZANIE_PROJEKTU.md)**  
> Gotowy prompt do wklejenia w nowym czacie: 📄 **[`PROMPT_DLA_NOWEGO_CZATU_GEMINI_4.md`](PROMPT_DLA_NOWEGO_CZATU_GEMINI_4.md)**

---

## 🌟 O projekcie

Aplikacja mobilna dla **Radia BB** (*Beskidzkie brzmienia* – [radiobb.pl](https://radiobb.pl)) została zaprojektowana zgodnie z najnowszymi standardami systemu Android (Material Design 3 / AMOLED Dark Navy), zachowując 100% spójności wizualnej z oficjalną stroną stacji.

Aplikacja działa w oparciu o silnik **Flutter + Android Foreground Audio Service** (`just_audio` & `audio_service`), zapewniając stabilne odtwarzanie muzyki w tle, integrację ze słuchawkami Bluetooth, radiem samochodowym (**Android Auto**) oraz powiadomieniami na ekranie blokady.

---

## 🚀 Kluczowe funkcjonalności

1. **Strumieniowanie Live w wysokiej jakości**:
   - Bezpośredni strumień radiowy Shoutcast: `https://s3.slotex.pl/shoutcast/7010/stream?sid=1` (128 kbps, 44.1 kHz STEREO).
   - Mechanizm **Auto-Reconnect**: płynne wznawianie odtwarzania przy zmianie sieci (Wi-Fi ↔ LTE/5G).
   - **Audio Focus**: automatyczne wyciszanie/pauzowanie przy połączeniach telefonicznych lub komunikatach nawigacji GPS.
   - **Natychmiastowa synchronizacja na żywo (Live-Edge, v1.0.4)**: funkcja pauzy natychmiast czyści bufor pamięci, a wznowienie odtwarza strumień w 100% na żywo w czasie rzeczywistym.
2. **Odtwarzanie w tle i sterowanie systemowe**:
   - Usługa **Foreground Service** z powiadomieniem `MediaStyle`.
   - Pełne sterowanie (Play/Pause/Stop) na ekranie blokady i belce powiadomień.
   - Obsługa przycisków na słuchawkach przewodowych i bezprzewodowych Bluetooth (AVRCP).
3. **Dynamiczne metadane „Teraz gramy” (RDS)**:
   - Automatyczna synchronizacja z oficjalnym API [radiobb.pl/wp-json/radio-bb/v1/now-playing](https://radiobb.pl/wp-json/radio-bb/v1/now-playing) oraz bezpośrednim nagłówkiem ICY strumienia.
   - Precyzyjny podział na wykonawcę i tytuł utworu.
4. **Pełna Ramówka Tygodniowa**:
   - Oficjalny harmonogram audycji Radia BB (od poniedziałku do niedzieli).
   - Automatyczne wykrywanie i oznaczanie audycji **TRWA TERAZ** na podstawie zegara urządzenia.
   - Informacja o cogodzinnych serwisach informacyjnych *„Dzieje się w Beskidach”*.
5. **Wiadomości Regionalne (Beskidzka24.pl)**:
   - Zintegrowany kanał informacyjny RSS z najświeższymi wiadomościami z Bielska-Białej, Żywca, Cieszyna i okolic.
   - Możliwość otwarcia pełnego artykułu w przeglądarce telefonu.
6. **Ekosystem Beskidzkiej Grupy Medialnej**:
   - Dedykowana sekcja prezentująca media grupy: *Kronikę Beskidzką*, *Beskidzką TV*, *Bielsko.Biala.pl*, *Beskidzką24.pl* oraz *Głos Ziemi Cieszyńskiej*.
   - Bezpośrednie odnośniki do portali i mediów grupy.
7. **Wyłącznik czasowy (Sleep Timer)**:
   - Opcja automatycznego wyłączenia po 15, 30, 45, 60 lub 90 minutach – idealna funkcja do zasypiania przy dźwiękach Radia BB.
8. **Animowana Grań Beskidów (Mountain Visualizer)**:
   - Dynamiczny wizualizer fal audio nawiązujący do beskidzkich szczytów i oficjalnej identyfikacji graficznej rozgłośni.
9. **Dedykowany Panel Udostępniania**:
   - Responsywny panel (Sleep Timer | Jakość STEREO | Udostępnij) z integracją systemowego mechanizmu udostępniania Androida (WhatsApp, Messenger, SMS, schowek).

---

## 🛠️ Historia Wersji i Zrealizowanych Poprawek

- **v1.0.0**: Wersja początkowa aplikacji, architektura audio w tle, ekrany ramówki, wiadomości i grupy BGM.
- **v1.0.1**: 
  - Dynamiczny podział wykonawca / tytuł z API i strumienia ICY.
  - Dodanie deklaracji `<queries>` w `AndroidManifest.xml` (zapewnienie otwierania linków www, telefonu i e-mail w Androidzie 11+).
- **v1.0.2**: 
  - Dodanie dedykowanego panelu udostępniania stacji z opcjami społecznościowymi i kopiowaniem linku.
- **v1.0.3**: 
  - Przebudowa dolnego paska akcji na responsywną, zintegrowaną kapsułę (`Expanded` w 3 kolumnach).
  - Rozwiązanie problemu overflow i uciętego przycisku „Udostępnij” na węższych ekranach smartfonów oraz przywrócenie 100% responsywności na dotyk.
- **v1.0.4**: 
  - Naprawa synchronizacji strumienia na żywo po pauzie. Zastąpienie buforowanej pauzy całkowitym czyszczeniem bufora i świeżym łączeniem z live-edge, co wyeliminowało efekt opóźnienia dźwięku względem napisów i strony www.

---

## 📱 Natychmiastowy Podgląd Aplikacji (Live Preview)

Przed kompilacją pliku APK możesz natychmiast przetestować działanie aplikacji (posłuchać radia, sprawdzić ramówkę i przetestować funkcje) na swoim komputerze:

1. Wystarczy dwukrotnie kliknąć plik **`start_preview.bat`**  
   *(lub wpisać w terminalu: `python run_preview.py`)*.
2. W domyślnej przeglądarce otworzy się interaktywny symulator aplikacji mobilnej w ramie smartfona.

---

## 📦 Jak skompilować plik instalacyjny (.APK / .AAB)

### Sposób 1: Automatyczna kompilacja w chmurze (GitHub Actions)
W repozytorium znajduje się skonfigurowany plik [`.github/workflows/build_apk.yml`](.github/workflows/build_apk.yml).
1. Każdy `git push` na gałąź `main` automatycznie buduje wersję produkcyjną APK i AAB na maszynie Ubuntu w chmurze GitHub.
2. Gotowe pliki można pobrać z zakładki **Actions** -> **Artifacts**.

### Sposób 2: Kompilacja lokalna (z zainstalowanym Flutter SDK)
```bash
# 1. Pobranie zależności
flutter pub get

# 2. Budowa pliku instalacyjnego APK:
flutter build apk --release

# 3. Budowa paczki produkcyjnej do Sklepu Google Play (AAB):
flutter build appbundle --release
```

---

## 📂 Struktura katalogów projektu

```
ANTIGRAVITY - PROJEKT - RadioBB/
├── assets/
│   ├── icons/                 # Ikony Google Play 512x512 oraz launchery
│   └── images/                # Oficjalne logo, grafiki, logotypy BGM
├── android/                   # Konfiguracja natywna Androida (Manifest, Gradle, usługi audio)
├── Gotowa_Aplikacja_Android/  # Gotowe skompilowane pakiety APK i AAB v1.0.4
├── lib/
│   ├── main.dart              # Punkt startowy, konfiguracja AudioService
│   ├── theme/app_theme.dart   # Kolorystyka i typografia Radia BB
│   ├── models/                # Modele audycji, utworów i wiadomości
│   ├── data/schedule_data.dart# Pełna ramówka tygodniowa Radio BB
│   ├── services/              # Silnik audio (just_audio) oraz API (Now Playing, RSS)
│   ├── screens/               # Ekrany: Słuchaj, Ramówka, Wiadomości, BGM, Kontakt
│   └── widgets/               # Wizualizer Grani Beskidów, Sleep Timer
├── preview/                   # Interaktywny symulator mobilny (HTML5/CSS3/JS PWA)
├── .github/workflows/         # Automatyczny build APK w chmurze
├── AUDYT_PRZEKAZANIE_PROJEKTU.md # Kompletny raport techniczny i wytyczne do audytu
├── PROMPT_DLA_NOWEGO_CZATU_GEMINI_4.md # Gotowy prompt dla audytora Gemini w nowej sesji
└── pubspec.yaml               # Zależności Fluttera
```

---
*Radio BB – Beskidzkie brzmienia. Twój lokalny głos. Najlepsza muzyka.*
