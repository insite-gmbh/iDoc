REM This script build the site under the folder docs where the ghpage is referenced
REM To use this script you have to download docfx  https://github.com/dotnet/docfx/releases
@echo off
powershell (gi %programdata%\chocolatey\bin\docfx.exe).versioninfo.FileVersion>> "temp.txt"
set /p DOCFXVERSION=<"temp.txt"
del "temp.txt"

IF "%DOCFXVERSION%" == "2.12.1.0" GOTO RUN
call scripts/update_docFX.bat

:RUN
docfx build docfx.json
