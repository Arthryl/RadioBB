@echo off
title Radio BB - Wysylanie projektu na GitHub (Arthryl/RadioBB)
cd /d "%~dp0"
set GIT_EXE=%USERPROFILE%\.mingit\cmd\git.exe

echo ================================================================
echo   RADIO BB - Wysylanie projektu na Twoje konto: Arthryl/RadioBB
echo ================================================================
echo.
echo [1/2] Przygotowanie do przeslania plikow...
"%GIT_EXE%" branch -M main

echo [2/2] Wysylanie plikow do chmury GitHub...
echo (Jesli pojawi sie okno logowania, kliknij 'Sign in with your browser')
echo.
"%GIT_EXE%" push -u origin main

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ================================================================
    echo [UWAGA] Jesli wysylanie wymaga autoryzacji:
    echo 1. Zaloguj sie w oknie, ktore sie pojawilo.
    echo 2. Jesli potrzebujesz Personal Access Token (haslo do GitHuba),
    echo    wygeneruj je na: https://github.com/settings/tokens
    echo ================================================================
    pause
    exit /b
)

echo.
echo ================================================================
echo   SUKCES! Pliki zostaly przeslane na Twoje konto GitHub!
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
