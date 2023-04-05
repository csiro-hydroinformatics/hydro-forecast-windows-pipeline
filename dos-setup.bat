
if defined dos_setup (
    echo INFO: dos-setup was already called in this process. Not re-running.
    exit 0
)

:: We set here some fallback values that are idiosyncratic, to support testing the 
@REM workflow on a local Windows machine. 

if exist "C:\Program Files\7-Zip" set PATH=%PATH%;C:\Program Files\7-Zip
if exist "C:\Program Files\PowerShell\7" set PATH=%PATH%;C:\Program Files\PowerShell\7
if exist "C:\Program Files\R\R-4.2.1\bin" set PATH=%PATH%;C:\Program Files\R\R-4.2.1\bin

if not defined pipeline_src_dir set pipeline_src_dir=C:\src\hydro-fc-windows-os
if not defined root_src_dir set root_src_dir=c:\src
if not defined root_data_dir set root_data_dir=c:\data
if not defined download_dir set download_dir=c:\tmp\downloads
if not defined sf_out_dir set sf_out_dir=c:\sf
if not defined local_dir set local_dir=c:\local
if not defined local_dev_dir set local_dev_dir=c:\localdev
if not defined include_dir set include_dir=c:\local\include
if not defined RootLocalPath set RootLocalPath=%local_dir%
if not defined RootLocalDevPath set RootLocalDevPath=%local_dev_dir%
if not defined linux_packages_dir set linux_packages_dir=C:\tmp\swift_pkgs

if not defined github_dir set github_dir=%root_src_dir%
if not defined csiro_dir set csiro_dir=%root_src_dir%

:: End of fallback on local variables
:: -------------------------------------


REM SwiftSrcPath probably a deprecated legacy 
if not defined SwiftSrcPath set SwiftSrcPath=%root_src_dir:\=/%/swift

if not exist %pipeline_src_dir% mkdir %pipeline_src_dir%
if not exist %root_src_dir% mkdir %root_src_dir%
if not exist %root_data_dir% mkdir %root_data_dir%
if not exist %download_dir% mkdir %download_dir%
if not exist %sf_out_dir% mkdir %sf_out_dir%
if not exist %local_dir% mkdir %local_dir%
if not exist %local_dev_dir% mkdir %local_dev_dir%
if not exist %include_dir% mkdir %include_dir%
if not exist %linux_packages_dir% mkdir %linux_packages_dir%

set dos_setup="INFO: dos-setup has now run to completion"

@REM :exit
@REM exit /b !exit_code!
