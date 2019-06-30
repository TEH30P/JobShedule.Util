# Generate config data tree from raw data queue.
function m~ConfValueTreeHT~Create
(	[System.Collections.Queue]$ioRawQue)
{
	[System.Collections.Queue]$Que = $ioRawQue;

	while ($Que.Count)
	{	
		[Collections.IDictionary]$Val = $Que.Dequeue();
		[hashtable]$RawDic = $Que.Dequeue();

		foreach ($KVIt in $RawDic.GetEnumerator())
		{	if ('V-Is' -ceq $KVIt.Key)
			{
				if (-not ([Collections.IDictionary]$Val).Contains('Is'))
				{
					throw New-Object FormatException("Invalid config format. File: '$iPath'")
				}
				
				$Val['Is'] = $KVIt.Value;
				continue;
			}

			if ($KVIt.Key -clike 'OV-*')
			{	
				[hashtable]$RawSubVal = $KVIt.Value;
				[Collections.IDictionary]$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();

				if ($RawSubVal.Keys | ? {$_ -like 'O?-*' -or $_ -like 'S?-*'})
				{
					$Que.Enqueue($SubVal);
					$Que.Enqueue($RawSubVal);
					$Val['OV' +  $KVIt.Key.Substring(3)] = $SubVal;
				}

				continue;
			}

			if ($KVIt.Key -clike 'OL-*')
			{
				[hashtable[]]$RawValArr = $KVIt.Value;
				[Collections.Generic.List[Collections.IDictionary]]$SubValArr = @();
				[hashtable]$RawSubVal = $null;
				
				foreach ($RawSubVal in $RawValArr)
				{	
					if ($RawSubVal.Keys | ? {$_ -like 'O?-*' -or $_ -like 'S?-*'})
					{
						[Void]$SubValArr.Add(([Collections.IDictionary]$SubVal = [NPSShJob.CConfData]::ValueTreeFactory()));
						$Que.Enqueue($SubVal);
						$Que.Enqueue($RawSubVal);
					}
				}

				if ($SubValArr.Count)
				{
					$Val['OL' +  $KVIt.Key.Substring(3)] = $SubValArr.ToArray();
				}

				continue;
			}

			if ($KVIt.Key -clike 'SV-*')
			{
				[Collections.IDictionary]$SubVal = $null;

				if ($KVIt.Value -is [hashtable])
				{
					[hashtable]$RawSubVal = $KVIt.Value;
					
					if ($RawSubVal.Keys | ? {$_ -like 'S?-*'})
					{
						$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();
						$SubVal['Is'] = [String]::Empty;
						$Que.Enqueue($SubVal);
						$Que.Enqueue($RawSubVal);
					}
					elseif ($RawSubVal.ContainsKey('V-Is'))
					{	
						$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();
						$SubVal['Is'] = $RawSubVal['V-Is'];
					}
				}
				elseif ($KVIt.Value -is [String])
				{
					if (-not [String]::IsNullOrEmpty($KVIt.Value))
					{
						$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();
						$SubVal['Is'] = [String]$KVIt.Value;
					}
				}
				elseif ($null -ne $KVIt.Value)
				{
					$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();
					$SubVal['Is'] = $KVIt.Value;
				}

				if ($null -ne $SubVal)
				{
					$Val['SV' +  $KVIt.Key.Substring(3)] = $SubVal
				}

				continue;
			}

			if ($KVIt.Key -clike 'SL-*')
			{	
				[Object[]]$RawValArr = $KVIt.Value;
				[Collections.Generic.List[Collections.IDictionary]]$SubValArr = @();
				[Object]$RawSubVal = $null;

				foreach ($RawSubVal in $RawValArr)
				{	
					[Collections.IDictionary]$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();

					if ($RawSubVal -is [hashtable])
					{
						[hashtable]$RawSubVal = $RawSubVal;

						if ($RawSubVal.Keys | ? {$_ -like 'S?-*'})
						{
							[Void]$SubValArr.Add($SubVal);
							$SubVal['Is'] = [String]::Empty;
							$Que.Enqueue($SubVal);
							$Que.Enqueue($RawSubVal);	
						}
						elseif ($RawSubVal.ContainsKey('V-Is'))
						{	
							$SubVal['Is'] = [String]$RawSubVal['V-Is'];
							[Void]$SubValArr.Add($SubVal);
						}
					}
					elseif ($RawSubVal -is [String])
					{
						if (-not [String]::IsNullOrEmpty($RawSubVal))
						{
							$SubVal['Is'] = [String]$RawSubVal;
							[Void]$SubValArr.Add($SubVal)	
						}
					}
					elseif ($null -ne $RawSubVal)
					{
						$SubVal['Is'] = $RawSubVal;
						[Void]$SubValArr.Add($SubVal);
					}
				}

				if ($SubValArr.Count)
				{
					$Val['SL' +  $KVIt.Key.Substring(3)] = $SubValArr.ToArray();
				}

				continue;
			}
			
			throw New-Object FormatException("Invalid config format. File: '$iPath'");
		}	
	}
}
