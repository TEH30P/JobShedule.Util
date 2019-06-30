New-Alias -Name Set-SJLogDir -Value '~SJLog~Dir~Set' -Force;

# Setting the folder path for log files.
function ~SJLog~Dir~Set
{   param 
    (   [parameter(Mandatory=1)]
            [String]$iPath
    ,   [parameter(Mandatory=0)]
            [switch]$fRoot
    )
try 
{
	if ($fRoot)
	{
		[String]$DirPath = [IO.Path]::Combine($iPath, ${Global:~SJLog~PathRoot}.DirPath)
	}
	else
	{
		[String]$DirPath = [IO.Path]::Combine(${Global:~SJLog~PathRoot}.DirRootPath, $iPath)
	}

	if (-not [IO.Directory]::Exists($DirPath))
	{
		[void][IO.Directory]::CreateDirectory($DirPath)
	}

	[String]$DirPath = $iPath;

	if ($iPath.EndsWith('\'))
	{
		$DirPath = $DirPath.Remove($DirPath.Length - 1)
	}

	if ($fRoot)
	{
		${Global:~SJLog~PathRoot}.DirRootPath = $DirPath;
	}
	else
	{
		${Global:~SJLog~PathRoot}.DirPath = $DirPath;
	}
}
catch
{
	throw
}
}