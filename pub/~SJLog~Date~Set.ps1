New-Alias -Name Set-SJLogDate -Value '~SJLog~Date~Set' -Force;

# Setting the "date-time" part of each log file name.
function ~SJLog~Date~Set
{   
	param 
	(   [parameter(Mandatory=0)][ValidateNotNull()]
			[DateTime]$iValue = [DateTime]::Now
	)

	${Global:~SJLog~Opt}.LogDate = $iValue;
}