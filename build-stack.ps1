param(
    [string]$rootSrcDir = 'c:\src',
    [string]$localDir = 'c:\local',
    [string]$localDevDir = 'c:\localdev',
    [string]$includeDir = 'c:\local\include'
)

if ((Test-Path $includeDir) -eq $false)
{
    echo ("WARNING: includes directory not found: " + $includeDir + ". I will create it but expected it already")
    New-Item -ItemType Directory -Force -Path $includeDir
}

$githubRepoDir = $rootSrcDir
$csiroBitbucket = $rootSrcDir

$localLibDir = (Join-Path $localDir 'libs')
$localDevLibDir = (Join-Path $localDevDir 'libs')

$releaseCfg = 'Release'
$debugCfg = 'Debug'

# Root locations where we will put the release and debug versions of our libraries. The first one c:\local\libs may already contain the slim-down boost binaries; this is fine.
$libsDirs = @{}
$libsDirs[$releaseCfg] = $localLibDir
$libsDirs[$debugCfg] = $localDevLibDir

$myPSMakePath = Join-Path $csiroBitbucket 'cruise-control\powershell\PSMakeSfLibs'

# Variables for the main MSBuild.exe parameters:
# $toolsVersion = '14.0'
$toolsVersion = '12.0'

if ($env:buildMode) {$buildMode = $env:buildMode} else {$buildMode = 'Build'}

# All SF c++ development uses conventions for architecture folder names 
# $buildPlatforms = @('x64','Win32')
# As of 2017-11 we will only focus on 64 bits architecture to save compilation time and other logistical tedium with no direct value. 
$buildPlatforms = @('x64')
# $archTable = @{x64 = '64';Win32 = '32'}

#library names - Very unlikely you'll have to change that. 
$moiraiLibName = 'moirai'
$yamlLibName = 'yaml-cpp'
$jsonLibName = 'jsoncpp'
$wilaLibName = 'wila'
$cinteropLibName = 'cinterop'
$datatypesLibName = 'datatypes'
$swiftLibName = 'swift'
$sfslLibName = 'sfsl'

# Import build modules
Import-Module -Name Invoke-MsBuild -Verbose 
Import-Module -Name $myPSMakePath -Verbose 
$myPsBatchBuildPath = Get-PSBatchBuildPath -GithubRepoDir $githubRepoDir
Import-Module -Name $myPsBatchBuildPath -Verbose 


### Header-only copies

# threadpool headers are an addition to boost
$threadpoolDir = (Join-Path $githubRepoDir 'threadpool')
$boostThreadpoolDir = (Join-Path $threadpoolDir 'boost')
# Threadpool needed by wila and swift:
Copy-Item -Path $boostThreadpoolDir -Destination $includeDir -Recurse -Force

$h_file = (Join-Path $includeDir 'boost\threadpool.hpp')
if (Test-Path $h_file -PathType Leaf)
{
    echo ("HACK: file found " + $h_file)
} else {
    echo ("HACK: file not found " + $h_file)
}

# SFSL needed by swift
$sfslDir = (Join-Path $csiroBitbucket 'numerical-sl-cpp')
Copy-Item -Path (Join-Path $sfslDir 'algorithm\include\sfsl') -Destination $includeDir -Recurse -Force
Copy-Item -Path (Join-Path $sfslDir 'math\include\sfsl') -Destination $includeDir -Recurse -Force

$h_file = (Join-Path $includeDir 'sfsl\math\transforms.hpp')
if (Test-Path $h_file -PathType Leaf)
{
    echo ("HACK: file found " + $h_file)
} else {
    echo ("HACK: file not found " + $h_file)
}

# Build-DeployFullStack

# Compile and install the base libraries of our stack, that depend only on well known libs such as boost:
$lvlOneSlns = @{}
$lvlOneSlns[$moiraiLibName] = (Join-Path $githubRepoDir 'moirai\tests\moirai_test.sln')
$lvlOneLibnames = $moiraiLibName
$lvlOneSlns[$yamlLibName] = (Join-Path $githubRepoDir 'yaml-cpp\vsproj\yaml-cpp.sln')
$lvlOneSlns[$jsonLibName] = (Join-Path $githubRepoDir 'jsoncpp\makefiles\custom\jsoncpp_lib.vcxproj')
$lvlOneLibnames = $moiraiLibName,$yamlLibName,$jsonLibName
Install-SharedLibsMultiCfg -Solutions $lvlOneSlns -LibsDirs $libsDirs -BuildPlatforms $buildPlatforms -BuildMode $buildMode -ToolsVersion $toolsVersion -LibNames $lvlOneLibnames 

# Troubleshooting: if you get
# cp : Could not find a part of the path 'C:\localdev\libs\64'.
# you need to create these containing folders

$headerDirectories = @{}
$headerDirectories[$moiraiLibName] = (Join-Path $githubRepoDir 'moirai\include\moirai')
$headerDirectories[$yamlLibName] = (Join-Path $githubRepoDir 'yaml-cpp\include\yaml-cpp')
$headerDirectories[$jsonLibName] = (Join-Path $githubRepoDir 'jsoncpp\include\json')
$headerDirectories[$wilaLibName] = (Join-Path $githubRepoDir 'wila\include\wila')
$headerDirectories[$cinteropLibName] = (Join-Path $githubRepoDir 'rcpp-interop-commons\include\cinterop')

Copy-HeaderFiles -headerDirectories $headerDirectories -ToDir $includeDir

########## Level two - datatypes
$headerDirectories = @{}
$headerDirectories[$datatypesLibName] = (Join-Path $csiroBitbucket 'datatypes\datatypes\include\datatypes')
Copy-HeaderFiles -headerDirectories $headerDirectories -ToDir $includeDir

$lvlTwoSlns = @{}
$lvlTwoSlns[$datatypesLibName] = (Join-Path $csiroBitbucket 'datatypes\Solutions\DataTypes.sln')
$lvlTwoLibnames = @($datatypesLibName)


Install-SharedLibsMultiCfg -Solutions $lvlTwoSlns -LibsDirs $libsDirs -BuildPlatforms $buildPlatforms -BuildMode $buildMode -ToolsVersion $toolsVersion -LibNames $lvlTwoLibnames 
# common.cpp(1): fatal error C1083: Cannot open include file: 'boost/algorithm/string/join.hpp': No such file or directory
# <Import Project="$(UserProfile)/vcpp_config.props" Condition="exists('$(UserProfile)/vcpp_config.props')" />
# Follow instructions in C:\src\github_jm\vcpp-commons\README.md

########## Level three, swift, RPP.

$lvlThreeSlns = @{}
$lvlThreeLibnames = @($swiftLibName)
$lvlThreeSlns[$swiftLibName] = (Join-Path $csiroBitbucket 'swift\Solutions\SWIFT\libSWIFT.sln')

# Note that due to long-ish compilation time you may get an error reported when 
# things actually compiled fine:                                                                                                                        
# Invoke-MSBuild : Object '/blah.rem' has been disconnected or does not exist at the server.   
Install-SharedLibsMultiCfg -Solutions $lvlThreeSlns -LibsDirs $libsDirs -BuildPlatforms $buildPlatforms -BuildMode $buildMode -ToolsVersion $toolsVersion -LibNames $lvlThreeLibnames 

$headerDirectories = @{}
$headerDirectories[$swiftLibName] = (Join-Path $csiroBitbucket 'swift\libswift\include\swift')
Copy-HeaderFiles -headerDirectories $headerDirectories -ToDir $includeDir

# Swift unit tests also:
$lvlThreeSlns[$swiftLibName] = (Join-Path $csiroBitbucket 'swift\Solutions\SWIFT\SWIFT.sln')

# Note that due to long-ish compilation time you may get an error reported when 
# things actually compiled fine:                                                                                                                        
# Invoke-MSBuild : Object '/blah.rem' has been disconnected or does not exist at the server.   
Install-SharedLibsMultiCfg -Solutions $lvlThreeSlns -LibsDirs $libsDirs -BuildPlatforms $buildPlatforms -BuildMode $buildMode -ToolsVersion $toolsVersion -LibNames $lvlThreeLibnames 

# $rppLibName = 'rpp'
# $rppSlns = @{}
# $rppSlns[$rppLibName] = (Join-Path $csiroBitbucket 'rpp-cpp\rpp.sln')
# $rppLibnames = @($rppLibName)

# Install-SharedLibsMultiCfg -Solutions $rppSlns -LibsDirs $libsDirs -BuildPlatforms $buildPlatforms -BuildMode $buildMode -ToolsVersion $toolsVersion -LibNames $rppLibnames 

# $headerDirectories = @{}
# $headerDirectories[$rppLibName] = (Join-Path $csiroBitbucket 'rpp-cpp\include\rpp')
# Copy-HeaderFiles -headerDirectories $headerDirectories -ToDir $includeDir

########## Level four, QPP depends on swift...
$qppcoreLibName = 'qppcore'
$qppLibName = 'qpp'

$headerDirectories = @{}
$headerDirectories[$qppLibName] = (Join-Path $csiroBitbucket 'qpp\libqpp\include\qpp')
Copy-HeaderFiles -headerDirectories $headerDirectories -ToDir $includeDir

$lvlFourSlns = @{}
# Using two solution files is a bit of a workaround the assumption that one dll of interest means one solution.
$lvlFourSlns[$qppcoreLibName] = (Join-Path $csiroBitbucket 'qpp\solutions\qpp\qppcore.sln')
$lvlFourSlns[$qppLibName] = (Join-Path $csiroBitbucket 'qpp\solutions\qpp\QPP.sln')
$lvlFourLibnames = @($qppLibName, $qppcoreLibName)

Install-SharedLibsMultiCfg -Solutions $lvlFourSlns -LibsDirs $libsDirs -BuildPlatforms $buildPlatforms -BuildMode $buildMode -ToolsVersion $toolsVersion -LibNames $lvlFourLibnames 


