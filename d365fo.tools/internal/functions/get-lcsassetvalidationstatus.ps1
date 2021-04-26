﻿
<#
    .SYNOPSIS
        Get the validation status from LCS
        
    .DESCRIPTION
        Get the validation status for a given file in the Asset Library in LCS
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER AssetId
        The unique id of the asset / file that you are trying to deploy from LCS
        
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
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-LcsAssetValidationStatus -ProjectId 123456789 -BearerToken "JldjfafLJdfjlfsalfd..." -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will check the file with the AssetId "958ae597-f089-4811-abbd-c1190917eaae" in validated or not.
        It will test against the Asset Library located under the LCS project 123456789.
        The BearerToken "JldjfafLJdfjlfsalfd..." is used to authenticate against the LCS API endpoint.
        The file will be named "ReadyForTesting" inside the Asset Library in LCS.
        The file is validated against the NON-EUROPE LCS API.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Get-LcsAssetValidationStatus {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [int] $ProjectId,
        
        [Parameter(Mandatory = $true, Position = 2)]
        [Alias('Token')]
        [string] $BearerToken,

        [Parameter(Mandatory = $true, Position = 3)]
        [string] $AssetId,

        [Parameter(Mandatory = $true, Position = 4)]
        [string] $LcsApiUri,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()
    $client.DefaultRequestHeaders.UserAgent.ParseAdd("d365fo.tools via PowerShell")
    
    $checkUri = "$LcsApiUri/box/fileasset/GetFileAssetValidationStatus/$($ProjectId)?assetId=$AssetId"

    $request = New-JsonRequest -Uri $checkUri -Token $BearerToken -HttpMethod "GET"

    try {
        Write-PSFMessage -Level Verbose -Message "Invoke LCS request." -Target $request
        $result = Get-AsyncResult -task $client.SendAsync($request)

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        $responseString = Get-AsyncResult -task $result.Content.ReadAsStringAsync()

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS." -Target $responseString
        
        try {
            $asset = ConvertFrom-Json -InputObject $responseString -ErrorAction SilentlyContinue
        }
        catch {
            Write-PSFMessage -Level Critical -Message "$responseString"
        }

        Write-PSFMessage -Level Verbose -Message "Extracting the asset json response received from LCS." -Target $asset
        
        if (-not ($result.StatusCode -eq [System.Net.HttpStatusCode]::OK)) {
            if (($asset) -and ($asset.Message)) {
                Write-PSFMessage -Level Host -Message "Error getting the validation status of the file asset." -Target $($asset.Message)
                Stop-PSFFunction -Message "Stopping because of errors"
            }
            else {
                Write-PSFMessage -Level Host -Message "API Call returned $($result.StatusCode)." -Target $($result.ReasonPhrase)
                Stop-PSFFunction -Message "Stopping because of errors"
            }
        }

        if (-not ($asset.Id)) {
            if ($asset.Message) {
                Write-PSFMessage -Level Host -Message "Error getting the validation status of the file asset." -Target $($asset.Message)
                Stop-PSFFunction -Message "Stopping because of errors"
            }
            else {
                Write-PSFMessage -Level Host -Message "Unknown error getting the validation status of the file asset." -Target $asset
                Stop-PSFFunction -Message "Stopping because of errors"
            }
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }

    Invoke-TimeSignal -End

    $asset
}