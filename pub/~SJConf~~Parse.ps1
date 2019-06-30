New-Alias -Name Update-SJConfScalar -Value '~SJConf~Scalar~Parse' -Force;
New-Alias -Name Update-SJConfList   -Value '~SJConf~List~Parse' -Force;

#--------------------------------#
# Parse single configuration scalar value.
function ~SJConf~Scalar~Parse
{	param
	(   [parameter(Mandatory=1, Position=0)][Collections.IDictionary]$ioConf
    ,	[parameter(Mandatory=1, Position=1)][String]$iName
    ,	[parameter(Mandatory=0, Position=2)][Type]$iType
    ,	[parameter(Mandatory=0            )][switch]$fNullable
    ,	[parameter(Mandatory=0            )][switch]$fOut
	);
try 
{   
    if ($iName.StartsWith('SV-'))
	{
		[String]$Name =  $iName.Remove(2, 1)
	}
	elseif ($iName.StartsWith('SV'))
	{
		[String]$Name = $iName
	}
	else
	{
		[String]$Name = 'SV' + $iName
	}

    if (-not ([Collections.IDictionary]$ioConf).Contains($Name))
    {   
        if ($fNullable)
        {
            return #<--
        }
        else 
        {   
            throw New-Object Exception("'$iName' configuration attribute is required.")
        }
    }
        
    if ($fOut)
    {   
        return m~ConfValue~Parse $ioConf[$Name] $iType
    }
    else
    {
        $ioConf[$Name]['Is'] = m~ConfValue~Parse $ioConf[$Name] $iType
    }
}
catch
{   
    throw
}}
#--------------------------------#
# Parse single configuration value as list.
function ~SJConf~List~Parse
{	param
	(   [parameter(Mandatory=1, Position=0)][Collections.IDictionary]$ioConf
    ,	[parameter(Mandatory=1, Position=1)][String]$iName
    ,	[parameter(Mandatory=0, Position=2)][Type]$iType
    ,	[parameter(Mandatory=0            )][switch]$fNullable
    ,	[parameter(Mandatory=0            )][switch]$fOut
	);
try 
{
    if ($iName.StartsWith('SL-'))
	{
		[String]$Name =  $iName.Remove(2, 1)
	}
	elseif ($iName.StartsWith('SL'))
	{
		[String]$Name = $iName
	}
	else
	{
		[String]$Name = 'SL' + $iName
	}
    
    if (-not ([Collections.IDictionary]$ioConf).Contains($Name))
    {   
        if ($fNullable)
        {
            return #<--
        }
        else 
        {
            throw New-Object Exception("'$iName' configuration attribute is required.")
        }
    }
    
    if ($fOut)
    {
        foreach ($ConfIt in $ioConf[$Name])
        {
            m~ConfValue~Parse $ConfIt $iType
        }
    }
    else
    {  
        [Collections.IDictionary[]]$Arr = $ioConf[$Name];

        for ([Int32]$k = 0; $k -lt $Arr.Count; $k++)
        {   
            $Arr[$k]['Is'] = m~ConfValue~Parse $Arr[$k] $iType
        }
    }
}
catch
{   
    throw
}}