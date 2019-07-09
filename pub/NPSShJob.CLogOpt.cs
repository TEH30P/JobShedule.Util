namespace NPSShJob
{	public enum EMsgSevernity
    {   
		Inf, Err, Wrn, Dbg
	,	I = Inf, E = Err, W = Wrn, D = Dbg
	};

	public enum EMsgJobOptFormat
    {  
		 Std, PSParam
	};
    
    public sealed class CLogOpt
	{	
		public System.String DirRootPath;
		public System.String DirPath;
		public System.DateTime LogDate;

		public CLogOpt(System.String iDirRootPath, System.String iDirPath, System.DateTime iLogDate)
		{	DirRootPath = iDirRootPath;
			DirPath = iDirPath;
			LogDate = iLogDate;
		}
	}
}