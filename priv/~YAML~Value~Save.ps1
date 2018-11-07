[Char[]]${m~YAML~CrLfArr} = "`r`n".ToCharArray();
[Char[]]${m~YAML~ChNonPlainArr} = "`r`n:,`"'".ToCharArray();

# Write text as YAML string into current log file and ioSBMain.
function m~YAML~Value~Save
(	[Text.StringBuilder]$ioSBMain
,	[String]$iPrefix
,	[String]$iValue
,	[Int32]$iIndent
,	[Boolean]$iFSBClear = $false
)
{	#!!!DBG: [IO.Stream]$ioStrWr = [IO.File]::OpenWrite('d:\try.txt'); $ioStrWr.Close();
	#!!!DBG: [Char[]]$iChBuffMain = [Array]::CreateInstance([Char], 1kb)

	[Char[]]$ChCrlfArr = ${m~YAML~CrLfArr};
	[Int32]$Indent = $iIndent;
	[Int32]$SBOffset = $ioSBMain.Length;

	#!!!INF: each new entry will start with [newline] this guarantees the correct format of the yaml file, even if the previous event was written with errors
	[Void]$ioSBMain.AppendLine().Append([Char]' ', $Indent).Append($iPrefix);
	
	if ($iValue.Length -eq 0)
	{	m~FileBuff~SB~Save~i $ioSBMain 0 $iFSBClear | Out-Null;
	}
	elseif ($iValue.IndexOfAny(${m~YAML~ChNonPlainArr}) -lt 0)
	{	# Simple singleline value will write in plain style.
		[void]$ioSBMain.Append(' ');

		if ($iValue.StartsWith(' ') -or $iValue.StartsWith('|'))
		{	
			[void]$ioSBMain.Append('|')
		}
		
		#!!!WRN: Possible OutOfMemory exception.
		$SBOffset = m~FileBuff~SB~Save~i $ioSBMain.Append($iValue) $SBOffset $iFSBClear;
	}
	else 
	{	# Multiline value will write in block style.
		$Indent++
		[Int32]$Pos = 0;
		
		[void]$ioSBMain.AppendLine(' |-').Append([char]' ', $Indent);
		
		if ($iValue.StartsWith(' ') -or $iValue.StartsWith('|'))
		{	
			[void]$ioSBMain.Append('|')
		}

		while ($true)
		{
			[Int32]$Pos2 = $iValue.IndexOfAny($ChCrlfArr, $Pos);
			
			if ($Pos2 -lt 0)
			{	#!!!WRN: Possible OutOfMemory exception.
				[void]$ioSBMain.Append($iValue, $Pos, $iValue.Length - $Pos);
				$SBOffset = m~FileBuff~SB~Save~i $ioSBMain $SBOffset $iFSBClear;
				break;
			}

			if ($Pos2 - $Pos)
			{	#!!!WRN: Possible OutOfMemory exception.
				[void]$ioSBMain.Append($iValue, $Pos, $Pos2 - $Pos);
				$SBOffset = m~FileBuff~SB~Save~i $ioSBMain $SBOffset $iFSBClear;
			}
			
			$Pos = $Pos2;

			# Check if it is [crlf]
			if ($iValue.Length -gt $Pos + 2 -and $iValue.Chars($Pos) -ceq $ChCrlfArr[0] -and $iValue.Chars($Pos + 1) -ceq $ChCrlfArr[1])
			{
				[Void]$ioSBMain.Append($iValue, $Pos, 2).Append([Char]' ', $Indent);
				$Pos += 2;
			}
			else
			{
				[Void]$ioSBMain.Append($iValue, $Pos, 1).Append([Char]' ', $Indent);
				$Pos += 1;
			}
		}
	}
}