setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

@echo off

echo ""
echo ###################################
echo # Install R tools for windows
echo ###################################
echo ""

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

@REM Ideally should do something like this to get the exact version:
:: curl -o blah.html https://cran.csiro.au/bin/windows/Rtools/rtools42/files/
:: more blah.html | grep .exe | sed -r 's/.*href="([^"]+).*/\1/g'
@REM BUT this is an inane pain to set to a variable in DOS, and cannot test easily. Later.
@REM https://stackoverflow.com/questions/108439/how-do-i-get-the-result-of-a-command-in-a-variable-in-windows

@REM as of Jan 2023: rtools42-5355-5357.exe

curl -o rtools42-5355-5357.exe https://cran.csiro.au/bin/windows/Rtools/rtools42/files/rtools42-5355-5357.exe
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=rtools42-5355-5357.exe download failed
    goto exit
)

rtools42-5355-5357.exe  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=FAILED: rtools42-5355-5357.exe  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
    goto exit
)

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: install-rtools completed without error
)
exit /b !exit_code!
