New-Alias -Name ConvertFrom-FSNameBin  -Value '~FSName~Bin~Parse' -Force;
New-Alias -Name ConvertFrom-FSNameBinN -Value '~FSName~Bin~NParse' -Force;
New-Alias -Name ConvertTo-FSNameBin    -Value '~FSName~Bin~Convert' -Force;
New-Alias -Name ConvertTo-FSNameBinN   -Value '~FSName~Bin~NConvert' -Force;

# Binary string <-> FileSystem name.

#--------------------------------#
function ~FSName~Bin~Parse
(	[String]$iValue)
{
	return (m~DHex~ToInt $iValue).ToByteArray()
}
#--------------------------------#
function ~FSName~Bin~NParse
(	[String]$iValue)
{	
	if (-not ($iValue.GetEnumerator() | ? {'_' -ceq $_}))
	{	
		return (m~DHex~ToInt $iValue).ToByteArray()
	}
}
#--------------------------------#
function ~FSName~Bin~Convert
(	[Parameter(Mandatory=1)][Byte[]]$iValue
,	[Int32]$iLen = 0)
{	
	return (m~DHex~ToString (New-Object Bigint(,$iValue))).PadLeft($iLen, [char]'0')
}
#--------------------------------#
function ~FSName~Bin~NConvert
(	[Byte[]]$iValue
,	[Int32]$iLen = 0)
{
	if ($null -eq $iValue)
	{	
		return New-Object String([Char]'_', $iLen)
	}
	else 
    {	
		return (m~DHex~ToString (New-Object Bigint(,$iValue))).PadLeft($iLen, [char]'0')
	}
}