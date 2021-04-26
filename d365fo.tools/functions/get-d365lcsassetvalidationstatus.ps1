﻿
<#
    .SYNOPSIS
        Get the validation status from LCS
        
    .DESCRIPTION
        Get the validation status for a given file in the Asset Library in LCS
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
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
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER WaitForValidation
        Instruct the cmdlet to wait for the validation process to complete
        
        The cmdlet will sleep for 60 seconds, before requesting the status of the validation process from LCS
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetValidationStatus -ProjectId 123456789 -BearerToken "JldjfafLJdfjlfsalfd..." -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will check the validation status for the file in the Asset Library.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
        The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetValidationStatus -AssetId "958ae597-f089-4811-abbd-c1190917eaae"
        
        This will check the validation status for the file in the Asset Library.
        The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetValidationStatus -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -WaitForValidation
        
        This will check the validation status for the file in the Asset Library.
        The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
        The cmdlet will every 60 seconds contact the LCS API endpoint and check if the status of the validation is either success or failure.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsUpload -FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip" | Get-D365LcsAssetValidationStatus -WaitForValidation
        
        This will start the upload of a file to the Asset Library and check the validation status for the file in the Asset Library.
        The file that will be uploaded is based on the FilePath "C:\temp\d365fo.tools\Release-2019-05-05.zip".
        The output object received from Invoke-D365LcsUpload is piped directly to Get-D365LcsAssetValidationStatus.
        The cmdlet will every 60 seconds contact the LCS API endpoint and check if the status of the validation is either success or failure.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Get-D365LcsDeploymentStatus
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Invoke-D365LcsDeployment
        
    .LINK
        Invoke-D365LcsUpload
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365LcsAssetValidationStatus {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $false)]
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Parameter(Mandatory = $false)]
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $AssetId,

        [Parameter(Mandatory = $false)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $WaitForValidation,

        [switch] $EnableException
    )


    process {
        Invoke-TimeSignal -Start

        if (-not ($BearerToken.StartsWith("Bearer "))) {
            $BearerToken = "Bearer $BearerToken"
        }

        do {
            Write-PSFMessage -Level Verbose -Message "Sleeping before hitting the LCS API for Asset Validation Status"
            Start-Sleep -Seconds 60
            $status = Get-LcsAssetValidationStatus -BearerToken $BearerToken -ProjectId $ProjectId -AssetId $AssetId -LcsApiUri $LcsApiUri
        }
        while (($status.DisplayStatus -eq "Process") -and $WaitForValidation)

        Invoke-TimeSignal -End

        $status | Select-PSFObject "ID as AssetId", "DisplayStatus as Status"
    }
}