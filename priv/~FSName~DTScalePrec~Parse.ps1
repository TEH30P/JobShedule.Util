[regex]${Script:m~FSName~DT~REScaleParser} = New-Object regex('^(d|d[ymd])?(t|t[hms])?$', 'Compiled, IgnoreCase, Singleline');

function m~FSName~DTScalePrec~Parse
(	[ValidatePattern('^(d|d[ymd])?(t|t[hms])?$')][String]$iScale = '', [Int32]$iPrec = 0)
{
	[System.Text.RegularExpressions.MatchCollection]$REMCll = ${Script:m~FSName~DT~REScaleParser}.Matches($iScale);
	
	if (-not $REMCll.Success)
	{
		throw New-Object ArgumentException('Value is invalid', 'iScale')
	}
	
	[System.Text.RegularExpressions.Capture]$RECDt, [System.Text.RegularExpressions.Capture]$RECTm = $REMCll.Groups[1,2];
	[string[]]$PatternArr = @();

	if ($RECDt.Length -or $RECTm.Length)
	{
		switch -Exact ($RECDt.Value)
		{	
			'd'
			{	
				$PatternArr += 'yyyyMMdd'
			}
			'dy'
			{	
				$PatternArr += 'yyyy'
			}
			'dm'
			{	
				$PatternArr += 'yyyyMM'
			}
			'dd'
			{	
				$PatternArr += 'yyyyMMdd'
			}
			default 
			{
				if ($RECDt.Length)
				{
					throw 'Main logic error!'
				}
			}
		}

		switch -Exact ($RECTm.Value)
		{	
			't'
			{	
				$PatternArr += 'HHmmss'
			}
			'th'
			{	
				$PatternArr += 'HH'
			}
			'tm'
			{	
				$PatternArr += 'HHmm'
			}
			'ts'
			{	
				$PatternArr += 'HHmmss'
			}
			default 
			{	if ($RECTm.Length)
				{
					throw 'Main logic error!'
				}
			}
		}
	}
	else 
	{
		$PatternArr = 'yyyyMMdd', 'HHmmss'
	}

	if ($iPrec)
	{
		$PatternArr += ('f' * $iPrec)
	}
	
	return $PatternArr;
}