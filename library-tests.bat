@echo off

echo ""
echo ###################################
echo # native libraries unit tests
echo ###################################
echo ""

@REM echo WARNING: 2022-07-22 do_unit_tests temporarily skipped during pipeline development 
@REM exit /b 0

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

call %cc_script_dir%\do_unit_tests.cmd

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: do_unit_tests completed without error
)
exit /b %exit_code%
