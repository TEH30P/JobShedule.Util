New-Alias -Name Import-SJConfFile -Value '~SJConf~File~Parse' -Force;

# Load and parse xml or json config file. If file is locked it will retry to read it for `-iTimeOut` period of time (default 30s).

function ~SJConf~File~Parse
{	param
	(	[parameter(Mandatory=1, Position=0)]
		[ValidateScript({Test-Path ($_)})]
			[String]$iPath
	,	[parameter(Mandatory=0)]
			[String]$iBasePath
	,	[parameter(Mandatory=1, Position=1)]
			[String]$iKeyRoot
	,	[parameter(Mandatory=0)]
			[String]$iKeyBasePath
	,	[parameter(Mandatory=0)]
			[TimeSpan]$iTimeOut = '0.00:00:30'
	);
try 
{
	if ($iKeyRoot.StartsWith('OV-'))
	{
		[String]$KeyRoot =  $iKeyRoot
	}
	elseif ($iKeyRoot.StartsWith('OV'))
	{
		[String]$KeyRoot = $iKeyRoot.Insert(2, '-')
	}
	else
	{
		[String]$KeyRoot = "OV-$iKeyRoot"
	}

	if ([String]::IsNullOrEmpty($iKeyBasePath))
	{	
		[String]$KeyBasePath = [String]::Empty
	}
	elseif ($iKeyBasePath.StartsWith('SV-'))
	{
		[String]$KeyBasePath =  $iKeyBasePath.Remove(2, 1)
	}
	elseif ($iKeyBasePath.StartsWith('SV'))
	{
		[String]$KeyBasePath =  $iKeyBasePath
	}
	else 
	{
		[String]$KeyBasePath = "SV$iKeyBasePath"
	}

	[String]$BasePathDef = $iBasePath;
	[string]$FSPath, [psobject]$RawRoot = m~ConfFile~Load $iPath '' $iTimeOut;

	[System.Collections.Queue]$MainQue = @();

	while ($FSPath.Length)
	{
		[NPSShJob.CConfData]$Ret = New-Object NPSShJob.CConfData -Property @{ValueTree = [NPSShJob.CConfData]::ValueTreeFactory()};

		$MainQue.Enqueue($Ret.ValueTree);
		$MainQue.Enqueue($RawRoot.$KeyRoot)

		if ($RawRoot -is [hashtable])
		{	
			m~ConfValueTreeHT~Create $MainQue
		}
		else
		{	
			m~ConfValueTree~Create $MainQue
		}

		$Ret.FilePath = $FSPath;
		$Ret; #<---
		
		if (-not $KeyBasePath.Length -or -not ([Collections.IDictionary]$Ret.ValueTree).Contains($KeyBasePath))
		{
			if ([String]::IsNullOrEmpty($BasePathDef))
			{
				break
			}
			else
			{
				[string]$BasePath = $BasePathDef;
				$BasePathDef = [String]::Empty;
			}
		}
		else 
		{
			[string]$BasePath = $Ret.ValueTree[$KeyBasePath].Is
		}

		$FSPath, $RawRoot = m~ConfFile~Load $BasePath $FSPath $iTimeOut;				
	}
}
catch 
{
	throw
}}
