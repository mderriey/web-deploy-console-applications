<#
  .SYNOPSIS
  This script packages the ConsoleApplication into a WebDeploy package

  .PARAMETER SourceFolder
  The path to the folder where the binaries of the console application are present

  .PARAMETER DestinationFileName
  The name of the package that will be created

  .EXAMPLE
  .\package-application.ps1 -SourceFolder ..\src\ConsoleApplication\bin\Debug -DestinationFileName console-application.zip
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]
  $SourceFolder,

  [Parameter(Mandatory = $true)]
  [string]
  $DestinationFileName
)

$scriptPath = $PSScriptRoot
$msDeployExePath = "C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe"
if (-not (Test-Path -Path $msDeployExePath -PathType Leaf)) {
  throw "We couldn't find Web Deploy at '$msDeployExePath', please install it first visiting https://www.iis.net/downloads/microsoft/web-deploy"
}

if (-not (Test-Path -Path $SourceFolder -PathType Container)) {
  throw "We couldn't find the source folder at '$SourceFolder'. Maybe you need to build the VS solution first?"
}

# Web Deploy requires absolute paths
$absoluteSourceFolderPath = Resolve-Path $SourceFolder
$absoluteDestinationFilePath = Join-Path -Path $scriptPath -ChildPath $DestinationFileName

$parametersFile = Join-Path -Path $absoluteSourceFolderPath -ChildPath "parameters.xml"
if (-not (Test-Path -Path $parametersFile -PathType Leaf)) {
  throw "We couldn't find the parameters declaration file at '$parametersFile'."
}

$packageArgs = @(
  "-verb:sync",
  "-source:dirPath=`"$absoluteSourceFolderPath`"",
  "-dest:package=`"$absoluteDestinationFilePath`"",
  "-declareParamFile:`"$parametersFile`""
)

& $msDeployExePath $packageArgs