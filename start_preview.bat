@echo off
title Radio BB - Uruchomienie Podgladu Aplikacji Mobilnej
cd /d "%~dp0"

echo ========================================================
echo   RADIO BB - Aplikacja Mobilna Android (Podglad na zywo)
echo ========================================================
echo.
echo [1/2] Sprawdzanie srodowiska Python...
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Python nie jest w PATH. Otwieram podglad bezposrednio w przegladarce...
    start "" "Podglad_Aplikacji_RadioBB.html"
    pause
    exit /b
)

echo [2/2] Uruchamianie serwera i otwieranie przegladarki...
start "" "http://localhost:8080/preview/index.html"
python run_preview.py

pause
