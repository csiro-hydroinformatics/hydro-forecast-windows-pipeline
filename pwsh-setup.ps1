# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
# Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

# https://www.powershellgallery.com/packages/Invoke-MsBuild/2.7.1
Install-Module -Name Invoke-MsBuild -Scope CurrentUser

$githubRepoDir=$env:BUILD_SOURCESDIRECTORY
$Path = ($githubRepoDir + "\s\config-utils\automation\PSBatchBuild")
# Install-Module -Scope CurrentUser -Name PSScriptAnalyzer -force
# Invoke-ScriptAnalyzer -Path $Path
Import-Module -Name $Path -Verbose 
