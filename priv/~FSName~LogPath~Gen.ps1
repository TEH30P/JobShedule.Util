[hashtable]${m~Log~FSNameDSeverity} `
= @{Inf = 'Inf'; Err = 'Err'; Wrn = 'Wrn'; Dbg = 'Dbg';
	I   = 'Inf'; E   = 'Err'; W   = 'Wrn'; D   = 'Dbg'}
function m~FSName~LogPath~Gen~i
(	[Text.StringBuilder]$ioSBMain
,	[NPSShJob.EMsgSevernity]$iLogSeverity
,	[DateTime]$iLogAt
,	[String]$iLogSrc)
{	
	[String]$DirPath = ${Global:~SJLog~PathRoot}.DirRootPath;

	if (${Global:~SJLog~PathRoot}.DirPath.Length)
	{	$DirPath = [IO.Path]::Combine($DirPath, ${Global:~SJLog~PathRoot}.DirPath)}

	if ($DirPath.EndsWith('\'))
	{
		[Void]$ioSBMain.Append($DirPath)
	}
	else
	{
		[Void]$ioSBMain.Append($DirPath).Append('\')
	}
		
	[Void]$ioSBMain.AppendFormat('{0:yyyyMMdd-HHmmss}', $iLogAt);
	m~FSName~Str~Convert $ioSBMain.Append('.') $iLogSrc;
	[Void]$ioSBMain.Append('.').Append(${m~Log~FSNameDSeverity}[[String]$iLogSeverity]);
	[Void]$ioSBMain.Append('.').Append(${m~Log~FSNameInstId});

	return $ioSBMain.Append('.yml').ToString();
}