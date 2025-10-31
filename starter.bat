@echo off
setlocal
title (oculto)

REM ==========================================
REM CONFIGURAÇÕES
REM ==========================================
set "SAVE_DIR=C:\ProgramData\TrulWallpaper"
set "IMAGE_NAME=wallpaper.png"
set "IMAGE_URL=https://raw.githubusercontent.com/mathaussobrinho/trul/main/trul.png?raw=true"

REM Cria a pasta se não existir
if not exist "%SAVE_DIR%" mkdir "%SAVE_DIR%"

REM ==========================================
REM BAIXA IMAGEM
REM ==========================================
powershell -Command "Invoke-WebRequest -Uri '%IMAGE_URL%' -OutFile '%SAVE_DIR%\%IMAGE_NAME%' -UseBasicParsing"

REM ==========================================
REM DEFINE PAPEL DE PAREDE
REM ==========================================
powershell -Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name wallpaper -Value '%SAVE_DIR%\%IMAGE_NAME%'"
powershell -Command "Add-Type 'using System; using System.Runtime.InteropServices; public class W { [DllImport(\"user32.dll\", SetLastError=true)] public static extern bool SystemParametersInfo(int uAction,int uParam,string lpvParam,int fuWinIni); }'; [W]::SystemParametersInfo(20, 0, \"%SAVE_DIR%\%IMAGE_NAME%\", 0x01 -bor 0x02)"

REM ==========================================
REM LIMPA CACHE DE PAPEL DE PAREDE (opcional)
REM ==========================================
powershell -Command "if (Test-Path \"$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper\") {Remove-Item \"$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper\" -Force}"
powershell -Command "if (Test-Path \"$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles\") {Get-ChildItem \"$env:LOCALAPPDATA\Microsoft\Windows\Themes\CachedFiles\" -Recurse | Remove-Item -Force}"

REM ==========================================
REM LIMPA ARQUIVOS TEMPORÁRIOS (opcional)
REM ==========================================
del /f /s /q "%temp%\*.*" >nul 2>&1
for /d %%x in ("%temp%\*") do rd /s /q "%%x" >nul 2>&1

endlocal
exit
