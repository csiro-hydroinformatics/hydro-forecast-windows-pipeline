
setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

if not defined SWIFT_PAT_ENV_VAR ( 
    echo "ERROR: SWIFT_PAT_ENV_VAR not defined"
    set exit_code=1
    goto exit
) 

set SWIFT_PAT=%SWIFT_PAT_ENV_VAR%
set OUR_SRC_DIR=%BUILD_SOURCESDIRECTORY%\s

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

cd %CSIRO_BITBUCKET%
git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/numerical-sl-cpp.git
if %errorlevel% neq 0 ( 
    echo "ERROR: numerical-sl-cpp checkout failed"
    set exit_code=1
    goto exit
)

cd %CSIRO_BITBUCKET%
git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/datatypes.git

cd %CSIRO_BITBUCKET%
git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/swift.git

cd %CSIRO_BITBUCKET%
git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/qpp.git

cd %CSIRO_BITBUCKET%
git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/cruise-control.git

cd %GITHUB_REPOS%
git clone %GITHUB_REPO_ROOT%/moirai.git
if %errorlevel% neq 0 ( 
    echo "ERROR: moirai checkout failed"
    set exit_code=1
    goto exit
)

cd %GITHUB_REPOS%
git clone %GITHUB_REPO_ROOT%/rcpp-interop-commons.git

cd %GITHUB_REPOS%
git clone %GITHUB_REPO_ROOT%/threadpool.git

cd %GITHUB_REPOS%
git clone %GITHUB_REPO_ROOT%/wila.git

cd %GITHUB_REPOS%
git clone %GITHUB_REPO_ROOT%/config-utils.git

:: # OPTIONAL if needed to generate code for e.g. R package:
@REM git clone %GITHUB_REPO_ROOT%/c-api-wrapper-generation.git

cd %GITHUB_REPOS%
git clone %GITHUB_JM_REPO_ROOT%/yaml-cpp.git

cd %GITHUB_REPOS%
git clone %GITHUB_JM_REPO_ROOT%/jsoncpp.git

cd %GITHUB_REPOS%
git clone %GITHUB_REPO_ROOT%/vcpp-commons

cd %GITHUB_REPOS%
git clone %GITHUB_REPO_ROOT%/efts.git

cd %GITHUB_REPOS%
git clone %GITHUB_REPO_ROOT%/pyrefcount.git


cd %CSIRO_BITBUCKET%\numerical-sl-cpp
git checkout testing
if %errorlevel% neq 0 ( 
    echo "ERROR: numerical-sl-cpp branch checkout failed"
    set exit_code=1
    goto exit
)
cd %CSIRO_BITBUCKET%\datatypes
git checkout experimental
cd %CSIRO_BITBUCKET%\swift
git checkout experimental
cd %CSIRO_BITBUCKET%\qpp
git checkout experimental
cd %GITHUB_REPOS%\moirai
git checkout experimental
cd %GITHUB_REPOS%\rcpp-interop-commons
git checkout experimental
cd %GITHUB_REPOS%\threadpool
git checkout master
cd %GITHUB_REPOS%\wila
git checkout experimental
cd %GITHUB_REPOS%\config-utils
git checkout testing
cd %GITHUB_REPOS%\yaml-cpp
git checkout yaml_swift_experimental
cd %GITHUB_REPOS%\jsoncpp
git checkout custom/experimental
cd %GITHUB_REPOS%\vcpp-commons
git checkout master
cd %GITHUB_REPOS%\efts
git checkout master


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