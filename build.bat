@echo off
REM This script build the site under the folder docs where the ghpage is referenced
REM To use this script you have to download docfx  https://github.com/dotnet/docfx/releases
set DOCFXVERSION=""
if not exist %programdata%\chocolatey\choco.exe GOTO CHECK
powershell (gi %programdata%\chocolatey\bin\docfx.exe).versioninfo.FileVersion>> "temp.txt"
set /p DOCFXVERSION=<"temp.txt"
del temp.txt

:CHECK
	IF "%DOCFXVERSION%" == "2.40.12.60008" GOTO RUN
	call ./scripts/update_docFX.bat %~dp0 build.bat
GOTO:EOF

:RUN
	docfx build docfx.json
GOTO:EOF