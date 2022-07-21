set PATH=%PATH%;C:\Program Files\7-Zip;C:\Program Files\PowerShell\7

if exist "C:\Program Files\R\R-4.2.1\bin" set PATH=%PATH%;C:\Program Files\R\R-4.2.1\bin

REM You cannot set it this way anyway; %2 is interpreted as an argument...
REM set SWIFT_PAT_ENV_VAR=aaaaabbbbbbbcccccddddddoM9%2Fe0%2Faaaaabbbddd

if not defined pipeline_src_dir set pipeline_src_dir=C:\src\hydro-fc-windows-os
if not defined root_src_dir set root_src_dir=c:\src
if not defined root_data_dir set root_data_dir=c:\data
if not defined sf_out_dir set sf_out_dir=c:\sf
if not defined local_dir set local_dir=c:\local
if not defined local_dev_dir set local_dev_dir=c:\localdev
if not defined include_dir set include_dir=c:\local\include
if not defined RootLocalPath set RootLocalPath=%local_dir%
if not defined RootLocalDevPath set RootLocalDevPath=%local_dev_dir%

if not defined github_dir set github_dir=%root_src_dir%
if not defined csiro_dir set csiro_dir=%root_src_dir%

REM probably a legacy 
if not defined SwiftSrcPath set SwiftSrcPath=%root_src_dir:\=/%/swift

if not exist %pipeline_src_dir% mkdir %pipeline_src_dir%
if not exist %root_src_dir% mkdir %root_src_dir%
if not exist %root_data_dir% mkdir %root_data_dir%
if not exist %sf_out_dir% mkdir %sf_out_dir%
if not exist %local_dir% mkdir %local_dir%
if not exist %local_dev_dir% mkdir %local_dev_dir%
if not exist %include_dir% mkdir %include_dir%

@REM :exit
@REM exit /b !exit_code!
