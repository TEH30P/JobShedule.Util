param
(	[parameter(Mandatory=1, position=0)]
		[String]$iLogPathRoot = ''
)
#--------------------------------#

[String]${Script:m~SrciptDir} = $PSScriptRoot;
[psobject]${Script:m~PSModule} = $ExecutionContext.SessionState.Module;
[String]${Script:m~LogPathRoot} = [string]::Empty;

#--------------------------------#
function m~PSModule~Init([String]$iLogPathRoot)
{try
{	if ([String]::IsNullOrEmpty($iLogPathRoot))
	{
		throw New-Object ArgumentNullException('iLogPathRoot', 'Default (empty) value not allowed.')
	}

	if (-not [IO.Path]::IsPathRooted($iLogPathRoot))
	{
		throw New-Object ArgumentException('Value must be absolute path.', 'iLogPathRoot')
	}
	
	if (-not [IO.Directory]::Exists($iLogPathRoot))
	{
		throw New-Object IO.FileNotFoundException("The directory '$iLogPathRoot' is not found.")
	}
	
	${Script:m~LogPathRoot} = $iLogPathRoot.TrimEnd('\');
}
catch 
{	
	${Script:m~LogPathRoot} = [IO.Path]::GetTempPath().TrimEnd('\');
	Write-Warning "The error occured during processing module arguments. '~SJLog~*' functions will write log files in %temp% folder until you call '~SJLog~Dir~Set' with flag 'fRoot' and proper 'iPath' parameter value.`r`n$_"
}
}
#--------------------------------#
<#!!!DBG: [key] Debug version
function m~PSModuleComponent~Load
(	[string]$FileName)
{	. $FileName
	Write-Warning "Loaded '$FileName': for test/dev."
}
#>
#!!!REM: [key] Release version
function m~PSModuleComponent~Load
(	[string]$FileName)
{	$ExecutionContext.InvokeCommand.InvokeScript(
		$false
	,	([scriptblock]::Create([IO.File]::ReadAllText($FileName, [Text.Encoding]::UTF8)))
	,	$null
	,	$null)	
}
#>
#--------------------------------#

m~PSModule~Init $iLogPathRoot;
Remove-Variable iLogPathRoot;

[String]$FileName = "${m~SrciptDir}\priv";

foreach ($FileName in [IO.Directory]::GetFiles($FileName))
{	if ($FileName.EndsWith('.ps1')) 
	{	. m~PSModuleComponent~Load $FileName}
}

[String]$FileName = "${m~SrciptDir}\pub";

foreach ($FileName in [IO.Directory]::GetFiles($FileName))
{	if ($FileName.EndsWith('.ps1'))
	{	. m~PSModuleComponent~Load $FileName}

	if ($FileName.EndsWith('.cs'))
	{	if ([IO.Path]::GetFileNameWithoutExtension($FileName) -as [Type])
		{	continue}

		[String[]]$aRefAcc = @();
		[String]$Definiction = [string]::Empty;

		foreach ($LineIt in [IO.File]::ReadAllLines($FileName, [Text.Encoding]::UTF8))
		{	if ($LineIt.StartsWith('//ref:'))
			{	$aRefAcc += $LineIt.Substring(('//ref:').Length).TrimStart()}
			else
			{	$Definiction += "`r`n" + $LineIt}
		}

		Add-Type -ReferencedAssemblies $aRefAcc -TypeDefinition $Definiction | Out-Null;
	}
}

New-Variable -Name '~SJLog~Opt' -Value (New-Object NPSShJob.CLogOpt(${Script:m~LogPathRoot}, '', [DateTime]::Now)) -Option ReadOnly -Scope Global -Force;
Remove-Variable 'm~LogPathRoot' -Scope Script;

[Text.StringBuilder]${Script:m~SBMain} = New-Object Text.StringBuilder(64kb, 64kb);
[String]${Script:m~Log~FSNameInstId} = m~DHex~ToString ([BigInt]$Host.InstanceId.ToByteArray());

Export-ModuleMember -Function '~SJob~*', '~FSName~*', '~SJLog~*', '~SJConf~*', '~TimeFreq~*' -Cmdlet '~SJob~*', '~FSName~*', '~SJLog~*', '~SJConf~*', '~TimeFreq~*' -Alias '*-SJob*', '*-FSName*', '*-SJConf*', '*-SJLog*' -Variable '~SJob~*', '~SJLog~Opt';