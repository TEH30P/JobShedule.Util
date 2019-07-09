# JobShedule.Util
Powershell module that provides helper functions for sheduled job scripts: logging, configuration etc.
Comadlet and function list: 
- `Import-SJConfFile` (`~SJob~FileTxt~Load`) : Read content of txt file. If file is locked it will retry to read it for `-iTimeOut` period of time (default 30s).
- `Convert*-FSName` (`~FSName~Str~*`) : Various text string <-> FileSystem name (uri encode/decode).
  - `ConvertFrom-FSName` (`~FSName~Str~Parse`)
  - `ConvertTo-FSName`   (`~FSName~Str~Convert`)
- `Convert*-FSNameBin` (`~FSName~Bin~*`) : Binary string <-> FileSystem name.
  - `ConvertFrom-FSNameBin`  (`~FSName~Bin~Parse`)
  - `ConvertFrom-FSNameBinN` (`~FSName~Bin~NParse`)
  - `ConvertTo-FSNameBin`    (`~FSName~Bin~Convert`)
  - `ConvertTo-FSNameBinN`   (`~FSName~Bin~NConvert`)
- `Convert*-FSNameDTm` (`~FSName~DT~*`) : DateTime <-> FileSystem name.
  - `ConvertFrom-FSNameDTm`  (`~FSName~DT~Parse`)
  - `ConvertFrom-FSNameDTmN` (`~FSName~DT~NParse`)
  - `ConvertTo-FSNameDTm`    (`~FSName~DT~Convert`)
  - `ConvertTo-FSNameDTmN`   (`~FSName~DT~NConvert`)
- `Convert*-FSNameUInt` (`~FSName~UInt~*`) : UInt64 | UInt32 | UInt16 | Byte <-> FileSystem name.
  - `ConvertFrom-FSNameUInt`  (`~FSName~UInt~Parse`)
  - `ConvertFrom-FSNameUIntN` (`~FSName~UInt~NParse`)
  - `ConvertTo-FSNameUInt`    (`~FSName~UInt~Convert`)
  - `ConvertTo-FSNameUIntN`   (`~FSName~UInt~NConvert`)
- `Import-SJConfFile` (`~SJConf~File~Parse`) : Load and parse xml or json config file. If file is locked it will retry to read it for `-iTimeOut` period of time (default 30s).
- `ConvertFrom-SJConfScalar` (`~SJConf~Scalar~Parse`) : Parse single configuration scalar value.
- `ConvertFrom-SJConfList` (`~SJConf~List~Parse`) : Parse single configuration value as list.
- `New-SJLogMsg` (`~SJLog~Msg~New`) : New log message. Will create message file, if it not exist.
- `New-SJLogCloseMsg` (`~SJLog~MsgClose~New`) : New log close-mark message. Will create message file, if it not exist.
- `New-SJLogExceptionMsg` (`~SJLog~MsgException~New`) : \<try..catch\> block handler. New log message with exception. Will create message file, if it not exist.
- `Set-SJLogDir` (`~SJLog~Dir~Set`) : Setting the folder path for log files.
- `Set-SJLogDir` (`~SJLog~Date~Set`) : Setting the "date-time" part of each log file name.