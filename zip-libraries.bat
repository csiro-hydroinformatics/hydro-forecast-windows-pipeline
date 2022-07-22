
@echo off

@set exit_code=0
@set error_msg=""

if not defined local_dir ( 
    set error_msg=local_dir not defined
    set exit_code=1
    goto exit
) 

if not defined local_dev_dir ( 
    set error_msg=local_dev_dir not defined
    set exit_code=1
    goto exit
) 

cd %local_dir%
7z a libs.7z libs
:: if in bulk:
:: 7z a include.7z include
:: but to avoid rezipping boost header files and other stable ones:
7z a include.7z include\boost\threadpool.hpp include\boost\threadpool include\sfsl include\wila include\cinterop include\datatypes include\moirai include\swift include\qpp include\qppcore 

cd %local_dev_dir%
7z a libs_debug.7z libs

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: do_unit_tests completed without error
)
exit /b %exit_code%
