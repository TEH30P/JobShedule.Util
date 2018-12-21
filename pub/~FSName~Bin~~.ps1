# Binary string <-> FileSystem name.

#--------------------------------#
function ~FSName~Bin~Parse
(	[String]$iValue)
{	return (m~DHex~ToInt $iValue).ToByteArray()}
#--------------------------------#
function ~FSName~Bin~NParse
(	[String]$iValue)
{	if (-not ($iValue.GetEnumerator() | ? {'_' -ceq $_ -or '~' -ceq $_}))
	{	return (m~DHex~ToInt $iValue).ToByteArray()}
}
#--------------------------------#
function ~FSName~Bin~Convert
(	[Parameter(Mandatory=1)][Byte[]]$iValue)
{	return m~DHex~ToString (New-Object Bigint(,$iValue))}
#--------------------------------#
function ~FSName~Bin~NConvert
(	[Byte[]]$iValue, [Int32]$iLen, [switch]$fNullHigh)
{	if ($null -eq $iValue)
	{	if ($fNullHigh)
		{	return New-Object String([Char]'~', $iLen)}
		else 
		{	return New-Object String([Char]'_', $iLen)}
	}
	else 
    {	return (m~DHex~ToString (New-Object Bigint(,$iValue))).PadLeft($iLen, [char]'0')}
}