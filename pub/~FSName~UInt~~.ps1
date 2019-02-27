New-Alias -Name ConvertFrom-FSNameUInt  -Value '~FSName~UInt~Parse';
New-Alias -Name ConvertFrom-FSNameUIntN -Value '~FSName~UInt~NParse';
New-Alias -Name ConvertTo-FSNameUInt    -Value '~FSName~UInt~Convert';
New-Alias -Name ConvertTo-FSNameUIntN   -Value '~FSName~UInt~NConvert';


# UInt64 | UInt32 | UInt16 | Byte <-> FileSystem name.

#--------------------------------#
function ~FSName~UInt~Parse
(	[String]$iValue)
{	return [Bigint]::Parse($iValue, 'Integer', [Globalization.CultureInfo]::InvariantCulture)}
#--------------------------------#
function ~FSName~UInt~NParse
(	[String]$iValue)
{	if (-not ($iValue.GetEnumerator() | ? {'_' -ceq $_ -or '~' -ceq $_}))
    {   return [Bigint]::Parse($iValue, 'Integer', [Globalization.CultureInfo]::InvariantCulture)}
}
#--------------------------------#
function ~FSName~UInt~Convert
(	[Bigint]$iValue, [Int32]$iPrec)
{	return $iValue.ToString([System.Globalization.CultureInfo]::InvariantCulture).PadLeft($iPrec, [Char]'0')}
#--------------------------------#
function ~FSName~UInt~NConvert
(	[Nullable[Bigint]]$iValue, [Int32]$iPrec, [switch]$fNullHigh)
{	if ($null -eq $iValue)
	{	if ($fNullHigh)
		{	return '~' * $iPrec}
		else 
		{	return '_' * $iPrec}
	}
	else 
	{	return ([BigInt]$iValue).ToString([System.Globalization.CultureInfo]::InvariantCulture).PadLeft($iPrec, [Char]'0')}
}