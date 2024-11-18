@echo off

@set exit_code=0
@set error_msg=""

if not defined root_src_dir ( 
    set error_msg=ERROR: root_src_dir not defined
    set exit_code=1
    goto exit
) 

set csiro_dir=%root_src_dir%
set cruise_control_dir=%csiro_dir%\cruise-control
set cc_script_dir=%cruise_control_dir%\scripts

if not exist %cc_script_dir% ( 
    set error_msg=ERROR: %cc_script_dir% does not exist
    set exit_code=1
    goto exit
)

set LIBRARY_PATH=%local_dir%\libs
call %cc_script_dir%\check_library_path.cmd
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=check_library_path failed 
    goto exit
)

if not defined INCLUDE_PATH set INCLUDE_PATH=%local_dir%\include
if not defined SWIFT_SAMPLE_DATA_DIR set SWIFT_SAMPLE_DATA_DIR=%root_data_dir%\documentation

@set ModeUnitTests=Release
@set PlatformUnitTests=x64

@REM as of May 2024: migrate to 4.4 due to organisational requirements. 
set R_VERSION=4.4.0

set R_PROG_DIR=c:\Program Files\R
set R_EXE="%R_PROG_DIR%\R-%R_VERSION%\bin\x64\R.exe"
set R_SCRIPT="%R_PROG_DIR%\R-%R_VERSION%\bin\x64\Rscript.exe"

if not exist %R_EXE% (
    set error_msg="ERROR: path '%R_EXE%' does not exist"
    set exit_code=1
    goto exit
)

call %cc_script_dir%\setup_dev Default 64
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=call to setup_dev failed
    goto exit
)

:exit
if %exit_code% neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: check-vssetup completed without error
)
exit /b %exit_code%
