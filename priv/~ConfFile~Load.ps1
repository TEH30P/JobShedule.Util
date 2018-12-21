# Load and pre-parse config file.
function m~ConfFile~Load
(	[String]$iPath
,	[String]$iChildPath
,	[TimeSpan]$iTimeOut = '0.00:00:30'
)
{	
	if ([string]::IsNullOrEmpty($iChildPath) -or (Split-Path $iPath -IsAbsolute))
	{
		[string]$FSPath = Convert-Path $iPath
	}
	else 
	{	
		[string]$FSPath = Split-Path $iChildPath -Parent | Join-Path -ChildPath $iPath | Convert-Path
	}

	for([Int32]$Atrtempts = 0; $Atrtempts -lt [Int32]$iTimeOut.TotalSeconds*2; $Atrtempts++)
	{	try 
		{	
			switch -Exact ([IO.Path]::GetExtension($FSPath))
			{	
				'.xml'
				{
					([xml]$RawRoot = New-Object xml).Load($FSPath);
					[String]$Mode = 'xml';
				}
				'.json'
				{
					[PSCustomObject]$RawRoot = [IO.File]::ReadAllText($FSPath, [Text.Encoding]::UTF8) | ConvertFrom-Json;
					[String]$Mode = 'json';
				}
				<#!!!REM: not supportd yet
				'.psd1'
				{	[PSCustomObject]$RawRoot = [PSCustomObject]::new();
					Import-LocalizedData -BindingVariable RawRoot -BaseDirectory ([IO.Path]::GetDirectoryName($FSPath)) -FileName ([IO.Path]::GetFileName($FSPath));
					[PSCustomObject]$RawRoot = [PSCustomObject]$RawRoot[$iKeyRoot];
					[String]$Mode = 'psd';
				}
				#>
				default
				{	
					throw [Exception]::new('Confg file extension not supported.')
				}
			}

			return $FSPath, $RawRoot;
		}
		catch [IO.IOException]
		{
			if ([IO.File]::Exists($iFileName))
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