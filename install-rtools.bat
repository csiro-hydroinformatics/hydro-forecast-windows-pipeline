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

@REM as of June 2023: need to install R 4.2.x also. The Windows Image in AZDO now comes with R 4.3, and RTools 4.3. However the mingw ld.exe has a bug preventing uchronia R pkg to be built (see https://jira.csiro.au/projects/WIRADA/issues/WIRADA-665)
@REM as of May 2024: migrate to 4.4 due to organisational requirements. ticket WIRADA-700.
set R_VERSION=4.4.0
set RTOOLS_VERSION=44
@REM rtools42-5355-5357.exe
set RTOOLS_FN=rtools44-6104-6039.exe

curl -o R-%R_VERSION%-win.exe https://cran.csiro.au/bin/windows/base/old/%R_VERSION%/R-%R_VERSION%-win.exe
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=R-%R_VERSION%-win.exe download failed
    goto exit
)

R-%R_VERSION%-win.exe  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=FAILED: R-%R_VERSION%-win.exe  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
    goto exit
)

curl -o %RTOOLS_FN% https://cran.csiro.au/bin/windows/Rtools/rtools%RTOOLS_VERSION%/files/%RTOOLS_FN%
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=%RTOOLS_FN% download failed
    goto exit
)

%RTOOLS_FN%  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=FAILED: %RTOOLS_FN%  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
    goto exit
)

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: install-rtools completed without error
)
exit /b !exit_code!
