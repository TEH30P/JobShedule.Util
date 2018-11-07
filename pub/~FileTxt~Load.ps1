# Read content of txt file.
function  ~SJob~FileTxt~Load
(	[parameter(Mandatory=1, Position=0)]
	[ValidateScript({Test-Path ($_)})]
		[String]$iPath
,	[parameter(Mandatory=0, Position=1)]
		[Text.Encoding]$iEncoding = [Text.Encoding]::UTF8
,	[parameter(Mandatory=0)]
		[TimeSpan]$iTimeOut = '0.00:00:30'
)
{	for([Int32]$Atrtempts = 0; $Atrtempts -lt [Int32]$iTimeOut.TotalSeconds*2; $Atrtempts++)
	{	try 
		{
			[string]$FSPath = Convert-Path $iPath;
			[String]$Content = [IO.File]::ReadAllText($FSPath, $iEncoding);
			return $Content;
		}
		catch [IO.IOException]
		{	if ([IO.File]::Exists($iFileName))
			{	
				Start-Sleep -Milliseconds 500
			}
			else 
			{	
				throw
			}
		}
		catch
		{	
			throw
		}
	}
}