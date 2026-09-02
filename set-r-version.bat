
@set exit_code_setrv=0
@set error_msg=""

@REM as of Sept 2026 windows 2022  https://github.com/actions/runner-images/blob/main/images/windows/Windows2022-Readme.md
set R_VERSION=4.6.1

set R_PROG_DIR=c:\Program Files\R
set R_EXE="%R_PROG_DIR%\R-%R_VERSION%\bin\x64\R.exe"
set R_SCRIPT="%R_PROG_DIR%\R-%R_VERSION%\bin\x64\Rscript.exe"

if not exist %R_EXE% (
    set error_msg="ERROR: path '%R_EXE%' does not exist. Check https://github.com/actions/runner-images/blob/main/images/windows/Windows2022-Readme.md"
    set exit_code_setrv=1
    goto exit
)

:exit
if %exit_code_setrv% neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: build-r-pkgs completed without error
)
exit /b %exit_code_setrv%
