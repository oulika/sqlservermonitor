@echo off
setlocal
cd /d "%~dp0"

py -3.8 -m PyInstaller ^
  --noconfirm ^
  --clean ^
  --windowed ^
  --name SIDMMonitor ^
  --icon "assets\red_skull_icon.ico" ^
  --hidden-import pyodbc ^
  --add-data "config.example.ini;." ^
  --add-data "assets\red_skull_icon.ico;assets" ^
  sidm_monitor\__main__.py

if errorlevel 1 exit /b %errorlevel%

copy /Y config.example.ini dist\SIDMMonitor\config.example.ini >nul
if exist config.ini copy /Y config.ini dist\SIDMMonitor\config.ini >nul

echo.
echo Build output: dist\SIDMMonitor\SIDMMonitor.exe
endlocal
