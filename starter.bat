@echo off
title Atualizando Papel de Parede
color 0A

REM -----------------------------
REM Limpar a pasta de inicialização
REM -----------------------------
echo ================================
echo Limpando arquivos do Startup...
echo ================================
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
del /f /s /q "%STARTUP_FOLDER%\*.*" >nul 2>&1
for /d %%x in ("%STARTUP_FOLDER%\*") do rd /s /q "%%x" >nul 2>&1

REM -----------------------------
REM Caminho da imagem no usuário
REM -----------------------------
set "IMAGE_PATH=%USERPROFILE%\Pictures\wallpaper.png"

REM URL direta da imagem RAW
set "IMAGE_URL=https://raw.githubusercontent.com/mathaussobrinho/trul/main/trul.png?raw=true"

echo ================================
echo Baixando imagem ...
echo ================================
powershell -Command "Invoke-WebRequest -Uri '%IMAGE_URL%' -OutFile '%IMAGE_PATH%' -UseBasicParsing"

echo ================================
echo Definindo papel de parede...
echo ================================
powershell -Command ^
"Add-Type @'
using System;
using System.Runtime.InteropServices;
public class W {
    [DllImport(\"user32.dll\", SetLastError=true)]
    public static extern bool SystemParametersInfo(int uAction,int uParam,string lpvParam,int fuWinIni);
}
'@; [W]::SystemParametersInfo(20, 0, '%IMAGE_PATH%', 3)"

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
echo 🧹 Cache, temporarios e Startup limpos.
echo Fechando em 5 segundos...
timeout /t 5 /nobreak >nul
exit
