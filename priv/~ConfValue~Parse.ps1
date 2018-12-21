[Cultureinfo]${~SJConf~Value~FormatProv} = New-Object Cultureinfo(127) | % {$_.DateTimeFormat.ShortDatePattern  = 'yyyy-MM-dd'}; #Invariant Language (Invariant Country)
[hashtable]${~SJConf~Value~NumSuffixDic} = @{'kb' = 1kb; 'mb' = 1mb; 'gb' = 1gb; 'tb' = 1tb; 'pb' = 1pb};

# Parse configuration value $ConfNode['Is'].
function m~ConfValue~Parse 
(	[Collections.IDictionary]$ConfNode
,   [Type]$iType
)
{	
    if ($ConfNode.Is -isnot [String])
    {   
        $Ret = [Convert]::ChangeType($ConfNode['Is'], $iType, ${~SJConf~Value~FormatProv})
    }
    else
    {   
        [String]$Raw = $ConfNode['Is'];

        if ('SByte', 'Byte', 'Int16', 'UInt16', 'Int32', 'UInt32', 'Int64', 'UInt64', 'Single', 'Double', 'Decimal' -ccontains $iType.Name)
        {
            if (($Raw.Length -gt 2) -and ${~SJConf~Value~NumSuffixDic}.Contains($Raw.Substring($Raw.Length - 2)))
            {   
                $Ret = [System.Xml.XmlConvert]::"To$($iType.Name)"($Raw.Remove($Raw.Length - 2));
                $Ret *= ${~SJConf~Value~NumSuffixDic}[$Raw.Substring($Raw.Length - 2)];
                $Ret = [Convert]::ChangeType($Ret, $iType, ${~SJConf~Value~FormatProv});
            }
            else
            {
                $Ret = [System.Xml.XmlConvert]::"To$($iType.Name)"($Raw)
            }
        }
        elseif ('TimeSpan', 'Boolean', 'Char', 'DateTime' -ccontains $iType.Name)
        {
            $Ret = [System.Xml.XmlConvert]::"To$($iType.Name)"($Raw)
        }
        elseif ('String' -eq $iType.Name)
        {
            $Ret = $Raw
        }
        else
        {   
            throw New-Object FormatException("Type [$($iType.FullName)] is not supported.")
        }
	}
	
	return $Ret;
}