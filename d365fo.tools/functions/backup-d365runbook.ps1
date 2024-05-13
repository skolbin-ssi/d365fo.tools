﻿
<#
    .SYNOPSIS
        Backup a runbook file
        
    .DESCRIPTION
        Backup a runbook file for you to persist it for later analysis
        
    .PARAMETER File
        Path to the file you want to backup
        
    .PARAMETER DestinationPath
        Path to the folder where you want the backup file to be placed
        
    .PARAMETER Force
        Instructs the cmdlet to overwrite the destination file if it already exists
        
    .EXAMPLE
        PS C:\> Backup-D365Runbook -File "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook_20190327.xml"
        
        This will backup the "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook_20190327.xml".
        The default destination folder is used, "c:\temp\d365fo.tools\runbookbackups\".
        
    .EXAMPLE
        PS C:\> Backup-D365Runbook -File "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook_20190327.xml" -Force
        
        This will backup the "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook_20190327.xml".
        The default destination folder is used, "c:\temp\d365fo.tools\runbookbackups\".
        If the file already exists in the destination folder, it will be overwritten.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook | Backup-D365Runbook
        
        This will backup all runbook files found with the "Get-D365Runbook" cmdlet.
        The default destination folder is used, "c:\temp\d365fo.tools\runbookbackups\".
        
    .NOTES
        Tags: Runbook, Backup, Analysis
        
        Author: Mötz Jensen (@Splaxi)
#>

function Backup-D365Runbook {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Path')]
        [string] $File,

        [string] $DestinationPath = $(Join-Path $Script:DefaultTempPath "RunbookBackups"),

        [switch] $Force
    )

    begin {
        if (-not (Test-PathExists -Path $DestinationPath -Type Container -Create)) { return }
    }
    
    process {

        if (-not (Test-PathExists -Path $File -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }

        Backup-File -File $File -DestinationPath $DestinationPath -Force:$Force
    }
}