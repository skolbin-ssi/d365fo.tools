﻿
<#
    .SYNOPSIS
        Complete the upload action in LCS
        
    .DESCRIPTION
        Signal to LCS that the upload of the blob has completed
        
    .PARAMETER Token
        The token to be used for the http request against the LCS API
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER AssetId
        The unique id of the asset / file that you are trying to upload to LCS
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.ch.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        "https://lcsapi.gov.lcs.microsoftdynamics.us"
        
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
        PS C:\> Complete-LcsUploadV2 -Token "Bearer JldjfafLJdfjlfsalfd..." -ProjectId 123456789 -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will commit the upload process for the AssetId "958ae597-f089-4811-abbd-c1190917eaae" in the LCS project with Id 123456789.
        The http request will be using the "Bearer JldjfafLJdfjlfsalfd..." token for authentication against the LCS API.
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Complete-LcsUploadV2 {
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [int]$ProjectId,

        [Parameter(Mandatory = $true)]
        [string]$AssetId,

        [Parameter(Mandatory = $false)]
        [string]$LcsApiUri,

        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )
    
    begin {
        Invoke-TimeSignal -Start
        
        $headers = @{
            "Authorization" = "$BearerToken"
        }

        $parms = @{}
        $parms.Method = "POST"
        $parms.Uri = "$LcsApiUri/box/fileasset/CommitFileAsset/$($ProjectId)?assetId=$AssetId"
        $parms.Headers = $headers
        $parms.RetryTimeout = $RetryTimeout
    }

    process {
        try {
            Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
            Invoke-RequestHandler @parms
        }
        catch [System.Net.WebException] {
            Write-PSFMessage -Level Host -Message "Error status code <c='em'>$($_.exception.response.statuscode)</c> in starting a new database refresh in LCS. <c='em'>$($_.exception.response.StatusDescription)</c>." -Exception $PSItem.Exception -Target $_
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            return
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            return
        }

        Invoke-TimeSignal -End
    }
}