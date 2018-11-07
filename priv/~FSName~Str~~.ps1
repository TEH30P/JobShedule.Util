# Various string <-> FileSystem name

[String]${m~FSName~Str~Esc} = '?*\/:|><%'
#--------------------------------#
function m~FSName~Str~Convert
(	[Text.StringBuilder]$ioSBMain
,	[String]$iValue)
{	
	foreach ($ChIt in $iValue.GetEnumerator())
	{	if (${m~FSName~Str~Esc}.Contains($ChIt))
		{	[Void]$ioSBMain.AppendFormat('%{0:X2}',[Char]::ConvertToUtf32(${m~FSName~Str~Esc}, ${m~FSName~Str~Esc}.IndexOf($ChIt)))}
		else 
		{	[Void]$ioSBMain.Append($ChIt)}
	}
}
#--------------------------------#
function m~FSName~Str~Parse
(	[Text.StringBuilder]$ioSBMain
,	[String]$iValue)
{
	[Void]$ioSBMain.Append([Uri]::UnescapeDataString($iValue))
}
##################################
