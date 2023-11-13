
setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

@echo off

echo ""
echo ###################################
echo # checkout
echo ###################################
echo ""

if not defined SWIFT_PAT_ENV_VAR ( 
    echo "ERROR: SWIFT_PAT_ENV_VAR not defined"
    set exit_code=1
    goto exit
) 

if not defined root_src_dir ( 
    echo "ERROR: root_src_dir not defined"
    set exit_code=1
    goto exit
) 

set SWIFT_PAT=%SWIFT_PAT_ENV_VAR%
set OUR_SRC_DIR=%root_src_dir%

if not exist %OUR_SRC_DIR% mkdir %OUR_SRC_DIR%

@REM @if %errorlevel% neq 0 set exit_code=%errorlevel%
@REM @if %errorlevel% neq 0 goto exit

set USERNAME_CSIRO=per202
set REMOTE_REPO_CSIRO=sf
set FORK_USERNAME_CSIRO=per202
set REMOTE_REPO_CSIRO_MYFORK=~%FORK_USERNAME_CSIRO%
set USERNAME_GITHUB=jmp75
set USERNAME_GITHUB_PREFIX=%USERNAME_GITHUB%@
set CSIROHYDRO_GITHUB=csiro-hydroinformatics
set FORK_USERNAME_GITHUB=jmp75
set CSIRO_BITBUCKET_URL_ROOT=https://%USERNAME_CSIRO%:%SWIFT_PAT%@bitbucket.csiro.au/scm
set GITHUB_URL_ROOT=%USERNAME_GITHUB_PREFIX%github.com
set GITHUB_REPO_ROOT=https://%GITHUB_URL_ROOT%/%CSIROHYDRO_GITHUB%
set GITHUB_JM_REPO_ROOT=https://%GITHUB_URL_ROOT%/%FORK_USERNAME_GITHUB%

set CSIRO_BITBUCKET=%OUR_SRC_DIR%
set GITHUB_REPOS=%OUR_SRC_DIR%

set exit_code=0

echo "Git: turning the detached message off"
git config --global advice.detachedHead false

cd %GITHUB_REPOS%
if not exist sf-stack git clone %GITHUB_REPO_ROOT%/sf-stack

echo Checking out sf-stack branch %BRANCH_NAME_ENV_VAR%
if not exist %GITHUB_REPOS%\sf-stack ( 
    echo "ERROR: path not found %GITHUB_REPOS%\sf-stack"
    set exit_code=1
    goto exit
)
cd %GITHUB_REPOS%\sf-stack
git checkout %BRANCH_NAME_ENV_VAR%

cd %GITHUB_REPOS%\sf-stack
if not exist commit_hashes.bat ( 
    echo "ERROR: file not found commit_hashes.bat"
    set exit_code=1
    goto exit
)
call commit_hashes.bat

echo REPO_CRUISE_CONTROL=%REPO_CRUISE_CONTROL%
echo REPO_NUMERICAL_SL_CPP=%REPO_NUMERICAL_SL_CPP%
echo REPO_DATATYPES=%REPO_DATATYPES%
echo REPO_SWIFT=%REPO_SWIFT%
echo REPO_QPP=%REPO_QPP%
echo REPO_CHYPP=%REPO_CHYPP%
echo REPO_VCPP_COMMONS=%REPO_VCPP_COMMONS%
echo REPO_MOIRAI=%REPO_MOIRAI%
echo REPO_C_INTEROP=%REPO_C_INTEROP%
echo REPO_PYREFCOUNT=%REPO_PYREFCOUNT%
echo REPO_THREADPOOL=%REPO_THREADPOOL%
echo REPO_CONFIG_UTILS=%REPO_CONFIG_UTILS%
echo REPO_WILA=%REPO_WILA%
echo REPO_EFTS=%REPO_EFTS%
echo REPO_EFTS_PYTHON=%REPO_EFTS_PYTHON%
echo REPO_MHPLOT=%REPO_MHPLOT%

if %REPO_CRUISE_CONTROL% eq "" ( 
    echo "ERROR: Failed to retrieve commit hashes for repos"
    set exit_code=1
    goto exit
)


cd %CSIRO_BITBUCKET%
if not exist cruise-control git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/cruise-control.git
cd %CSIRO_BITBUCKET%\cruise-control
git checkout %REPO_CRUISE_CONTROL%

cd %GITHUB_REPOS%
if not exist vcpp-commons git clone %GITHUB_REPO_ROOT%/vcpp-commons
cd %GITHUB_REPOS%\vcpp-commons
git checkout %REPO_VCPP_COMMONS%

@REM echo "TEMP TEST: just check out cruise control, then exit."
@REM set exit_code=0
@REM goto exit

cd %CSIRO_BITBUCKET%
if not exist numerical-sl-cpp git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/numerical-sl-cpp.git
if %errorlevel% neq 0 ( 
    echo "ERROR: numerical-sl-cpp checkout failed"
    set exit_code=1
    goto exit
)
cd %CSIRO_BITBUCKET%\numerical-sl-cpp
git checkout %REPO_NUMERICAL_SL_CPP%


cd %CSIRO_BITBUCKET%
if not exist datatypes git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/datatypes.git
cd %CSIRO_BITBUCKET%\datatypes
git checkout %REPO_DATATYPES%

cd %CSIRO_BITBUCKET%
if not exist swift git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/swift.git
cd %CSIRO_BITBUCKET%\swift
git checkout %REPO_SWIFT%

cd %CSIRO_BITBUCKET%
if not exist qpp git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/qpp.git
cd %CSIRO_BITBUCKET%\qpp
git checkout %REPO_QPP%

cd %CSIRO_BITBUCKET%
if not exist chypp git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/CHyPP.git
cd %CSIRO_BITBUCKET%\chypp
git checkout %REPO_CHYPP%

cd %GITHUB_REPOS%
if not exist moirai (
    git clone %GITHUB_REPO_ROOT%/moirai.git
    if %errorlevel% neq 0 ( 
        echo "ERROR: moirai checkout failed"
        set exit_code=1
        goto exit
    )
)
cd %GITHUB_REPOS%\moirai
git checkout %REPO_MOIRAI%

cd %GITHUB_REPOS%
if not exist c-interop git clone %GITHUB_REPO_ROOT%/c-interop.git
cd %GITHUB_REPOS%\c-interop
git checkout %REPO_C_INTEROP%

cd %GITHUB_REPOS%
if not exist threadpool git clone %GITHUB_REPO_ROOT%/threadpool.git
cd %GITHUB_REPOS%\threadpool
git checkout %REPO_THREADPOOL%

cd %GITHUB_REPOS%
if not exist wila git clone %GITHUB_REPO_ROOT%/wila.git
cd %GITHUB_REPOS%\wila
git checkout %REPO_WILA%

cd %GITHUB_REPOS%
if not exist config-utils git clone %GITHUB_REPO_ROOT%/config-utils.git
cd %GITHUB_REPOS%\config-utils
git checkout %REPO_CONFIG_UTILS%

:: # OPTIONAL if needed to generate code for e.g. R package:
@REM git clone %GITHUB_REPO_ROOT%/c-api-wrapper-generation.git

cd %GITHUB_REPOS%
if not exist yaml-cpp git clone %GITHUB_JM_REPO_ROOT%/yaml-cpp.git
cd %GITHUB_REPOS%\yaml-cpp
git checkout yaml_swift_experimental

cd %GITHUB_REPOS%
if not exist jsoncpp git clone %GITHUB_JM_REPO_ROOT%/jsoncpp.git
cd %GITHUB_REPOS%\jsoncpp
git checkout custom/experimental

cd %GITHUB_REPOS%
if not exist efts git clone %GITHUB_REPO_ROOT%/efts.git
cd %GITHUB_REPOS%\efts
git checkout %REPO_EFTS%

cd %GITHUB_REPOS%
if not exist efts-python git clone %GITHUB_REPO_ROOT%/efts-python.git
cd %GITHUB_REPOS%\efts-python
git checkout %REPO_EFTS_PYTHON%

cd %GITHUB_REPOS%
if not exist mhplot git clone %GITHUB_REPO_ROOT%/mhplot.git
cd %GITHUB_REPOS%\mhplot
git checkout %REPO_MHPLOT%

cd %GITHUB_REPOS%
if not exist pyrefcount git clone %GITHUB_REPO_ROOT%/pyrefcount.git

@REM cd %CSIRO_BITBUCKET%
@REM git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/rpp-cpp.git

@REM cd %CSIRO_BITBUCKET%
@REM git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/rpp-g-cpp.git

@REM :: # OPTIONAL, for generating bindings for packages (advanced)
@REM cd %CSIRO_BITBUCKET%
@REM git clone %CSIRO_BITBUCKET_URL_ROOT%/~%FORK_USERNAME_CSIRO%/c-api-bindings.git

@REM :: # OPTIONAL
@REM cd %CSIRO_BITBUCKET%
@REM git clone %CSIRO_BITBUCKET_URL_ROOT%/~%FORK_USERNAME_CSIRO%/swift-scripts.git

echo "INFO: checkout.bat completed"

:exit
exit /b !exit_code!
