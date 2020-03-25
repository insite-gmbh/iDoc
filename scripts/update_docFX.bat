@echo off

set callerDir=%1
set callerBatch=%2
call :CheckPerm
GOTO:EOF


:CheckPerm
    REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
    ) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
    )

    REM --> If error flag set, we do not have admin.
    if '%errorlevel%' NEQ '0' (
        echo Requesting administrative privileges...
        call :UACPrompt
    ) else ( 
        call :install 
    )
GOTO:EOF


:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %callerDir% %callerBatch%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    cscript  "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
GOTO:EOF


:chocolaty
    if not exist %programdata%\chocolatey\choco.exe  (
        powershell.exe -command "(iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex)"
    )
GOTO:EOF


:docfx
    pushd "%CD%"
    CD /D "%~dp0"
    :--------------------------------------    
    choco install docfx -version 2.45.1 -y
GOTO:EOF


:install
    call :chocolaty
    call :docfx
    call :runCaller
GOTO:EOF

:runCaller
    CD /D %callerDir%
    call %callerBatch%
GOTO:EOF