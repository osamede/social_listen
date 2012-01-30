using System;
using System.Diagnostics;
using System.Net;

using NCrawler.Events;
using NCrawler.Services;
using NCrawler.Utils;

namespace NCrawler
{
	public class RequestState<T>
	{
		#region Instance Properties

		public CrawlStep CrawlStep { get; set; }
		public Exception Exception { get; set; }
		public DownloadMethod Method { get; set; }
		public PropertyBag PropertyBag { get; set; }
		public CrawlStep Referrer { get; set; }
		internal Action<RequestState<T>> Complete { private get; set; }
		internal Action<DownloadProgressEventArgs> DownloadProgress { get; set; }
		internal Stopwatch DownloadTimer { get; set; }
		internal HttpWebRequest Request { get; set; }
		internal MemoryStreamWithFileBackingStore ResponseBuffer { get; set; }
		internal int Retry { get; set; }
		internal T State { get; set; }

		#endregion

		#region Instance Methods

		internal void CallComplete(PropertyBag propertyBag, Exception exception)
		{
			Clean();

			PropertyBag = propertyBag;
			Exception = exception;
			Complete(this);
		}

		internal void Clean()
		{
			if (ResponseBuffer != null)
			{
				ResponseBuffer.FinishedWriting();
				ResponseBuffer = null;
			}
		}

		#endregion
	}
}