## Web Deploy and console applications

This repo shows how to leverage Web Deploy to package and deploy console applications.

## Steps

 - Open the VS solution in the `src` folder
 - Compile it
 - Open a PowerShell prompt in the `scripts` folder
 - Run `.\package-application.ps1 -SourceFolder ..\src\ConsoleApplication\bin\Debug -DestinationFileName console-application.zip`. This will create a `console-application.zip` package
 - Then execute `.\deploy-application.ps1 -PackageFilePath console-application.zip -DestinationFolderName deployed-console-application -ParametersValuesFilePath .\parameters-values.xml`. This will deploy the application in the `deployed-console-application` folder using the parameters values in the `parameters-values.xml` file
