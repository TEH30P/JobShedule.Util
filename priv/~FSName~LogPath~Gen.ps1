[hashtable]${m~Log~FSNameDSeverity} `
= @{Inf = 'Inf'; Err = 'Err'; Wrn = 'Wrn'; Dbg = 'Dbg';
	I   = 'Inf'; E   = 'Err'; W   = 'Wrn'; D   = 'Dbg'}
function m~FSName~LogPath~Gen~i
(	[Text.StringBuilder]$ioSBMain
,	[NPSShJob.EMsgSevernity]$iLogSeverity
,	[String]$iLogSrc)
{	
	[String]$DirPath = ${Global:~SJLog~Opt}.DirRootPath;

	if (${Global:~SJLog~Opt}.DirPath.Length)
	{	$DirPath = [IO.Path]::Combine($DirPath, ${Global:~SJLog~Opt}.DirPath)}

	if ($DirPath.EndsWith('\'))
	{
		[Void]$ioSBMain.Append($DirPath)
	}
	else
	{
		[Void]$ioSBMain.Append($DirPath).Append('\')
	}
		
	[Void]$ioSBMain.AppendFormat('{0:yyyyMMdd-HHmmss}', ${Global:~SJLog~Opt}.LogDate);
	m~FSName~Str~Convert $ioSBMain.Append('.') $iLogSrc;
	[Void]$ioSBMain.Append('.').Append(${m~Log~FSNameDSeverity}[[String]$iLogSeverity]);
	[Void]$ioSBMain.Append('.').Append(${m~Log~FSNameInstId});

	return $ioSBMain.Append('.yml').ToString();
}