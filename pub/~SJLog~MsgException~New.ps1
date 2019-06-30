New-Alias -Name New-SJLogExceptionMsg -Value '~SJLog~MsgException~New' -Force;

# <try..catch> block handler. New log message with exception. Will create message file, if it not exist.
function ~SJLog~MsgException~New
{	param
	(	[parameter(Mandatory=0, Position=0)]
			[NPSShJob.EMsgSevernity]$iLogSeverity = 'Err'
	,	[parameter(Mandatory=1, Position=1)]
			[DateTime]$iLogAt
	,	[parameter(Mandatory=1, Position=2)]
			$iPSErrorInfo
	,	[parameter(Mandatory=0)]
			[DateTime]$iAt = [DateTime]::Now
	,	[parameter(Mandatory=0)]
			[String]$iLogSrc = ''
	,	[parameter(Mandatory=0)]
			[switch]$fNoWinEvent
	)
try
{
	m~FileBuff~File~Open~i (m~FSName~LogPath~Gen~i ${m~SBMain}.Clear() $iLogSeverity $iLogAt $iLogSrc);
	[Void]${m~SBMain}.Clear();

	m~YAML~Value~Save ${m~SBMain} ('{0:O}:' -f $iAt) '' 0 -iFSBClear $true;
	m~YAML~Value~Save ${m~SBMain} 'Error    :' ([String]$iPSErrorInfo.ScriptStackTrace) 1 -iFSBClear $true;
	m~YAML~Value~Save ${m~SBMain} 'Exception:' '' 1 -iFSBClear $true;

	$XXX = $iPSErrorInfo.Exception;

	while ($XXX) 
	{
		m~YAML~Value~Save ${m~SBMain} '- Type   :' ($XXX.GetType().FullName) (2 + 0) -iFSBClear $true;
		m~YAML~Value~Save ${m~SBMain}   'Message:' ($XXX.Message           ) (2 + 2) -iFSBClear $true;
		$XXX = $XXX.InnerException;
	}

	m~FileBuff~File~Close~i;
}
catch 
{
	throw	
}}