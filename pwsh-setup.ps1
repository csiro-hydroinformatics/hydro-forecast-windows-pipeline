# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
# Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

# https://www.powershellgallery.com/packages/Invoke-MsBuild/2.7.1
# Note: may need the -Force parameter otherwise "WARNING: User declined to install module (Invoke-MsBuild)."
Install-Module -Name Invoke-MsBuild -Scope CurrentUser -Force

if ((Test-Path env:root_src_dir) -eq $false)
{
    Write-Output ("ERROR: env:root_src_dir not defined")
    exit 1
} 

$githubRepoDir=$env:root_src_dir
$Path = (Join-Path $githubRepoDir "config-utils\automation\PSBatchBuild")
# Install-Module -Scope CurrentUser -Name PSScriptAnalyzer -force
# Invoke-ScriptAnalyzer -Path $Path
Import-Module -Name $Path -Verbose 
