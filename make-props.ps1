# Set up property sheets files shared by vc++ project files

# Moirai:

# Note: Powershell 6 and above supposed to handle more than 2 args, and should with windows-2019 VM, but pipeline then fails
# Perhaps, the azure pipeline calls the system "powershell" that may go to version 5, where the "pwsh" command on my machine starts version 7 

# StackOverflow: We can enable Powershell core on Azure DevOps task using the checkbox Use Powershell Core under Advanced settings of the task and use the parallel feature.

if ((Test-Path env:root_src_dir) -eq $false)
{
    Write-Output ("ERROR: env:root_src_dir not defined")
    exit 1
} 

if ((Test-Path env:pipeline_src_dir) -eq $false)
{
    Write-Output ("ERROR: env:pipeline_src_dir not defined")
    exit 1
} 


$OUR_SRC_DIR = $env:root_src_dir # Join-Path $env:BUILD_SOURCESDIRECTORY 's'

$target_file = Join-Path $env:USERPROFILE 'Documents\moirai.props'

$template_file = Join-Path $OUR_SRC_DIR 'moirai\tests\moirai.props.in'

Copy-Item $template_file -Destination $target_file

# Swift stack

$target_file = Join-Path $env:USERPROFILE 'vcpp_config.props'

$template_file = Join-Path $env:pipeline_src_dir 'vcpp_config.props.template'

Write-Host $target_file

((Get-Content -path $template_file -Raw) -replace 'ROOT_SRC_DIR', $OUR_SRC_DIR) | Set-Content -Path $target_file

Get-Content -path $target_file | Write-Host

