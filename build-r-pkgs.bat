@echo off

@set exit_code=0
@set error_msg=""

if not defined root_src_dir ( 
    set error_msg=ERROR: root_src_dir not defined
    set exit_code=1
    goto exit
) 

if not defined linux_packages_dir ( 
    set error_msg=ERROR: linux_packages_dir not defined
    set exit_code=1
    goto exit
)

set tarball_dir=%linux_packages_dir%\swift_setup\swift_setup\latest\r_pkgs\lib\R_repo\src\contrib

if not exist %tarball_dir% ( 
    set error_msg=ERROR: %tarball_dir% does not exist
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

REM if not calling build_r_packages.cmd:
%R_SCRIPT% %csiro_dir%\cruise-control\scripts\setup_dependent_packages.r

@REM set RCMD_BUILD_OPT_NO_VIGNETTE=--no-build-vignettes
@REM @REM call %cc_script_dir%\build_r_packages.cmd %RCMD_BUILD_OPT_NO_VIGNETTE%
@REM call %cc_script_dir%\build_r_packages.cmd
@REM @if %errorlevel% neq 0 (
@REM     set exit_code=%errorlevel%
@REM     set error_msg=build_r_packages failed 
@REM     goto exit
@REM )

REM #######################################################
REM Build binary packages



:: %R_VANILLA% CMD INSTALL --build %tarball_dir%\rClr_*.tar.gz
:: %R_VANILLA% CMD INSTALL --build %tarball_dir%\capigen_*.tar.gz

REM  percentage - tilda and fI        - expands %I to a fully qualified path name
REM check "for /?" in DOS

REM Let's be specific rather than bulk file pattern, just in case

REM un-double the %% to % if you copy/paste to cmd rather than call this as a script. Don't blame me.
REM Also, sorry for ugly redundancies. I dont trust to get Batch loops right yet: https://stackoverflow.com/questions/4334209/nested-batch-for-loops 

set R_BUILD_CMD=%R_VANILLA% CMD INSTALL --build

for %%I in ( %tarball_dir%\mhplot_*.tar.gz ) do ( %R_BUILD_CMD% %%~fI )
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=Building R package mhplot failed
    goto exit
)
for %%I in ( %tarball_dir%\cinterop_*.tar.gz ) do ( %R_BUILD_CMD% %%~fI )
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=Building R package cinterop failed
    goto exit
)
for %%I in ( %tarball_dir%\msvs_*.tar.gz ) do ( %R_BUILD_CMD% %%~fI )
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=Building R package msvs failed
    goto exit
)
for %%I in ( %tarball_dir%\uchronia_*.tar.gz ) do ( %R_BUILD_CMD% %%~fI )
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=Building R package uchronia failed
    goto exit
)
for %%I in ( %tarball_dir%\joki_*.tar.gz ) do ( %R_BUILD_CMD% %%~fI )
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=Building R package joki failed
    goto exit
)
for %%I in ( %tarball_dir%\swift_*.tar.gz ) do ( %R_BUILD_CMD% %%~fI )
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=Building R package swift failed
    goto exit
)
for %%I in ( %tarball_dir%\calibragem_*.tar.gz ) do ( %R_BUILD_CMD% %%~fI )
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=Building R package calibragem failed
    goto exit
)
for %%I in ( %tarball_dir%\qpp_*.tar.gz ) do ( %R_BUILD_CMD% %%~fI )
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=Building R package qpp failed
    goto exit
)
for %%I in ( %tarball_dir%\efts_*.tar.gz ) do ( %R_BUILD_CMD% %%~fI )
@if %errorlevel% neq 0 (
    set exit_code=%errorlevel%
    set error_msg=Building R package efts failed
    goto exit
)


:exit
if %exit_code% neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: build-r-pkgs completed without error
)
exit /b %exit_code%
