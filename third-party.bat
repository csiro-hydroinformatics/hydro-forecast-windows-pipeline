setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

@echo off

echo ""
echo ###################################
echo # Fetch third party c++ libraries
echo ###################################
echo ""

set exit_code=0

if not defined local_dir ( 
    echo "ERROR: local_dir not defined"
    set exit_code=1
    goto exit
) 

if not defined include_dir ( 
    echo "ERROR: include_dir not defined"
    set exit_code=1
    goto exit
) 

if not defined local_dev_dir ( 
    echo "ERROR: local_dev_dir not defined"
    set exit_code=1
    goto exit
) 

if not exist %local_dir% mkdir %local_dir%
if not exist %include_dir% mkdir %include_dir%
if not exist %local_dev_dir%\libs\64 mkdir %local_dev_dir%\libs\64

cd %local_dir%

curl -o libs_third_party.7z https://cloudstor.aarnet.edu.au/plus/s/GdV0QmFISDHrwPG/download
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=libs_third_party.7z download failed
    goto exit
)

curl -o include_third_party.7z https://cloudstor.aarnet.edu.au/plus/s/TQnRgaYIfzJpdKB/download
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=include_third_party.7z download failed
    goto exit
)

7z x -y libs_third_party.7z 
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=libs_third_party.7z extraction failed
    goto exit
)
7z x -y include_third_party.7z 
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=include_third_party.7z extraction failed
    goto exit
)

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: third-party completed without error
)
exit /b !exit_code!
