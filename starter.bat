@echo off
title Instalando atualizador de papel de parede (oculto)
color 0A

REM ==========================================
REM CONFIGURAÇÕES
REM ==========================================
set "SAVE_DIR=C:\ProgramData\TrulWallpaper"
set "BAT_FILE=%SAVE_DIR%\atualizar_wallpaper.bat"
set "VBS_FILE=%SAVE_DIR%\iniciar_invisivel.vbs"
set "TASK_NAME=TrulWallpaperUpdater"
set "BAT_URL=https://raw.githubusercontent.com/mathaussobrinho/trul/main/atualizar_wallpaper.bat"

REM Cria pasta se não existir
if not exist "%SAVE_DIR%" mkdir "%SAVE_DIR%"

echo ================================
echo Baixando script principal...
echo ================================
powershell -Command "Invoke-WebRequest -Uri '%BAT_URL%' -OutFile '%BAT_FILE%' -UseBasicParsing"

echo ================================
echo Criando script invisivel...
echo ================================
(
echo Set WshShell = CreateObject("WScript.Shell")
echo WshShell.Run "%BAT_FILE%", 0, False
) > "%VBS_FILE%"

echo ================================
echo Criando tarefa agendada...
echo ================================
REM Exclui tarefa antiga se existir
schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1

REM Cria tarefa para rodar toda sexta-feira às 9h
schtasks /create /sc weekly /d FRI /tn "%TASK_NAME%" /tr "wscript.exe \"%VBS_FILE%\"" /st 09:00 /rl HIGHEST /f >nul 2>&1

echo ================================
echo Executando atualização agora...
echo ================================
wscript.exe "%VBS_FILE%"

echo ================================
echo ✅ Instalação concluída!
echo A tarefa sera executada toda sexta-feira as 09:00.
echo ================================
timeout /t 5 /nobreak >nul
exit
