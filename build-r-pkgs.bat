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
call %cc_script_dir%\setup_dev Default 64
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=call to setup_dev failed
    goto exit
)

REM avoid issue writing to program installed library.
set rlib_dos=%userprofile%\Rlib  
if not exist %rlib_dos% mkdir %rlib_dos% 
set rlib_nix=%rlib_dos:\=/%          
set R_LIBS_SITE=%rlib_nix%                                  

set RCMD_BUILD_OPT_NO_VIGNETTE=--no-build-vignettes
call %cc_script_dir%\build_r_packages.cmd %RCMD_BUILD_OPT_NO_VIGNETTE%
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=build_r_packages failed 
    goto exit
)


:exit
if %exit_code% neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: build-r-pkgs completed without error
)
exit /b %exit_code%
