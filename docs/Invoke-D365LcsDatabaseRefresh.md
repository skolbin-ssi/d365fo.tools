﻿---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365LcsDatabaseRefresh

## SYNOPSIS
Start a database refresh between 2 environments

## SYNTAX

```
Invoke-D365LcsDatabaseRefresh [[-ProjectId] <Int32>] [[-BearerToken] <String>] [-SourceEnvironmentId] <String>
 [-TargetEnvironmentId] <String> [[-LcsApiUri] <String>] [-SkipInitialStatusFetch] [<CommonParameters>]
```

## DESCRIPTION
Start a database refresh between 2 environments from a LCS project

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365LcsDatabaseRefresh -ProjectId 123456789 -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
```

This will start the database refresh between the Source and Target environments.
The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).

### EXAMPLE 2
```
Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
```

This will start the database refresh between the Source and Target environments.
The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

### EXAMPLE 3
```
$databaseRefresh = Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -SkipInitialStatusFetch
```

PS C:\\\> $databaseRefresh | Get-D365LcsDatabaseOperationStatus -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e9" -SleepInSeconds 60

This will start the database refresh between the Source and Target environments.
The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
It will skip the first database refesh status fetch and only output the details from starting the refresh.

The output from Invoke-D365LcsDatabaseRefresh is stored in the $databaseRefresh.
This will enable you to pass the $databaseRefresh variable to other cmdlets which should make things easier for you.

Will pipe the $databaseRefresh variable to the Get-D365LcsDatabaseOperationStatus cmdlet and get the status from the database refresh job.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.


$databaseRefresh = Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId be9aa4a4-7621-4b7e-b6f5-d518bf0012de -TargetEnvironmentId 43bcc00a-d94c-47cd-a20f-3c7aee98b5a9

### EXAMPLE 4
```
Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -SkipInitialStatusFetch
```

This will start the database refresh between the Source and Target environments.
The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
It will skip the first database refesh status fetch and only output the details from starting the refresh.

All default values will come from the configuration available from Get-D365LcsApiConfig.

The default values can be configured using Set-D365LcsApiConfig.

## PARAMETERS

### -ProjectId
The project id for the Dynamics 365 for Finance & Operations project inside LCS

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $Script:LcsApiProjectId
Accept pipeline input: False
Accept wildcard characters: False
```

### -BearerToken
The token you want to use when working against the LCS api

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases: Token

Required: False
Position: 2
Default value: $Script:LcsApiBearerToken
Accept pipeline input: False
Accept wildcard characters: False
```

### -SourceEnvironmentId
The unique id of the environment that you want to use as the source for the database refresh

The Id can be located inside the LCS portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetEnvironmentId
The unique id of the environment that you want to use as the target for the database refresh

The Id can be located inside the LCS portal

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LcsApiUri
URI / URL to the LCS API you want to use

Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's

Valid options:
"https://lcsapi.lcs.dynamics.com"
"https://lcsapi.eu.lcs.dynamics.com"

Default value can be configured using Set-D365LcsApiConfig

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:LcsApiLcsApiUri
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipInitialStatusFetch
Instruct the cmdlet to skip the first fetch of the database refresh status

Useful when you have a large script that handles this status validation and you don't want to spend time with this cmdlet

Default output from this cmdlet is 2 (two) different objects.
The first object is the response object for starting the refresh operation.
The second object is the response object from fetching the status of the refresh operation.

Setting this parameter (activate it), will affect the number of output objects.
If you skip, only the first response object outputted.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The ActivityId property is a custom property that ISN'T part of the response from the LCS API.
The ActivityId is always the same as the OperationActivityId (original LCS property).
The EnvironmentId property is a custom property that ISN'T part of the response from the LCS API.
The EnvironmentId is always the same as the SourceEnvironmentId parameter you have supplied to this cmdlet.

Default output from this cmdlet is 2 (two) different objects.
The first object is the response object for starting the refresh operation.
The second object is the response object from fetching the status of the refresh operation.

Setting the SkipInitialStatusFetch parameter (activate it), will affect the number of output objects.
If you skip, only the first response object outputted.

Running with the default (SkipInitialStatusFetch NOT being set), will instruct the cmdlet to call the Get-D365LcsDatabaseOperationStatus cmdlet.
This will output a second object, with other properties than the first object outputted.

Tags: Environment, Config, Configuration, LCS, Database backup, Api, Backup, Restore, Refresh

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Get-D365LcsApiConfig]()

[Get-D365LcsApiToken]()

[Get-D365LcsAssetValidationStatus]()

[Get-D365LcsDeploymentStatus]()

[Invoke-D365LcsApiRefreshToken]()

[Invoke-D365LcsUpload]()

[Set-D365LcsApiConfig]()

