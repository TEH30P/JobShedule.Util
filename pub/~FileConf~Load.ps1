# Load and parse xml or json config file.
function ~SJob~FileConf~Load
{	param
	(	[parameter(Mandatory=1, Position=0)]
		[ValidateScript({Test-Path ($_)})]
			[String]$iPath
	,	[parameter(Mandatory=1, Position=1)]
			[String]$iKeyRoot
	,	[parameter(Mandatory=0)]
			[TimeSpan]$iTimeOut = '0.00:00:30'
	);
try 
{
	[string]$FSPath = Convert-Path $iPath;

	for([Int32]$Atrtempts = 0; $Atrtempts -lt [Int32]$iTimeOut.TotalSeconds*2; $Atrtempts++)
	{	try 
		{	
			switch -Exact ([IO.Path]::GetExtension($FSPath))
			{	
				'.xml'
				{
					([xml]$RawRoot = [xml]::new()).Load($FSPath);
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
	
	[PSCustomObject]$Ret = [PSCustomObject]::new();
	[System.Collections.Queue]$MainCll = @();

	$MainCll.Enqueue($Ret);
	$MainCll.Enqueue($RawRoot.$iKeyRoot);

	while ($MainCll.Count)
	{	[PSCustomObject]$Val = $MainCll.Dequeue();
		[object]$RawVal = $MainCll.Dequeue();

		foreach ($PropIt in $RawVal | Get-Member -MemberType Properties -Name 'O?-*', 'S?-*', 'V-Is')
		{
			switch -Exact -Casesensitive ($PropIt.Name.Substring(0, 2))
			{
				'V-' # V-Is
				{
					if ($null -eq $Val.Is)
					{
						throw New-Object FormatException("Invalid config format. File: '$iPath'")
					}
					
					$Val.Is = $RawVal.'V-Is';
				}
				'OV'
				{	
					[Object]$RawSubVal = $RawVal."$($PropIt.Name)";
					[object]$SubVal = [PSCustomObject]::new();

					if ($RawSubVal | Get-Member -MemberType Properties -Name 'O?-*', 'S?-*')
					{
						$MainCll.Enqueue($SubVal);
						$MainCll.Enqueue($RawSubVal);
						$Val | Add-Member -MemberType NoteProperty -Name ('V' +  $PropIt.Name.Substring(3)) -Value $SubVal;
					}
				}
				'OL'
				{
					[Object[]]$RawValArr = $RawVal."$($PropIt.Name)";
					[PSCustomObject[]]$SubValArr = @();
					[Object]$RawSubVal = $null;
					
					foreach ($RawSubVal in $RawValArr)
					{	
						if ($RawSubVal | Get-Member -MemberType Properties -Name 'O?-*', 'S?-*')
						{
							$SubValArr += ([object]$SubVal = [PSCustomObject]::new());
							$MainCll.Enqueue($SubVal);
							$MainCll.Enqueue($RawSubVal);
						}
					}

					if ($SubValArr.Count)
					{
						$Val | Add-Member -MemberType NoteProperty -Name ('L' +  $PropIt.Name.Substring(3)) -Value $SubValArr
					}
				}
				'SV'
				{
					[Object]$RawSubVal = $RawVal."$($PropIt.Name)";
					[object]$SubVal = $null;

					if ($RawSubVal | Get-Member -MemberType Properties -Name 'S?-*')
					{
						[object]$SubVal = [PSCustomObject]@{'Is'=[String]::Empty};
						$MainCll.Enqueue($SubVal);
						$MainCll.Enqueue($RawSubVal);
					}
					elseif ($RawSubVal | Get-Member -MemberType Properties -Name 'V-Is')
					{	
						$SubVal = [PSCustomObject]@{'Is'=[String]$RawSubVal.'V-Is'}
					}
					elseif (-not [String]::IsNullOrEmpty($RawSubVal))
					{
						$SubVal = [PSCustomObject]@{'Is'=[String]$RawSubVal}
					}

					if ($null -ne $SubVal)
					{
						$Val | Add-Member -MemberType NoteProperty -Name ('V' +  $PropIt.Name.Substring(3)) -Value $SubVal
					}
				}
				'SL'
				{	
					[Object[]]$RawValArr = $RawVal."$($PropIt.Name)";
					[PSCustomObject[]]$SubValArr = @();
					[Object]$RawSubVal = $null;

					foreach ($RawSubVal in $RawValArr)
					{	
						if ($RawSubVal | Get-Member -MemberType Properties -Name 'S?-*')
						{
							$SubValArr += ([object]$SubVal = [PSCustomObject]@{'Is'=[String]::Empty});
							$MainCll.Enqueue($SubVal);
							$MainCll.Enqueue($RawSubVal);
						}
						elseif ($RawSubVal | Get-Member -MemberType Properties -Name 'V-Is')
						{
							$SubValArr += [PSCustomObject]@{'Is'=[String]$RawSubVal.'V-Is'}
						}
						elseif (-not [String]::IsNullOrEmpty($RawSubVal))
						{
							$SubValArr += [PSCustomObject]@{'Is'=[String]$RawSubVal}
						}
					}

					if ($SubValArr.Count)
					{
						$Val | Add-Member -MemberType NoteProperty -Name ('L' +  $PropIt.Name.Substring(3)) -Value $SubValArr
					}
				}
				default
				{
					throw New-Object FormatException("Invalid config format. File: '$iPath'")
				}
			} 
		}	
	}

	return $Ret;
}
catch 
{
	throw
}}
