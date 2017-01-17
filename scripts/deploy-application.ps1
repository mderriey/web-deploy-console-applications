<#
  .SYNOPSIS
  This script deploys the a Web Deploy package in a folder

  .PARAMETER PackageFilePath
  The path of the WebDeploy package

  .PARAMETER DestinationFolderName
  The name of the folder where the package will be deployed

  .PARAMETER ParametersValuesFilePath
  The path of the file containing the parameters values

  .EXAMPLE
  .\deploy-application.ps1 -PackageFilePath console-application.zip -DestinationFolderName deployed-console-application -ParametersValuesFilePath .\parameters.values.xml
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]
  $PackageFilePath,

  [Parameter(Mandatory = $true)]
  [string]
  $DestinationFolderName,

  [Parameter(Mandatory = $true)]
  [string]
  $ParametersValuesFilePath
)

$scriptPath = $PSScriptRoot
$msDeployExePath = "C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe"
if (-not (Test-Path -Path $msDeployExePath -PathType Leaf)) {
  throw "We couldn't find Web Deploy at '$msDeployExePath', please install it first visiting https://www.iis.net/downloads/microsoft/web-deploy"
}

if (-not (Test-Path -Path $PackageFilePath -PathType Leaf)) {
  throw "We couldn't find the source package at '$PackageFilePath'. Maybe you need to package the application first with package-application.ps1?"
}

if (-not (Test-Path -Path $ParametersValuesFilePath -PathType Leaf)) {
  throw "We couldn't find the parameters values file at '$ParametersValuesFilePath'."
}

# Web Deploy requires absolute paths
$absolutePackageFilePath = Resolve-Path (Join-Path -Path $scriptPath -ChildPath $PackageFilePath)
$absoluteDestinationFolderPath = Join-Path -Path $scriptPath -ChildPath $DestinationFolderName
$absoluteParametersValuesFilePath = Resolve-Path $ParametersValuesFilePath

$deployArgs = @(
  "-verb:sync",
  "-source:package=`"$absolutePackageFilePath`"",
  "-dest:dirPath=`"$absoluteDestinationFolderPath`"",
  "-setParamFile:`"$absoluteParametersValuesFilePath`""
)

& $msDeployExePath $deployArgs