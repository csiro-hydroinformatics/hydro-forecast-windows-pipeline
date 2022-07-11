
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

cd %CSIRO_BITBUCKET%
git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/numerical-sl-cpp.git
if %errorlevel% neq 0 ( 
    echo "ERROR: numerical-sl-cpp checkout failed"
    set exit_code=1
    goto exit
)
cd %CSIRO_BITBUCKET%\numerical-sl-cpp
git checkout testing

@REM cd %CSIRO_BITBUCKET%
@REM git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/datatypes.git
@REM cd %CSIRO_BITBUCKET%\datatypes
@REM git checkout experimental

@REM cd %CSIRO_BITBUCKET%
@REM git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/swift.git
@REM cd %CSIRO_BITBUCKET%\swift
@REM git checkout experimental

@REM cd %CSIRO_BITBUCKET%
@REM git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/qpp.git
@REM cd %CSIRO_BITBUCKET%\qpp
@REM git checkout experimental

@REM cd %CSIRO_BITBUCKET%
@REM git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/cruise-control.git

@REM cd %GITHUB_REPOS%
@REM git clone %GITHUB_REPO_ROOT%/moirai.git
@REM cd %GITHUB_REPOS%\moirai
@REM git checkout experimental

@REM cd %GITHUB_REPOS%
@REM git clone %GITHUB_REPO_ROOT%/rcpp-interop-commons.git
@REM cd %GITHUB_REPOS%\rcpp-interop-commons
@REM git checkout experimental

@REM cd %GITHUB_REPOS%
@REM git clone %GITHUB_REPO_ROOT%/threadpool.git
@REM cd %GITHUB_REPOS%\threadpool
@REM git checkout master

@REM cd %GITHUB_REPOS%
@REM git clone %GITHUB_REPO_ROOT%/wila.git
@REM cd %GITHUB_REPOS%\wila
@REM git checkout experimental

@REM cd %GITHUB_REPOS%
@REM git clone %GITHUB_REPO_ROOT%/config-utils.git
@REM cd %GITHUB_REPOS%\config-utils
@REM git checkout testing

@REM :: # OPTIONAL if needed to generate code for e.g. R package:
@REM @REM git clone %GITHUB_REPO_ROOT%/c-api-wrapper-generation.git

@REM cd %GITHUB_REPOS%
@REM git clone %GITHUB_JM_REPO_ROOT%/yaml-cpp.git
@REM cd %GITHUB_REPOS%\yaml-cpp
@REM git checkout yaml_swift_experimental

@REM cd %GITHUB_REPOS%
@REM git clone %GITHUB_JM_REPO_ROOT%/jsoncpp.git
@REM cd %GITHUB_REPOS%\jsoncpp
@REM git checkout custom/experimental

@REM cd %GITHUB_REPOS%
@REM git clone %GITHUB_REPO_ROOT%/vcpp-commons
@REM cd %GITHUB_REPOS%\vcpp-commons
@REM git checkout master

@REM cd %GITHUB_REPOS%
@REM git clone %GITHUB_REPO_ROOT%/efts.git
@REM cd %GITHUB_REPOS%\efts
@REM git checkout master

@REM cd %GITHUB_REPOS%
@REM git clone %GITHUB_REPO_ROOT%/pyrefcount.git

@REM @REM cd %CSIRO_BITBUCKET%
@REM @REM git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/rpp-cpp.git

@REM @REM cd %CSIRO_BITBUCKET%
@REM @REM git clone %CSIRO_BITBUCKET_URL_ROOT%/%REMOTE_REPO_CSIRO%/rpp-g-cpp.git

@REM @REM :: # OPTIONAL, for generating bindings for packages (advanced)
@REM @REM cd %CSIRO_BITBUCKET%
@REM @REM git clone %CSIRO_BITBUCKET_URL_ROOT%/~%FORK_USERNAME_CSIRO%/c-api-bindings.git

@REM @REM :: # OPTIONAL
@REM @REM cd %CSIRO_BITBUCKET%
@REM @REM git clone %CSIRO_BITBUCKET_URL_ROOT%/~%FORK_USERNAME_CSIRO%/swift-scripts.git

echo "checkout.bat completed with success"
:exit
exit /b !exit_code!
