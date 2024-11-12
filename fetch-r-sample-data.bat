setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

@echo off

echo ""
echo ###################################
echo # fetch R sample data
echo ###################################
echo ""

set exit_code=0

if not defined root_src_dir ( 
    set error_msg=root_src_dir not defined
    set exit_code=1
    goto exit
) 

set r_data_dir=%root_src_dir%\swift\bindings\R\pkgs\swift\data

if not exist %r_data_dir% ( 
    set error_msg=%r_data_dir% not found
    set exit_code=1
    goto exit
) 

cd %r_data_dir%

@REM cloudstor decomissioned
@REM curl -o swift_sample_data.rda ftp://ftp.csiro.au/hfc/swift_sample_data.rda
@REM if %errorlevel% neq 0 (
@REM     set exit_code=%errorlevel%
@REM     set error_msg=swift_sample_data.rda download failed
@REM     goto exit
@REM )

set OUR_SRC_DIR=%root_src_dir%
set GITHUB_REPOS=%OUR_SRC_DIR%

if not exist %OUR_SRC_DIR% ( 
    echo "ERROR: %OUR_SRC_DIR% not found"
    set exit_code=1
    goto exit
) 

@REM if not exist %GITHUB_REPOS%\sf-test-data ( 
@REM     echo "ERROR: %GITHUB_REPOS%\sf-test-data not found"
@REM     set exit_code=1
@REM     goto exit
@REM ) 

@REM set COPYOPTIONS=/Y /R
@REM xcopy %GITHUB_REPOS%\sf-test-data\swift_test_data.7z %root_data_dir% %COPYOPTIONS%


:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: fetched-sample-data completed without error
)
exit /b !exit_code!
