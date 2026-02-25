@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Iniciando J.A.R.V.I.S + Agent Starter

REM ====== CONFIG ======
set "AGENT_DIR=C:\Users\Euller\Desktop\J.A.R.V.I.S - github"
set "JARVIS_DIR=C:\Users\Euller\Desktop\J.A.R.V.I.S - github"
set "VENV_NAME=venv"
set "CHROME_PATH=C:\Users\Euller\Documents\chrome-win\chrome-win\chrome.exe"
REM ====================

REM Pasta e arquivo de log
set "LOG_DIR=%TEMP%\jarvis_launcher"
set "LOG_FILE=%LOG_DIR%\agent_log.txt"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1

echo Iniciando Agent Starter...
cd /d "%AGENT_DIR%"

type nul > "%LOG_FILE%"

start "Agent Starter" /min cmd /c "pnpm dev >> ""%LOG_FILE%"" 2>&1"

echo Aguardando URL aparecer no log...

:WAIT_URL
timeout /t 1 /nobreak >nul

for /f "usebackq delims=" %%U in (`
  findstr /R "http://localhost:[0-9][0-9]*" "%LOG_FILE%" 2^>nul
`) do (
  set "URL=%%U"
  goto :FOUND
)

for /f "usebackq delims=" %%U in (`
  findstr /R "http://127\.0\.0\.1:[0-9][0-9]*" "%LOG_FILE%" 2^>nul
`) do (
  set "URL=%%U"
  goto :FOUND
)

goto :WAIT_URL

:FOUND
for %%A in (%URL%) do (
  echo %%A | findstr /R "^http://localhost:[0-9][0-9]*" >nul && set "FINAL_URL=%%A"
  echo %%A | findstr /R "^http://127\.0\.0\.1:[0-9][0-9]*" >nul && set "FINAL_URL=%%A"
)

if not defined FINAL_URL set "FINAL_URL=http://localhost:3000"

echo URL detectada: %FINAL_URL%
echo Abrindo no Chrome custom...

start "" "%CHROME_PATH%" --app=%FINAL_URL%

echo Iniciando J.A.R.V.I.S...
cd /d "%JARVIS_DIR%"
start "J.A.R.V.I.S - github" /min cmd /k "call %VENV_NAME%\Scripts\activate.bat && python agent.py dev"

exit
