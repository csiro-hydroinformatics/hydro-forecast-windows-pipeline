# Set up property sheets files shared by vc++ project files

# Moirai:

# Note: Powershell 6 and above supposed to handle more than 2 args, and should with windows-2019 VM, but pipeline then fails

$target_file = Join-Path $env:USERPROFILE 'Documents\moirai.props'

$template_file = Join-Path $env:BUILD_SOURCESDIRECTORY 'moirai\tests\moirai.props.in'

Copy-Item $template_file -Destination $target_file

# Swift stack

$OUR_SRC_DIR = Join-Path $env:BUILD_SOURCESDIRECTORY 's'

$target_file = Join-Path $env:USERPROFILE 'vcpp_config.props'

$template_file = Join-Path $env:BUILD_SOURCESDIRECTORY 'vcpp_config.props.template'

Write-Host $target_file

((Get-Content -path $template_file -Raw) -replace 'ROOT_SRC_DIR', $OUR_SRC_DIR) | Set-Content -Path $target_file

Get-Content -path $target_file | Write-Host

