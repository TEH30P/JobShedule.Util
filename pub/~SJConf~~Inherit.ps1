New-Alias -Name Merge-SJConfScalar -Value '~SJConf~Scalar~Inherit';
New-Alias -Name Merge-SJConfList   -Value '~SJConf~List~Inherit';

# Scalar data is overwited in derrived conf.
function ~SJConf~Scalar~Inherit
{	param
	(	[parameter(Mandatory=1, Position=0)]
			[Collections.IDictionary]$ioObjParent
	,	[parameter(Mandatory=1, Position=1)]
			[Collections.IDictionary]$iObj
	,	[parameter(Mandatory=1, Position=2)]	
			[String]$iPropN
	)
try
{	if (([Collections.IDictionary]$iObj).Contains($iPropN))
	{
		$ioObjParent[$iPropN] = $iObj[$iPropN]
	}
}
catch
{	throw}}
#--------------------------------#
# Scalar list data is added at end of parent data
function ~SJConf~List~Inherit
{	param
	(	[parameter(Mandatory=1, Position=0)]
			[Collections.IDictionary]$ioObjParent
	,	[parameter(Mandatory=1, Position=1)]
			[Collections.IDictionary]$iObj
	,	[parameter(Mandatory=1, Position=2)]	
			[String]$iPropN
	)
try
{	if (([Collections.IDictionary]$iObj).Contains($iPropN))
	{	if (-not ([Collections.IDictionary]$ioObjParent).Contains($iPropN))
		{	$ioObjParent[$iPropN] = $iObj[$iPropN]}
		else 
		{	[Collections.ArrayList]$Cll = @();
			$ioObjParent[$iPropN] | % {[Void]$Cll.Add($_)};
			$iObj[$iPropN] | % {[Void]$Cll.Add($_)};
			$ioObjParent[$iPropN] = $Cll.ToArray();
		}
	}
}
catch
{	throw}}
