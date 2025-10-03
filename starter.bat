@echo off
title Atualizando Papel de Parede
color 0A

REM Caminho do diretório atual (onde está o .bat)
set "CURRENT_DIR=%~dp0"

REM Nome da imagem local
set "IMAGE_NAME=wallpaper.png"

REM URL direta da imagem RAW
set "IMAGE_URL=https://raw.githubusercontent.com/mathaussobrinho/trul/main/trul.png?raw=true"

echo ================================
echo Baixando imagem...
echo ================================
powershell -Command "Invoke-WebRequest -Uri '%IMAGE_URL%' -OutFile '%CURRENT_DIR%%IMAGE_NAME%' -UseBasicParsing"

echo ================================
echo Definindo papel de parede...
echo ================================
powershell -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name wallpaper -Value '%CURRENT_DIR%%IMAGE_NAME%'"
powershell -Command "Add-Type 'using System; using System.Runtime.InteropServices; public class W { [DllImport(\"user32.dll\", SetLastError=true)] public static extern bool SystemParametersInfo(int uAction,int uParam,string lpvParam,int fuWinIni); }'; [W]::SystemParametersInfo(20, 0, \"%CURRENT_DIR%%IMAGE_NAME%\", 0x01 -bor 0x02)"

echo ================================
echo Limpando cache de papel de parede...
echo ================================
powershell -Command "if (Test-Path \"$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper\") {Remove-Item \"$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper\" -Force}"
powershell -Command "if (Test-Path \"$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles\") {Get-ChildItem \"$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles\" -Recurse | Remove-Item -Force}"

echo ================================
echo Limpando arquivos temporarios (%temp%)...
echo ================================
del /f /s /q "%temp%\*.*" >nul 2>&1
for /d %%x in ("%temp%\*") do rd /s /q "%%x" >nul 2>&1

echo.
echo ✅ Papel de parede atualizado com sucesso!
echo 🧹 Cache e arquivos temporarios limpos.
echo Fechando em 5 segundos...
timeout /t 5 /nobreak >nul
exit

