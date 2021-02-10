﻿
<#
    .SYNOPSIS
        Get View
        
    .DESCRIPTION
        Traverse the Dynamics 365 Finance & Operations code repository for all Views
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-AxViews
        
        This will get all objects.
        
    .NOTES
        Tags: Metadata, Report, Documentation
        Author: Mötz Jensen (@Splaxi)
#>
Function Get-AxViews {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param(

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    BEGIN {
        Import-GenerateReportAssemblies

        $providerConfig = New-Object Microsoft.Dynamics.AX.Metadata.Storage.DiskProvider.DiskProviderConfiguration
        $providerConfig.XppMetadataPath = $PackageDirectory
        $providerConfig.MetadataPath = $PackageDirectory

        $providerFactory = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
        $metadataProvider = $providerFactory.CreateDiskProvider($providerConfig)
    }

    PROCESS {

        $viewsModelInfos = $metadataProvider.Views.GetPrimaryKeysWithModelInfo()

        foreach ($tuple in $viewsModelInfos) {
            $elementName = $tuple.Item1

            $element = $metadataProvider.Views.Read($elementName)
            
            $outItems = New-Object PSObject -Property @{ # create a hash table of the name/value pair
                Name        = $element.Name
                DataSources = $element.ViewMetadata.DataSources

            }

            $outItems
        }
    }
}