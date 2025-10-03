@echo off
title Atualizador Starter
color 0A

REM -----------------------------
REM Caminho da pasta Startup
REM -----------------------------
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

echo ================================
echo Limpando arquivos antigos do Startup...
echo ================================
del /f /s /q "%STARTUP_FOLDER%\*.*" >nul 2>&1
for /d %%x in ("%STARTUP_FOLDER%\*") do rd /s /q "%%x" >nul 2>&1

REM -----------------------------
REM Copiando Starter.bat para Startup
REM -----------------------------
echo ================================
echo Criando starter.bat no Startup...
echo ================================
copy /y "starter.bat" "%STARTUP_FOLDER%\starter.bat" >nul

REM -----------------------------
REM Executando Starter.bat
REM -----------------------------
echo ================================
echo Executando starter.bat...
echo ================================
start "" "%STARTUP_FOLDER%\starter.bat"

echo.
echo ✅ Atualização concluída!
exit
