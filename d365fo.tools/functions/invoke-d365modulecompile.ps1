﻿
<#
    .SYNOPSIS
        Compile a package / module / model
        
    .DESCRIPTION
        Compile a package / module / model using the builtin "xppc.exe" executable to compile source code
        
    .PARAMETER Module
        The package to compile
        
    .PARAMETER OutputDir
        The path to the folder to save generated artifacts
        
    .PARAMETER LogDir
        The path to the folder to save logs
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER ReferenceDir
        The full path of a folder containing all assemblies referenced from X++ code
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleCompile -Module MyModel
        
        This will use the default paths and start the xppc.exe with the needed parameters to compile MyModel package.
        The default output from the compile will be silenced.
        
        If an error should occur, both the standard output and error output will be written to the console / host.
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleCompile -Module MyModel -ShowOriginalProgress
        
        This will use the default paths and start the xppc.exe with the needed parameters to compile MyModel package.
        The output from the compile will be written to the console / host.
        
    .NOTES
        Tags: Compile, Model, Servicing, X++
        
        Author: Ievgen Miroshnikov (@IevgenMir)
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365ModuleCompile {
    [CmdletBinding()]
    [OutputType('[PsCustomObject]')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("ModuleName")]
        [string] $Module,

        [Alias('Output')]
        [string] $OutputDir = $Script:MetaDataDir,

        [string] $LogDir = $Script:DefaultTempPath,

        [string] $MetaDataDir = $Script:MetaDataDir,

        [string] $ReferenceDir = $Script:MetaDataDir,

        [string] $BinDir = $Script:BinDirTools,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    begin {
        Invoke-TimeSignal -Start

        $tool = "xppc.exe"
        $executable = Join-Path $BinDir $tool

        if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) { return }
        if (-not (Test-PathExists -Path $executable -Type Leaf)) { return }
        if (-not (Test-PathExists -Path $LogDir -Type Container -Create)) { return }

    }

    process {
        $logDirModule = Join-Path $LogDir $Module
        $outputDirModule = Join-Path $OutputDir $Module
        
        if (-not (Test-PathExists -Path $logDirModule -Type Container -Create)) { return }

        if (Test-PSFFunctionInterrupt) { return }
        
        $logFile = Join-Path $logDirModule "Dynamics.AX.$Module.xppc.log"
        $logXmlFile = Join-Path $logDirModule "Dynamics.AX.$Module.xppc.xml"

        $params = @("-metadata=`"$MetaDataDir`"",
            "-modelmodule=`"$Module`"",
            "-output=`"$outputDirModule\bin`"",
            "-referencefolder=`"$ReferenceDir`"",
            "-log=`"$logFile`"",
            "-xmlLog=`"$logXmlFile`"",
            "-verbose"
        )

        Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly

        if ($OutputCommandOnly) { return }

        [PSCustomObject]@{
            LogFile    = $logFile
            XmlLogFile = $logXmlFile
            PSTypeName = 'D365FO.TOOLS.ModuleCompileOutput'
        }
    
    }

    end {
        Invoke-TimeSignal -End
    }
}