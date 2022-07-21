setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

set exit_code=0

if not defined root_data_dir ( 
    set error_msg=ERROR: root_data_dir not defined
    set exit_code=1
    goto exit
) 

if not exist %root_data_dir% mkdir %root_data_dir%

cd %root_data_dir%

curl -o swift_test_data.7z https://cloudstor.aarnet.edu.au/plus/s/RU6kLfzuncINu4f/download
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=swift_test_data.7z download failed
    goto exit
)

7z x swift_test_data.7z 
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=swift_test_data.7z extraction failed
    goto exit
)

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: fetched-sample-data completed without error
)
exit /b !exit_code!
