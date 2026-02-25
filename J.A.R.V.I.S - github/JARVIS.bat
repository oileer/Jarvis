@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Iniciando J.A.R.V.I.S + Agent Starter

REM ====== CONFIG ======
set "AGENT_DIR=C:\Users\Euller\Desktop\J.A.R.V.I.S"
set "JARVIS_DIR=C:\Users\Euller\Desktop\J.A.R.V.I.S"
set "VENV_NAME=venv"
REM ====================

REM Pasta e arquivo de log (garantido)
set "LOG_DIR=%TEMP%\jarvis_launcher"
set "LOG_FILE=%LOG_DIR%\agent_log.txt"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%" >nul 2>&1

echo Iniciando Agent Starter...
cd /d "%AGENT_DIR%"

REM Zera/cria o arquivo de log com seguranca
type nul > "%LOG_FILE%"

REM Roda o pnpm dev e manda TUDO pro log
start "Agent Starter" /min cmd /c "pnpm dev >> ""%LOG_FILE%"" 2>&1"

echo Aguardando URL aparecer no log...

:WAIT_URL
timeout /t 1 /nobreak >nul

REM Procura a URL no log
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
REM Se vier tipo "Local: http://localhost:5173/"
for %%A in (%URL%) do (
  echo %%A | findstr /R "^http://localhost:[0-9][0-9]*" >nul && set "FINAL_URL=%%A"
  echo %%A | findstr /R "^http://127\.0\.0\.1:[0-9][0-9]*" >nul && set "FINAL_URL=%%A"
)

if not defined FINAL_URL set "FINAL_URL=http://localhost:3000"

echo URL detectada: %FINAL_URL%
echo Abrindo no Chrome...
start chrome "%FINAL_URL%"

echo Iniciando J.A.R.V.I.S...
cd /d "%JARVIS_DIR%"
start "J.A.R.V.I.S" /min cmd /k "call %VENV_NAME%\Scripts\activate.bat && python agent.py dev"

exit
