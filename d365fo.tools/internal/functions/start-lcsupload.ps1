﻿
<#
    .SYNOPSIS
        Start the upload process to LCS
        
    .DESCRIPTION
        Start the flow of actions to upload a file to LCS
        
    .PARAMETER Token
        The token to be used for the http request against the LCS API
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER FileType
        Type of file you want to upload
        
        Valid options:
        "Model"
        "Process Data Package"
        "Software Deployable Package"
        "GER Configuration"
        "Data Package"
        "PowerBI Report Model"
        "E-Commerce Package"
        "NuGet Package"
        "Retail Self-Service Package"
        "Commerce Cloud Scale Unit Extension"
        
    .PARAMETER Name
        Name to be assigned / shown on LCS
        
    .PARAMETER Filename
        Filename to be assigned / shown on LCS
        
        Often will it require an extension for it to be accepted
        
    .PARAMETER Description
        Description to be assigned / shown on LCS
        
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
        PS C:\> Start-LcsUpload -Token "Bearer JldjfafLJdfjlfsalfd..." -ProjectId 123456789 -FileType "SoftwareDeployablePackage" -Name "ReadyForTesting" -Filename "ReadyForTesting.zip" -Description "Latest release that fixes it all" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will contact the NON-EUROPE LCS API and instruct it that we want to upload a new file to the Asset Library.
        The token "Bearer JldjfafLJdfjlfsalfd..." is used to the authorize against the LCS API.
        The ProjectId is 123456789 and FileType is "SoftwareDeployablePackage".
        The file will be named "ReadyForTesting" and the Description will be "Latest release that fixes it all".
        
    .NOTES
        Tags: Url, LCS, Upload, Api, Token
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Start-LcsUpload {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Token,

        [Parameter(Mandatory = $true)]
        [int] $ProjectId,

        [Parameter(Mandatory = $true)]
        [LcsAssetFileType] $FileType,

        [string] $Name,

        [string] $Filename,

        [string] $Description,

        [string] $LcsApiUri,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    if ($Description -eq "") {
        $jsonDescription = "null"
    }
    else {
        $jsonDescription = "`"$Description`""
    }

    $fileTypeValue = [int]$FileType
    $jsonFile = "{ `"Name`": `"$Name`", `"FileName`": `"$Filename`", `"FileDescription`": $jsonDescription, `"SizeByte`": 0, `"FileType`": $fileTypeValue }"

    Write-PSFMessage -Level Verbose -Message "Json payload for LCS generated." -Target $jsonFile
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()
    $client.DefaultRequestHeaders.UserAgent.ParseAdd("d365fo.tools via PowerShell")
    
    $createUri = "$LcsApiUri/box/fileasset/CreateFileAsset/$ProjectId"

    $request = New-JsonRequest -Uri $createUri -Content $jsonFile -Token $Token

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
                Write-PSFMessage -Level Host -Message "Error creating new file asset. $($asset.Message)" -Target $($asset.Message)
                Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
                return
            }
            else {
                Write-PSFMessage -Level Host -Message "API Call returned $($result.StatusCode)." -Target $($result.ReasonPhrase)
                Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
                return
            }
        }

        if (-not ($asset.Id)) {
            if ($asset.Message) {
                Write-PSFMessage -Level Host -Message "Error creating new file asset." -Target $($asset.Message)
                Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            }
            else {
                Write-PSFMessage -Level Host -Message "Unknown error creating new file asset." -Target $asset
                Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            }
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        return
    }

    Invoke-TimeSignal -End
    
    $asset
}