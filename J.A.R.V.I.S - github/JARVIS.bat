@echo off
title ATLAS JARVIS SYSTEM

echo ==========================
echo INICIANDO ATLAS...
echo ==========================

:: ==========================
:: BACKEND (JARVIS) - MINIMIZADO
:: ==========================
cd /d "C:\Users\Euller\Desktop\Jarvis"

echo Iniciando Backend...
start /min cmd /k "venv\Scripts\activate && python agent.py dev"

:: ==========================
:: FRONTEND (NEXT) - MINIMIZADO
:: ==========================
cd /d "C:\Users\Euller\Desktop\jvs_auth_92kx-main\Layout Jarvis\agent-starter-react-main"

echo Iniciando Frontend...
start /min cmd /k "pnpm dev"

:: ==========================
:: AGUARDAR INICIALIZAÇÃO
:: ==========================
echo Aguardando serviços subirem...
timeout /t 6 > nul

:: ==========================
:: ABRIR CHROME (MODO APP)
:: ==========================
start "" "C:\Users\Euller\Downloads\chrome-win\chrome-win\chrome.exe" --app=http://localhost:3000

echo ==========================
echo SISTEMA ONLINE
echo ==========================

exit