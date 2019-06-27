# Generate config data tree from raw data queue.
function m~ConfValueTree~Create
(	[System.Collections.Queue]$ioRawQue)
{
	[System.Collections.Queue]$Que = $ioRawQue;

	while ($Que.Count)
	{	
		[Collections.IDictionary]$Val = $Que.Dequeue();
		[object]$RawVal = $Que.Dequeue();

		foreach ($PropIt in $RawVal | Get-Member -MemberType Properties -Name 'O?-*', 'S?-*', 'V-Is')
		{
			switch -Exact -Casesensitive ($PropIt.Name.Substring(0, 2))
			{
				'V-' # V-Is
				{
					if (-not ([Collections.IDictionary]$Val).Contains('Is'))
					{
						throw New-Object FormatException("Invalid config format. File: '$iPath'")
					}
					
					$Val['Is'] = $RawVal.'V-Is';
				}
				'OV'
				{	
					[Object]$RawSubVal = $RawVal."$($PropIt.Name)";
					[Collections.IDictionary]$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();

					if ($RawSubVal | Get-Member -MemberType Properties -Name 'O?-*', 'S?-*')
					{
						$Que.Enqueue($SubVal);
						$Que.Enqueue($RawSubVal);
						$Val['OV' +  $PropIt.Name.Substring(3)] = $SubVal;
					}
				}
				'OL'
				{
					[Object[]]$RawValArr = $RawVal."$($PropIt.Name)";
					[Collections.Generic.List[Collections.IDictionary]]$SubValArr = @();
					[Object]$RawSubVal = $null;
					
					foreach ($RawSubVal in $RawValArr)
					{	
						if ($RawSubVal | Get-Member -MemberType Properties -Name 'O?-*', 'S?-*')
						{
							[Void]$SubValArr.Add(([Collections.IDictionary]$SubVal = [NPSShJob.CConfData]::ValueTreeFactory()));
							$Que.Enqueue($SubVal);
							$Que.Enqueue($RawSubVal);
						}
					}

					if ($SubValArr.Count)
					{
						$Val['OL' +  $PropIt.Name.Substring(3)] = $SubValArr.ToArray();
					}
				}
				'SV'
				{
					[Object]$RawSubVal = $RawVal."$($PropIt.Name)";
					[Collections.IDictionary]$SubVal = $null;

					if ($RawSubVal | Get-Member -MemberType Properties -Name 'S?-*')
					{
						$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();
						$SubVal['Is'] = [String]::Empty;
						$Que.Enqueue($SubVal);
						$Que.Enqueue($RawSubVal);
					}
					elseif ($RawSubVal | Get-Member -MemberType Properties -Name 'V-Is')
					{	
						$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();
						$SubVal['Is'] = [String]$RawSubVal.'V-Is';
					}
					elseif (-not [String]::IsNullOrEmpty($RawSubVal))
					{
						$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();
						$SubVal['Is'] = [String]$RawSubVal;
					}

					if ($null -ne $SubVal)
					{
						$Val['SV' +  $PropIt.Name.Substring(3)] = $SubVal
					}
				}
				'SL'
				{	
					[Object[]]$RawValArr = $RawVal."$($PropIt.Name)";
					[Collections.Generic.List[Collections.IDictionary]]$SubValArr = @();
					[Object]$RawSubVal = $null;

					foreach ($RawSubVal in $RawValArr)
					{	
						[Collections.IDictionary]$SubVal = [NPSShJob.CConfData]::ValueTreeFactory();
						
						if ($RawSubVal | Get-Member -MemberType Properties -Name 'S?-*')
						{
							[Void]$SubValArr.Add($SubVal);
							$SubVal['Is'] = [String]::Empty;
							$Que.Enqueue($SubVal);
							$Que.Enqueue($RawSubVal);
						}
						elseif ($RawSubVal | Get-Member -MemberType Properties -Name 'V-Is')
						{
							$SubVal['Is'] = [String]$RawSubVal.'V-Is';
							[Void]$SubValArr.Add($SubVal)
						}
						elseif (-not [String]::IsNullOrEmpty($RawSubVal))
						{
							$SubVal['Is'] = [String]$RawSubVal;
							[Void]$SubValArr.Add($SubVal);
						}
					}

					if ($SubValArr.Count)
					{
						$Val['SL' +  $PropIt.Name.Substring(3)] = $SubValArr.ToArray();
					}
				}
				default
				{
					throw New-Object FormatException("Invalid config format. File: '$iPath'")
				}
			} 
		}	
	}
}
