New-Alias -Name New-SJLogMsg -Value '~SJLog~Msg~New' -Force;

# New log message. Will create message file, if it not exist.
function ~SJLog~Msg~New
{	param
	(	[parameter(Mandatory=0, Position=0)]
			[NPSShJob.EMsgSevernity]$iLogSeverity = 'Inf'
	,	[parameter(Mandatory=0, Position=1)]
			[DateTime]$iLogAt = ${~SJLog~Opt}.LogDate #!!!STUB: Deprecated parameter. Will be removed in future.
	,	[parameter(Mandatory=1, Position=2)]
			[String[]]$iaMsg
	,	[parameter(Mandatory=0)]
			[DateTime]$iAt = [DateTime]::Now
	,	[parameter(Mandatory=0)]
			[String]$iKey
	,	[parameter(Mandatory=0)]
			[String]$iLogSrc = ''
	,	[parameter(Mandatory=0)]
			[switch]$fAsKeyValue
	,	[parameter(Mandatory=0)]
			[switch]$fNoWinEvent
	)
try
{	
	m~FileBuff~File~Open~i (m~FSName~LogPath~Gen~i ${m~SBMain}.Clear() $iLogSeverity $iLogSrc);
	[Void]${m~SBMain}.Clear();

	if ([String]::IsNullOrEmpty($iKey))
	{
		[string]$Key = '{0:O}:' -f $iAt
	}
	else
	{
		[string]$Key = $iKey + ':'
	}

	if ($iaMsg.Count -eq 1)
	{
		m~YAML~Value~Save ${m~SBMain} $Key ($iaMsg[0]) 0
	}
	else
	{	
		m~YAML~Value~Save ${m~SBMain} $Key '' 0;
		
		if ($fAsKeyValue)
		{	
			$Key = [String]::Empty;

			foreach ($MsgIt in $iaMsg)
			{	
				if ($Key.Length)
				{	
					m~YAML~Value~Save ${m~SBMain} $Key $MsgIt 1;
					$Key = [String]::Empty;
				}
				else 
				{
					$Key = $MsgIt + ':'
				}
			}
			
			if ($Key.Length)
			{	
				throw New-Object ArgumentException('In key-value mode the iaMsg parameter must have even length.', 'iaMsg')
			}
		}
		else
		{	foreach ($MsgIt in $iaMsg)
			{	
				m~YAML~Value~Save ${m~SBMain} '-' $MsgIt 1
			}				
		}
	}
	
	m~FileBuff~File~Close~i;
}
catch 
{
	throw	
}}
