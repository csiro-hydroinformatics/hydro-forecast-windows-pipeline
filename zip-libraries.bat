
@echo off


echo ""
echo ###################################
echo # zip native libraries
echo ###################################
echo ""


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

if not defined sf_out_dir ( 
    set error_msg=ERROR: sf_out_dir not defined
    set exit_code=1
    goto exit
)

set sf_cpp_out_dir=%sf_out_dir%\cpp_core
if not exist %sf_cpp_out_dir% mkdir %sf_cpp_out_dir%

move include.7z %sf_cpp_out_dir%\
move libs.7z %sf_cpp_out_dir%\

cd %local_dev_dir%
7z a libs_debug.7z libs
move libs_debug.7z %sf_cpp_out_dir%\

:exit
if !exit_code! neq 0 (
    echo ERROR: %error_msg%
) else (
    echo INFO: zip-libraries completed without error
)
exit /b %exit_code%
