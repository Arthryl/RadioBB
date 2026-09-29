# 📻 Radio BB – Oficjalna Aplikacja Mobilna (Android)

> **Projekt stworzony jako specjalny prezent dla Dariusza Moskały**  
> Twórcy i Właściciela **Radia BB** oraz **Beskidzkiej Grupy Medialnej**  
> (*Kronika Beskidzka*, *Beskidzka24.pl*, *Beskidzka TV*, *Bielsko.Biala.pl*, *Głos Ziemi Cieszyńskiej*).

---

## 🌟 O projekcie

Aplikacja mobilna dla **Radia BB** (*Beskidzkie brzmienia* – [radiobb.pl](https://radiobb.pl)) została zaprojektowana zgodnie z najnowszymi standardami systemu Android (Material Design 3 / AMOLED Dark Navy), zachowując 100% spójności wizualnej z oficjalną stroną stacji.

Aplikacja działa w oparciu o silnik **Flutter + Android Foreground Audio Service** (`just_audio` & `audio_service`), zapewniając stabilne odtwarzanie muzyki w tle, integrację ze słuchawkami Bluetooth, radiem samochodowym (**Android Auto**) oraz powiadomieniami na ekranie blokady.

---

## 🚀 Kluczowe funkcjonalności

1. **Strumieniowanie Live w wysokiej jakości**:
   - Bezpośredni strumień radiowy Shoutcast: `https://s3.slotex.pl:7010/stream/1/?sid=1` (128 kbps, 44.1 kHz STEREO).
   - Mechanizm **Auto-Reconnect**: płynne wznawianie odtwarzania przy zmianie sieci (Wi-Fi ↔ LTE/5G).
   - **Audio Focus**: automatyczne wyciszanie/pauzowanie przy połączeniach telefonicznych lub komunikatach nawigacji GPS.
2. **Odtwarzanie w tle i sterowanie systemowe**:
   - Usługa **Foreground Service** z powiadomieniem `MediaStyle`.
   - Pełne sterowanie (Play/Pause/Stop) na ekranie blokady i belce powiadomień.
   - Obsługa przycisków na słuchawkach przewodowych i bezprzewodowych Bluetooth (AVRCP).
3. **Dynamiczne metadane „Teraz gramy” (RDS)**:
   - Automatyczna synchronizacja z oficjalnym API [radiobb.pl/wp-json/radio-bb/v1/now-playing](https://radiobb.pl/wp-json/radio-bb/v1/now-playing).
   - Wyświetlanie aktualnego wykonawcy i tytułu piosenki na żywo.
4. **Pełna Ramówka Tygodniowa**:
   - Oficjalny harmonogram audycji Radia BB (od poniedziałku do niedzieli).
   - Automatyczne wykrywanie i oznaczanie audycji **TRWA TERAZ** na podstawie zegara urządzenia.
   - Informacja o cogodzinnych serwisach informacyjnych *„Dzieje się w Beskidach”*.
5. **Wiadomości Regionalne (Beskidzka24.pl)**:
   - Zintegrowany kanał informacyjny RSS z najświeższymi wiadomościami z Bielska-Białej, Żywca, Cieszyna i okolic.
6. **Ekosystem Beskidzkiej Grupy Medialnej**:
   - Dedykowana sekcja prezentująca media grupy: *Kronikę Beskidzką*, *Beskidzką TV*, *Bielsko.Biala.pl*, *Beskidzką24.pl* oraz *Głos Ziemi Cieszyńskiej*.
7. **Wyłącznik czasowy (Sleep Timer)**:
   - Opcja automatycznego wyłączenia po 15, 30, 45, 60 lub 90 minutach – idealna funkcja do zasypiania przy dźwiękach Radia BB.
8. **Animowana Grań Beskidów (Mountain Visualizer)**:
   - Dynamiczny wizualizer fal audio nawiązujący do beskidzkich szczytów i oficjalnej identyfikacji graficznej rozgłośni.

---

## 📱 Natychmiastowy Podgląd Aplikacji (Live Preview)

Przed kompilacją pliku APK możesz natychmiast przetestować działanie aplikacji (posłuchać radia, sprawdzić ramówkę i przetestować funkcje) na swoim komputerze:

1. Wystarczy dwukrotnie kliknąć plik **`start_preview.bat`**  
   *(lub wpisać w terminalu: `python run_preview.py`)*.
2. W domyślnej przeglądarce otworzy się interaktywny symulator aplikacji mobilnej w ramie smartfona.

---

## 📦 Jak skompilować plik instalacyjny (.APK / .AAB)

Projekt jest w pełni przygotowany do wygenerowania pliku instalacyjnego na telefon oraz paczki do **Google Play**.

### Sposób 1: Automatyczna kompilacja w chmurze (GitHub Actions – Bez instalowania SDK)
W repozytorium znajduje się skonfigurowany plik [`.github/workflows/build_apk.yml`](.github/workflows/build_apk.yml).
1. Umieść projekt w prywatnym lub publicznym repozytorium GitHub.
2. Wejdź w zakładkę **Actions** i uruchom zadanie **Build RadioBB Android Release**.
3. Po 3 minutach pobierz gotowy plik **`RadioBB-Release-APK`** bezpośrednio na telefon lub komputer!

### Sposób 2: Kompilacja lokalna (z zainstalowanym Flutter SDK)
W folderze projektu wykonaj polecenia:
```bash
# 1. Pobranie zależności
flutter pub get

# 2. Budowa pliku instalacyjnego APK na prezent:
flutter build apk --release

# Gotowy plik znajdziesz w:
# build/app/outputs/flutter-apk/app-release.apk

# 3. Budowa paczki produkcyjnej do Sklepu Google Play (AAB):
flutter build appbundle --release
```

---

## 🎁 Jak przekazać prezent Dariuszowi Moskale

1. **Wysyłka pliku APK**:
   - Zmień nazwę wygenerowanego pliku `app-release.apk` na `RadioBB-v1.0.apk`.
   - Prześlij go Dariuszowi przez WhatsApp, e-mail lub wręcz na eleganckim pendrive.
2. **Instalacja na telefonie z Androidem**:
   - Dariusz klika w plik na swoim telefonie.
   - Android zapyta o zgodę na *„Instalację z tego źródła”* (zgodę należy potwierdzić).
   - Aplikacja pojawi się na pulpicie telefonu z oficjalną ikoną Radia BB!
3. **Publikacja w Sklepie Google Play (Google Play Console)**:
   - Przygotowany plik `app-release.aab` jest w 100% zgodny z wymaganiami Google Play Store.
   - W folderze `assets/icons/play_store_512.png` znajduje się oficjalna ikona w rozdzielczości 512×512 px wymagana przez konsolę Google Play.
   - Identyfikator pakietu aplikacji: `pl.radiobb.app`.

---

## 📂 Struktura katalogów projektu

```
ANTIGRAVITY - PROJEKT - RadioBB/
├── assets/
│   ├── icons/                 # Ikony Google Play 512x512 oraz launchery
│   └── images/                # Oficjalne logo, grafiki, logotypy BGM
├── android/                   # Konfiguracja natywna Androida (Manifest, Gradle, usługi audio)
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
├── run_preview.py             # Serwer podglądu aplikacji
├── start_preview.bat          # Skrót do uruchomienia podglądu jednym kliknięciem
└── pubspec.yaml               # Zależności Fluttera
```

---
*Radio BB – Beskidzkie brzmienia. Twój lokalny głos. Najlepsza muzyka.*
