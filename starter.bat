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
echo Verificando se a tarefa ja existe...
echo ================================
schtasks /query /tn "%TASK_NAME%" >nul 2>&1
if %errorlevel%==0 (
    echo A tarefa ja existe. Nao sera recriada.
) else (
    echo Criando tarefa agendada...
    schtasks /create /sc weekly /d FRI /tn "%TASK_NAME%" /tr "wscript.exe \"%VBS_FILE%\"" /st 09:00 /rl HIGHEST /f >nul 2>&1
    echo ✅ Tarefa criada com sucesso! Executara toda sexta-feira as 09:00.
)

echo ================================
echo Executando atualizacao agora...
echo ================================
wscript.exe "%VBS_FILE%"

echo ================================
echo ✅ Processo concluido!
echo ================================
timeout /t 4 /nobreak >nul
exit
