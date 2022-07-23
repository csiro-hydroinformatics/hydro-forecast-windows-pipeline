setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

@echo off

set exit_code=0

if not defined download_dir ( 
    set error_msg=download_dir not defined
    set exit_code=1
    goto exit
) 

if not exist %download_dir% ( 
    set error_msg=%download_dir% does not exist
    set exit_code=1
    goto exit
) 

cd %download_dir%

curl -o rtools42-5253-5107-signed.exe https://cran.csiro.au/bin/windows/Rtools/rtools42/files/rtools42-5253-5107-signed.exe
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=rtools42-5253-5107-signed.exe download failed
    goto exit
)

rtools42-5253-5107-signed.exe  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=FAILED: rtools42-5253-5107-signed.exe  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
    goto exit
)

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: install-rtools completed without error
)
exit /b !exit_code!
