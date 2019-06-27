New-Alias -Name ConvertFrom-FSName -Value '~FSName~Str~Parse' -Force;
New-Alias -Name ConvertTo-FSName   -Value '~FSName~Str~Convert' -Force;

# Various text string <-> FileSystem name (uri encode/decode)

[String]${m~FSName~Str~Esc} = '?*\/:|><%'
#--------------------------------#
function ~FSName~Str~Convert
(	[String]$iValue)
{
	[String]$Ret = '';

	foreach ($ChIt in $iValue.GetEnumerator())
	{	
		if (${m~FSName~Str~Esc}.Contains($ChIt))
		{
			$Ret += '%{0:X2}' -f [Char]::ConvertToUtf32(${m~FSName~Str~Esc}, ${m~FSName~Str~Esc}.IndexOf($ChIt))
		}
		else 
		{
			$Ret += $ChIt
		}
	}

	return $Ret;
}
#--------------------------------#
function ~FSName~Str~Parse
(	[String]$iValue)
{	
	return [Uri]::UnescapeDataString($iValue)
}
##################################
