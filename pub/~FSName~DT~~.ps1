# DateTime <-> FileSystem name.

#--------------------------------#
function ~FSName~DT~Parse
(	[String]$iValue, [String]$iScale = '', [Int32]$iPrec = 0)
{
	[String[]]$PatternArr = m~FSName~DTScalePrec~Parse $iScale $iPrec;
	return [DateTime]::ParseExact($iValue, ($Pattern -join '-'), [cultureinfo]::InvariantCulture);
}
#--------------------------------#
function ~FSName~DT~NParse
(	[String]$iValue, [String]$iScale = '', [Int32]$iPrec = 0)
{
	[String[]]$PatternArr = m~FSName~DTScalePrec~Parse $iScale $iPrec;

	if (($PatternArr | % {'_' * ($_.Length)}) -join '-' -cne $iValue -and ($PatternArr | % {'~' * ($_.Length)}) -join '-' -cne $iValue)
	{
		return [DateTime]::ParseExact($iValue, ($PatternArr -join '-'), [cultureinfo]::InvariantCulture)
	}
}
#--------------------------------#
function ~FSName~DT~Convert
(	[Parameter(Mandatory=1)][DateTime]$iValue, [String]$iScale = '', [Int32]$iPrec = 0)
{	
	[String[]]$PatternArr = m~FSName~DTScalePrec~Parse $iScale $iPrec;
	return $iValue.ToString(($PatternArr -join '-'));
}
#--------------------------------#
function ~FSName~DT~NConvert
(	[Nullable[DateTime]]$iValue, [String]$iScale = '', [Int32]$iPrec = 0, [switch]$fNullHigh)
{
	[String[]]$PatternArr = m~FSName~DTScalePrec~Parse $iScale $iPrec;

	if ($null -eq $iValue)
	{	
		if ($fNullHigh)
		{
			return ($PatternArr | % {'~' * ($_.Length)}) -join '-'
		}
		else
		{
			return ($PatternArr | % {'_' * ($_.Length)}) -join '-'
		}
	}
	else
	{
		return $iValue.ToString(($PatternArr -join '-'))
	}
}