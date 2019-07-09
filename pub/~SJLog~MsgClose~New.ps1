New-Alias -Name New-SJLogCloseMsg -Value '~SJLog~MsgClose~New' -Force;

# New log close-mark message. Will create message file, if it not exist.
function ~SJLog~MsgClose~New
{	param
	(	[parameter(Mandatory=1, Position=0)]
			[NPSShJob.EMsgSevernity]$iLogSeverity
	,	[parameter(Mandatory=0, Position=1)]
			[DateTime]$iLogAt = ${~SJLog~Opt}.LogDate #!!!STUB: Deprecated parameter. Will be removed in future.
	,	[parameter(Mandatory=0)]
			[String]$iLogSrc = ''
	)
try
{
	m~FileBuff~File~Open~i (m~FSName~LogPath~Gen~i ${m~SBMain}.Clear() $iLogSeverity $iLogSrc);
	m~FileBuff~SB~Save~i (${m~SBMain}.Clear().AppendLine().Append('---')) -iFSBClear $True | Out-Null;
	m~FileBuff~File~Close~i;
}
catch 
{
	throw	
}}
