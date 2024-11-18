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

if not defined sf_out_dir ( 
    set error_msg=ERROR: sf_out_dir not defined
    set exit_code=1
    goto exit
)

set tarball_dir=%linux_packages_dir%\swift_setup\latest\r_pkgs\lib\R_repo\src\contrib

if not exist %tarball_dir% ( 
    set error_msg=ERROR: %tarball_dir% does not exist
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
@REM we expect a few variable to be defined by setup_dev

REM 202304 we'll use this script to copy matlab functions.
if not defined MATLAB_DIR (
    set exit_code=1
    set error_msg=MATLAB_DIR is not defined
    goto exit
)

if not defined R_SRC_PKGS_DIR (
    set exit_code=1
    set error_msg=R_SRC_PKGS_DIR is not defined
    goto exit
)

if not defined R_SRC_PKGS_DIR_UNIX (
    set exit_code=1
    set error_msg=R_SRC_PKGS_DIR_UNIX is not defined
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

echo ***********************
echo R version used to build:
%R_VANILLA% --version
echo ***********************

if not exist %R_WINBIN_REPO_DIR% (
    set error_msg=ERROR: %R_WINBIN_REPO_DIR% does not exist - should already have been created
    set exit_code=1
    goto exit
)

echo INFO: %tarball_dir% tested to exist, and contains:
dir %tarball_dir%

echo ******************************************
echo INFO: Starting to build R packages found under %tarball_dir%
echo outputting to %R_WINBIN_REPO_DIR%
echo ******************************************

cd %R_WINBIN_REPO_DIR%

for %%P in (mhplot cinterop msvs uchronia joki swift calibragem qpp efts) do (
    for %%I in (%tarball_dir%\%%P_*.tar.gz) do (
        echo running command %R_BUILD_CMD% %%~fI
        %R_BUILD_CMD% %%~fI
    )
    @if %errorlevel% neq 0 (
        set exit_code=%errorlevel%
        set error_msg=Building R package %%P failed, with error code %exit_code%
        goto exit
    )
)

copy %tarball_dir%\*.tar.gz %R_SRC_PKGS_DIR%\

%R_VANILLA% -e "repo_winbin_dir <- '%R_WINBIN_REPO_DIR_UNIX%' ; tools::write_PACKAGES(dir=repo_winbin_dir, type='win.binary')"
%R_VANILLA% -e "library(tools) ; write_PACKAGES(dir='%R_SRC_PKGS_DIR_UNIX%%', type='source')"

REM MATLAB 

set swift_src_dir=%csiro_dir%\swift
set swift_mat_src_dir=%swift_src_dir%\bindings\matlab
set fogss_src_dir=%csiro_dir%\qpp
set fogss_mat_src_dir=%fogss_src_dir%\bindings\matlab

set robocopy_opt=/MIR /MT:1 /R:2 /NJS /NJH /NFL /NDL /XX

if not exist %MATLAB_DIR%\swift mkdir %MATLAB_DIR%\swift
robocopy %swift_mat_src_dir% %MATLAB_DIR%\swift %robocopy_opt%
if not exist %MATLAB_DIR%\fogss mkdir %MATLAB_DIR%\fogss
robocopy %fogss_mat_src_dir% %MATLAB_DIR%\fogss %robocopy_opt%

:exit
if %exit_code% neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: build-r-pkgs completed without error
)
exit /b %exit_code%
