setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

@echo off

echo ""
echo #######################
echo # Fetch third party c++
echo # header and libraries
echo #######################
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

if not defined root_src_dir ( 
    echo "ERROR: root_src_dir not defined"
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

if not exist %OUR_SRC_DIR%\sf-stack-deps ( 
    echo "ERROR: %OUR_SRC_DIR%\sf-stack-deps not found"
    set exit_code=1
    goto exit
) 

if not exist %GITHUB_REPOS%\sf-test-data ( 
    echo "ERROR: %GITHUB_REPOS%\sf-test-data not found"
    set exit_code=1
    goto exit
) 

cd %local_dir%
set COPYOPTIONS=/Y /R
xcopy %GITHUB_REPOS%\sf-stack-deps\include_third_party.7z %local_dir% %COPYOPTIONS%
xcopy %GITHUB_REPOS%\sf-stack-deps\libs_third_party.7z %local_dir% %COPYOPTIONS%

sf-test-data?

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
