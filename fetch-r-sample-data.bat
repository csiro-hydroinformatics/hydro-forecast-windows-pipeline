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

curl -o swift_sample_data.rda https://cloudstor.aarnet.edu.au/plus/s/vfIbwcISy8jKQmg/download
if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=swift_sample_data.rda download failed
    goto exit
)

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: fetched-sample-data completed without error
)
exit /b !exit_code!
