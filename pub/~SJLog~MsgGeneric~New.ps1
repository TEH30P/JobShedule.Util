New-Alias -Name New-SJLogGenericMsg -Value '~SJLog~MsgTyped~New' -Force;

# New log message. Will create message file, if it not exist.
function ~SJLog~MsgGeneric~New
{	param
	(	[parameter(Mandatory=0, Position=0)]
			[NPSShJob.EMsgSevernity]$iLogSeverity = 'Inf'
	,	[parameter(Mandatory=1, Position=1)]
			[DateTime]$iLogAt
	,	[parameter(Mandatory=1, Position=2)]
			$iMsg
	,	[parameter(Mandatory=0)]
			[DateTime]$iAt = [DateTime]::Now
	,	[parameter(Mandatory=0)]
			[String]$iKey
	,	[parameter(Mandatory=0)]
			[String]$iLogSrc = ''
	,	[parameter(Mandatory=0)]
			[switch]$fNoWinEvent
	)

	throw New-Object NotImplementedException;
}