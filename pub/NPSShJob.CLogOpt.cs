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

		public CLogOpt(System.String iDirRootPath, System.String iDirPath)
		{	DirRootPath = iDirRootPath;
			DirPath = iDirPath;
		}
	}
}