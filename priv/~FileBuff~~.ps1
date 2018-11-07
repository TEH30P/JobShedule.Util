[IO.Stream]${Script:m~FileBuff~StrWr} = $null; #[IO.Memorystream]::new(4kb);
[Char[]]${Script:m~FileBuff~ChBuff} = [Array]::CreateInstance([Char], 1kb);
[Byte[]]${Script:m~FileBuff~Buff} = [Array]::CreateInstance([Byte], 4kb); #${m~FileBuff~StrWr}.GetBuffer();

#--------------------------------#
function m~FileBuff~SB~Save~i
(	[Text.StringBuilder]$ioSBMain
,	[Int32]$iSBOffset = 0
,	[Boolean]$iFSBClear = $false)
{	
	[Text.StringBuilder]$SBMain = $ioSBMain;
	[Char[]]$ChBuff             = ${m~FileBuff~ChBuff};
	[Byte[]]$Buff               = ${m~FileBuff~Buff};

	[Int32]$PosTot = $iSBOffset;
	[Int32]$LenTot = 0;

	while ($PosTot -ge 0)
	{	if ($SBMain.Length - $PosTot -lt $ChBuff.Count)
		{	
			$LenTot = $SBMain.Length - $PosTot;
			$SBMain.CopyTo($PosTot, $ChBuff, 0, $LenTot);
			$PosTot = -1;
		}
		else 
		{	
			$LenTot = $ChBuff.Count;
			$SBMain.CopyTo($PosTot, $ChBuff, 0, $ChBuff.Count);
			$PosTot += $ChBuff.Count;
		}

		[Int32]$Len = $LenTot;

		while ([Text.Encoding]::UTF8.GetByteCount($ChBuff, 0, $Len) -gt $Buff.Count)
		{	$Len = $Len -shr 1}

		[Int32]$Pos = 0;
		[Int32]$LenB = 0;

		while ($Pos -ge 0)
		{	if ($Pos + $Len -lt $LenTot)
			{	
				$LenB = [Text.Encoding]::UTF8.GetBytes($ChBuff, $Pos, $Len, $Buff, 0)
				$Pos += $Len;
			}
			else 
			{	
				$LenB = [Text.Encoding]::UTF8.GetBytes($ChBuff, $Pos, $LenTot - $Pos, $Buff, 0)
				$Pos = -1;
			}
			
			[void]${m~FileBuff~StrWr}.Write($Buff, 0, $LenB);
		}
	}

	if ($iFSBClear)
	{	[Void]$SBMain.Clear()}

	return $SBMain.Length;
}
#--------------------------------#
function m~FileBuff~File~Open~i
(	[String]$iPath)
{try 
{	if ($null -ne ${m~FileBuff~StrWr})
	{	
		${m~FileBuff~StrWr}.Dispose()
	}

	${Script:m~FileBuff~StrWr} = [IO.File]::Open($iPath, [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::Write);
	[Void]${Script:m~FileBuff~StrWr}.Seek(0, 'End');
}
catch
{	if ($null -ne ${m~FileBuff~StrWr})
	{	
		${m~FileBuff~StrWr}.Dispose()
		${m~FileBuff~StrWr} = $null;
	}

	throw;
}
}
#--------------------------------#
function m~FileBuff~File~Close~i
{	${m~FileBuff~StrWr}.Close();
	${m~FileBuff~StrWr} = $null;
}