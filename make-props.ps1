
$OUR_SRC_DIR = Join-Path $env:BUILD_SOURCESDIRECTORY 's'

$target_file = Join-Path $env:USERPROFILE 'vcpp_config.props'

$template_file = Join-Path $env:BUILD_SOURCESDIRECTORY 'vcpp_config.props.template'

Write-Host $target_file

((Get-Content -path $template_file -Raw) -replace 'ROOT_SRC_DIR', $OUR_SRC_DIR) | Set-Content -Path $target_file

Get-Content -path $target_file | Write-Host
