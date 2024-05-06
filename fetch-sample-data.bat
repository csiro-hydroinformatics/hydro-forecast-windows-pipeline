setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

@echo off

echo ""
echo ###################################
echo # fetch unit test sample data
echo ###################################
echo ""


set exit_code=0

if not defined root_data_dir ( 
    set error_msg=ERROR: root_data_dir not defined
    set exit_code=1
    goto exit
) 

set OUR_SRC_DIR=%root_src_dir%
set GITHUB_REPOS=%OUR_SRC_DIR%

if not exist %OUR_SRC_DIR% ( 
    echo "ERROR: %OUR_SRC_DIR% not found"
    set exit_code=1
    goto exit
) 

if not exist %GITHUB_REPOS%\sf-test-data ( 
    echo "ERROR: %GITHUB_REPOS%\sf-test-data not found"
    set exit_code=1
    goto exit
) 

if not exist %root_data_dir% mkdir %root_data_dir%

cd %root_data_dir%

@REM cloudstor decomissioned
@REM curl -o swift_test_data.7z https://cloudstor.aarnet.edu.au/plus/s/RU6kLfzuncINu4f/download
@REM if %errorlevel% neq 0 (
@REM     set exit_code=%errorlevel%
@REM     set error_msg=swift_test_data.7z download failed
@REM     goto exit
@REM )

set COPYOPTIONS=/Y /R
xcopy %GITHUB_REPOS%\sf-test-data\swift_test_data.7z %root_data_dir% %COPYOPTIONS%

cd %root_data_dir%
7z x -y swift_test_data.7z 
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=swift_test_data.7z extraction failed
    goto exit
)

@REM No need?
@REM xcopy %GITHUB_REPOS%\sf-test-data\chypp_test_data.7z %root_data_dir% %COPYOPTIONS%
@REM cd %root_data_dir%
@REM 7z x -y chypp_test_data.7z 
@REM if %errorlevel% neq 0 (
@REM     set exit_code=%errorlevel%
@REM     set error_msg=chypp_test_data.7z extraction failed
@REM     goto exit
@REM )

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: fetched-sample-data completed without error
)
exit /b !exit_code!
