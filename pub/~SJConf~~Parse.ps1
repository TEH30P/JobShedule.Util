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
    $Ret = $null;

    if (-not ([Collections.IDictionary]$ioConf).Contains($iName))
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
        return m~ConfValue~Parse $ioConf[$iName] $iType
    }
    else
    {
        $ioConf[$iName]['Is'] = m~ConfValue~Parse $ioConf[$iName] $iType
    }
}
catch
{   
    throw
}}
#--------------------------------#
# Parse single configuration list value.
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
    $Ret = $null;

    if (-not ([Collections.IDictionary]$ioConf).Contains($iName))
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
        foreach ($ConfIt in $ioConf[$iName])
        {
            m~ConfValue~Parse $ConfIt $iType
        }
    }
    else
    {  
        [Collections.IDictionary[]]$Arr = $ioConf[$iName];

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