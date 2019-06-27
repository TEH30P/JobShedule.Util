New-Alias -Name ConvertFrom-FSNameUInt  -Value '~FSName~UInt~Parse' -Force;
New-Alias -Name ConvertFrom-FSNameUIntN -Value '~FSName~UInt~NParse' -Force;
New-Alias -Name ConvertTo-FSNameUInt    -Value '~FSName~UInt~Convert' -Force;
New-Alias -Name ConvertTo-FSNameUIntN   -Value '~FSName~UInt~NConvert' -Force;


# UInt64 | UInt32 | UInt16 | Byte <-> FileSystem name.

#--------------------------------#
function ~FSName~UInt~Parse
(	[String]$iValue)
{
	return [Bigint]::Parse($iValue, 'Integer', [Globalization.CultureInfo]::InvariantCulture)
}
#--------------------------------#
function ~FSName~UInt~NParse
(	[String]$iValue)
{	
	if (-not ($iValue.GetEnumerator() | ? {'_' -ceq $_}))
    {
		return [Bigint]::Parse($iValue, 'Integer', [Globalization.CultureInfo]::InvariantCulture)
	}
}
#--------------------------------#
function ~FSName~UInt~Convert
(	[Parameter(Mandatory=1)][Bigint]$iValue
,	[Int32]$iPrec)
{
	return $iValue.ToString([System.Globalization.CultureInfo]::InvariantCulture).PadLeft($iPrec, [Char]'0')
}
#--------------------------------#
function ~FSName~UInt~NConvert
(	[Nullable[Bigint]]$iValue
,	[Int32]$iPrec)
{
	if ($null -eq $iValue)
	{
		return '_' * $iPrec
	}
	else 
	{	
		return ([BigInt]$iValue).ToString([System.Globalization.CultureInfo]::InvariantCulture).PadLeft($iPrec, [Char]'0')
	}
}