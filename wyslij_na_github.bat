@echo off
title Radio BB - Wysylanie projektu na GitHub
cd /d "%~dp0"
set GIT_EXE=%USERPROFILE%\.mingit\cmd\git.exe

echo ================================================================
echo   RADIO BB - Automatyczne wyslanie projektu na Twoj GitHub
echo ================================================================
echo.
echo Wklej ponizej adres URL repozytorium, ktore wlasnie utworzyles
echo (np. https://github.com/TwojaNazwa/radio-bb.git):
echo.
set /p REPO_URL="Podaj adres URL z GitHuba: "

if "%REPO_URL%"=="" (
    echo [BLAD] Nie podano adresu URL. Sprobuj ponownie.
    pause
    exit /b
)

echo.
echo [1/3] Konfiguracja polaczenia z GitHubem...
"%GIT_EXE%" remote remove origin >nul 2>&1
"%GIT_EXE%" remote add origin %REPO_URL%
"%GIT_EXE%" branch -M main

echo [2/3] Wysylanie plikow do chmury (moze pojawic sie okno logowania GitHub)...
"%GIT_EXE%" push -u origin main

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [UWAGA] Jesli pojawil sie monit o zalogowanie, zaloguj sie w przegladarce.
    echo Jesli wysylanie sie nie powiodlo, sprawdz czy adres URL jest poprawny.
    pause
    exit /b
)

echo.
echo ================================================================
echo   SUKCES! Pliki zostaly przeslane na Twoje konto GitHub.
echo ================================================================
echo.
echo Superkomputer w chmurze (GitHub Actions) wlasnie zaczal budowac
echo Twoj plik RadioBB.apk oraz paczke do Sklepu Google Play!
echo.
echo Otwieram strone budowania w Twojej przegladarce...
start "" "%REPO_URL%/actions"
echo.
echo Za okolo 3-4 minuty plik bedzie gotowy do pobrania w zakladce Artifacts.
pause
