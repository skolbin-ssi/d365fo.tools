﻿
<#
    .SYNOPSIS
        Start a database refresh between 2 environments
        
    .DESCRIPTION
        Start a database refresh between 2 environments from a LCS project
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER SourceEnvironmentId
        The unique id of the environment that you want to use as the source for the database refresh
        
        The Id can be located inside the LCS portal
        
    .PARAMETER TargetEnvironmentId
        The unique id of the environment that you want to use as the target for the database refresh
        
        The Id can be located inside the LCS portal
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        The value depends on where your LCS project is located. There are multiple valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.ch.lcs.dynamics.com"
        "https://lcsapi.no.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        "https://lcsapi.gov.lcs.microsoftdynamics.us"
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER SkipInitialStatusFetch
        Instruct the cmdlet to skip the first fetch of the database refresh status
        
        Useful when you have a large script that handles this status validation and you don't want to spend time with this cmdlet
        
        Default output from this cmdlet is 2 (two) different objects. The first object is the response object for starting the refresh operation. The second object is the response object from fetching the status of the refresh operation.
        
        Setting this parameter (activate it), will affect the number of output objects. If you skip, only the first response object outputted.
        
    .PARAMETER FailOnErrorMessage
        Instruct the cmdlet to write logging information to the console, if there is an error message in the response from the LCS endpoint
        
        Used in combination with either Enable-D365Exception cmdlet, or the -EnableException directly on this cmdlet, it will throw an exception and break/stop execution of the script
        This allows you to implement custom retry / error handling logic
        
    .PARAMETER RetryTimeout
        The retry timeout, before the cmdlet should quit retrying based on the 429 status code
        
        Needs to be provided in the timspan notation:
        "hh:mm:ss"
        
        hh is the number of hours, numerical notation only
        mm is the number of minutes
        ss is the numbers of seconds
        
        Each section of the timeout has to valid, e.g.
        hh can maximum be 23
        mm can maximum be 59
        ss can maximum be 59
        
        Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDatabaseRefresh -ProjectId 123456789 -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will start the database refresh between the Source and Target environments.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
        
        This will start the database refresh between the Source and Target environments.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> $databaseRefresh = Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -SkipInitialStatusFetch
        PS C:\> $databaseRefresh | Get-D365LcsDatabaseOperationStatus -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e9" -SleepInSeconds 60
        
        This will start the database refresh between the Source and Target environments.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        It will skip the first database refesh status fetch and only output the details from starting the refresh.
        
        The output from Invoke-D365LcsDatabaseRefresh is stored in the $databaseRefresh. This will enable you to pass the $databaseRefresh variable to other cmdlets which should make things easier for you.
        
        Will pipe the $databaseRefresh variable to the Get-D365LcsDatabaseOperationStatus cmdlet and get the status from the database refresh job.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -SkipInitialStatusFetch
        
        This will start the database refresh between the Source and Target environments.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        It will skip the first database refesh status fetch and only output the details from starting the refresh.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -RetryTimeout "00:01:00"
        
        This will start the database refresh between the Source and Target environments, and allow for the cmdlet to retry for no more than 1 minute.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Get-D365LcsAssetValidationStatus
        
    .LINK
        Get-D365LcsDeploymentStatus
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Invoke-D365LcsUpload
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        The ActivityId property is a custom property that ISN'T part of the response from the LCS API. The ActivityId is always the same as the OperationActivityId (original LCS property).
        The EnvironmentId property is a custom property that ISN'T part of the response from the LCS API. The EnvironmentId is always the same as the SourceEnvironmentId parameter you have supplied to this cmdlet.
        
        Default output from this cmdlet is 2 (two) different objects. The first object is the response object for starting the refresh operation. The second object is the response object from fetching the status of the refresh operation.
        
        Setting the SkipInitialStatusFetch parameter (activate it), will affect the number of output objects. If you skip, only the first response object outputted.
        
        Running with the default (SkipInitialStatusFetch NOT being set), will instruct the cmdlet to call the Get-D365LcsDatabaseOperationStatus cmdlet. This will output a second object, with other properties than the first object outputted.
        
        Tags: Environment, Config, Configuration, LCS, Database backup, Api, Backup, Restore, Refresh
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Invoke-D365LcsDatabaseRefresh {
    [CmdletBinding()]
    [OutputType()]
    param(
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true)]
        [string] $SourceEnvironmentId,
        
        [Parameter(Mandatory = $true)]
        [string] $TargetEnvironmentId,

        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $SkipInitialStatusFetch,

        [switch] $FailOnErrorMessage,
        
        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    if (-not ($BearerToken.StartsWith("Bearer "))) {
        $BearerToken = "Bearer $BearerToken"
    }

    $refreshJob = Start-LcsDatabaseRefreshV2 -ProjectId $ProjectId -BearerToken $BearerToken -SourceEnvironmentId $SourceEnvironmentId -TargetEnvironmentId $TargetEnvironmentId -LcsApiUri $LcsApiUri -RetryTimeout $RetryTimeout

    if (Test-PSFFunctionInterrupt) { return }

    if ($FailOnErrorMessage -and $refreshJob.ErrorMessage) {
        $messageString = "The request against LCS succeeded, but the response was an error message for the operation: <c='em'>$($refreshJob.ErrorMessage)</c>."
        $errorMessagePayload = "`r`n$($refreshJob | ConvertTo-Json)"
        Write-PSFMessage -Level Host -Message $messageString -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $refreshJob
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $refreshJob
    }
    
    $temp = [PSCustomObject]@{ EnvironmentId = "$TargetEnvironmentId"; OperationStatus = "NotStarted"; ProjectId = $ProjectId }
    #Hack to silence the PSScriptAnalyzer
    $temp | Out-Null
 
    $refreshJob | Select-PSFObject *, "OperationActivityId as ActivityId", "EnvironmentId from temp as EnvironmentId", "OperationStatus from temp as OperationStatus", "ProjectId from temp as ProjectId" -TypeName "D365FO.TOOLS.LCS.Database.Operation.Status"

    if (-not $SkipInitialStatusFetch) {
        Get-D365LcsDatabaseOperationStatus -ProjectId $ProjectId -BearerToken $BearerToken -OperationActivityId $($refreshJob.OperationActivityId) -EnvironmentId $TargetEnvironmentId -LcsApiUri $LcsApiUri -WaitForCompletion:$false -SleepInSeconds 60
    }

    Invoke-TimeSignal -End
}