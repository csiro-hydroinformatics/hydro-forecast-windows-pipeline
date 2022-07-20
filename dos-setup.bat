set PATH=%PATH%;C:\Program Files\7-Zip;C:\Program Files\PowerShell\7

REM You cannot set it this way anyway; %2 is interpreted as an argument...
REM set SWIFT_PAT_ENV_VAR=aaaaabbbbbbbcccccddddddoM9%2Fe0%2Faaaaabbbddd

if not defined pipeline_src_dir set pipeline_src_dir=C:\src\hydro-fc-windows-os
if not defined root_src_dir set root_src_dir=c:\src
if not defined local_dir set local_dir=c:\local
if not defined local_dev_dir set local_dev_dir=c:\localdev
if not defined include_dir set include_dir=c:\local\include
if not defined RootLocalPath set RootLocalPath=%local_dir%
if not defined RootLocalDevPath set RootLocalDevPath=%local_dev_dir%

@REM :exit
@REM exit /b !exit_code!
