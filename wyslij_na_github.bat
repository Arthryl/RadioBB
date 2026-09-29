@echo off
title Radio BB - Wysylanie projektu na GitHub (Arthryl/RadioBB)
cd /d "%~dp0"
set GIT_EXE=%USERPROFILE%\.mingit\cmd\git.exe

echo ================================================================
echo   RADIO BB - Wysylanie projektu na Twoje konto: Arthryl/RadioBB
echo ================================================================
echo.
echo Aby bezpiecznie wyslac pliki, GitHub wymaga wygenerowania
echo bezpiecznego klucza dostepu (Personal Access Token).
echo.
echo Jesli jeszcze go nie masz, otworz w przegladarce:
echo https://github.com/settings/tokens/new
echo (zaznacz ptaszek 'repo' i kliknij na dole 'Generate token')
echo.
echo ================================================================
set /p GH_TOKEN="Wklej tutaj swoj token z GitHuba (zaczyna sie od ghp_...): "

if "%GH_TOKEN%"=="" (
    echo [BLAD] Nie podano tokenu. Sprobuj ponownie.
    pause
    exit /b
)

echo.
echo [1/2] Konfiguracja bezpiecznego polaczenia...
"%GIT_EXE%" branch -M main
"%GIT_EXE%" remote remove origin >nul 2>&1
"%GIT_EXE%" remote add origin https://Arthryl:%GH_TOKEN%@github.com/Arthryl/RadioBB.git

echo.
echo [2/2] Przesylanie plikow do chmury GitHub...
"%GIT_EXE%" push -u origin main

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [BLAD] Nie udalo sie przeslac plikow. Sprawdz czy poprawnie skopiowales caly token.
    pause
    exit /b
)

echo.
echo ================================================================
echo   SUKCES! Wszystkie pliki zostaly przeslane na Twoj GitHub!
echo ================================================================
echo.
echo Superkomputer w chmurze (GitHub Actions) wlasnie zaczal budowac
echo Twoj plik RadioBB.apk oraz paczke do Sklepu Google Play!
echo.
echo Otwieram strone budowania w Twojej przegladarce...
start "" "https://github.com/Arthryl/RadioBB/actions"
echo.
echo Za okolo 3 minuty plik bedzie gotowy do pobrania w zakladce Artifacts.
pause
