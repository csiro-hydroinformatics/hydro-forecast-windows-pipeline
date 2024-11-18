setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

@echo off
@echo on

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

SET parent_dir=%~dp0

cd %download_dir%

@REM Ideally should do something like this to get the exact version:
:: curl -o blah.html https://cran.csiro.au/bin/windows/Rtools/rtools42/files/
:: more blah.html | grep .exe | sed -r 's/.*href="([^"]+).*/\1/g'
@REM BUT this is an inane pain to set to a variable in DOS, and cannot test easily. Later.
@REM https://stackoverflow.com/questions/108439/how-do-i-get-the-result-of-a-command-in-a-variable-in-windows

@REM as of Jan 2023: rtools42-5355-5357.exe

@REM as of June 2023: need to install R 4.2.x also. The Windows Image in AZDO now comes with R 4.3, and RTools 4.3. However the mingw ld.exe has a bug preventing uchronia R pkg to be built (see https://jira.csiro.au/projects/WIRADA/issues/WIRADA-665)
@REM as of May 2024: migrate to 4.4 due to organisational requirements. ticket WIRADA-700.
@REM May 2024 the version of R on the windows-2019 image is 4.4. Installing rtools from an curl downlowd somehow fails now.
call set-r-version.bat
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=call to set-r-version failed
    goto exit
)

set RTOOLS_VERSION=44
@REM rtools42-5355-5357.exe
set RTOOLS_FN=rtools44-6104-6039.exe

Rscript %parent_dir%\install-rtools.R

@REM If there is already RTools 44 installed the code will not be zero. We cannot rely on the exit code to exit.
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=Rscript install-rtools.R FAILED - check the consistency of versions of R and RTools
    goto exit
)

@REM Deprecated:
@REM curl -o R-%R_VERSION%-win.exe https://cran.csiro.au/bin/windows/base/old/%R_VERSION%/R-%R_VERSION%-win.exe
@REM if %errorlevel% neq 0 (
@REM     set exit_code=%errorlevel%
@REM     set error_msg=R-%R_VERSION%-win.exe download failed
@REM     goto exit
@REM )

@REM R-%R_VERSION%-win.exe  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
@REM if %errorlevel% neq 0 (
@REM     set exit_code=%errorlevel%
@REM     set error_msg=FAILED: R-%R_VERSION%-win.exe  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
@REM     goto exit
@REM )

@REM curl -o %RTOOLS_FN% https://cran.csiro.au/bin/windows/Rtools/rtools%RTOOLS_VERSION%/files/%RTOOLS_FN%
@REM if %errorlevel% neq 0 (
@REM     set exit_code=%errorlevel%
@REM     set error_msg=%RTOOLS_FN% download failed
@REM     goto exit
@REM )

@REM echo %RTOOLS_FN% /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS

@REM %RTOOLS_FN% /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
@REM if %errorlevel% neq 0 (
@REM     set exit_code=%errorlevel%
@REM     set error_msg=FAILED: %RTOOLS_FN%  /VERYSILENT /SUPRESSMSGBOXES /NORESTART /ALLUSERS
@REM     goto exit
@REM )

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: install-rtools completed without error
)
exit /b !exit_code!
