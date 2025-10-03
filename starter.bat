@echo off
REM =========================================
REM Script silencioso para atualizar papel de parede
REM e limpar cache/temporários
REM =========================================

REM Caminho do diretório atual
set "CURRENT_DIR=%~dp0"

REM Nome da imagem local
set "IMAGE_NAME=wallpaper.png"

REM URL direta da imagem RAW
set "IMAGE_URL=https://raw.githubusercontent.com/mathaussobrinho/trul/main/trul.png?raw=true"

REM -----------------------------
REM Baixar imagem silenciosamente
REM -----------------------------
powershell -WindowStyle Hidden -Command ^
    "Invoke-WebRequest -Uri '%IMAGE_URL%' -OutFile '%CURRENT_DIR%%IMAGE_NAME%' -UseBasicParsing"

REM -----------------------------
REM Definir papel de parede silenciosamente
REM -----------------------------
powershell -WindowStyle Hidden -Command ^
    "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name wallpaper -Value '%CURRENT_DIR%%IMAGE_NAME%' ; ^
     Add-Type @'
using System;
using System.Runtime.InteropServices;
public class W {
    [DllImport(\"user32.dll\", SetLastError=true)]
    public static extern bool SystemParametersInfo(int uAction,int uParam,string lpvParam,int fuWinIni);
}
'@ ; ^
     [W]::SystemParametersInfo(20,0,'%CURRENT_DIR%%IMAGE_NAME%',3)"

REM -----------------------------
REM Limpar cache de papel de parede
REM -----------------------------
powershell -WindowStyle Hidden -Command ^
    "if (Test-Path \"$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper\") {Remove-Item \"$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper\" -Force}"
powershell -WindowStyle Hidden -Command ^
    "if (Test-Path \"$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles\") {Get-ChildItem \"$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles\" -Recurse | Remove-Item -Force}"

REM -----------------------------
REM Limpar arquivos temporários
REM -----------------------------
del /f /s /q "%temp%\*.*" >nul 2>&1
for /d %%x in ("%temp%\*") do rd /s /q "%%x" >nul 2>&1

REM -----------------------------
REM Fim
REM -----------------------------
exit
