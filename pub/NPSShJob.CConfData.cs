namespace NPSShJob
{	
	public sealed class CConfData
	{	
		public System.String FilePath;
		public System.Collections.IDictionary ValueTree;

		public static System.Collections.IDictionary ValueTreeFactory()
		{	return new System.Collections.Generic.SortedList<string, object>();}
	}
}