// --------------------------------------------------------------------------------------------------------------------
// <copyright file="Program.cs" company="">
//   
// </copyright>
// <summary>
//   The program.
// </summary>
// --------------------------------------------------------------------------------------------------------------------

namespace LRCrawler.Console
{
    using System;
    using System.Globalization;
    using System.Text.RegularExpressions;
    using System.Threading;

    using NCrawler.DbServices;
    using NCrawler.HtmlProcessor;
    using NCrawler.Interfaces;
    using NCrawler;
    using NCrawler.Services;
    using NCrawler.Extensions;
    using System.IO;
    using NCrawler.Utils;
    using LRCrawler.Extension;
    using LRCrawler.PipeLine;
    using System.Net;
    using log4net;
    using LRCrawler.Service;
    using Autofac;
    using Autofac.Builder;
    using NCrawler.Events;

    public class Filter:IFilter
    {
      public  bool Match(Uri uri, CrawlStep referrer)
        {
            if (!Regex.IsMatch(uri.AbsoluteUri, @"http://.*\.cnblogs\.com/.*"))
            {
                return true;
            }
          return false;
        }
    }
    /// <summary>
    /// The program.
    /// </summary>
    internal class Program
    {
        #region Constants and Fields


        public static IFilter[] SiteToCrawl = new[]
            {
                (RegexFilter)
                new Regex(
                    @"http://.*\.cnblogs\.com/.*", 
                    RegexOptions.Compiled | RegexOptions.CultureInvariant | RegexOptions.IgnoreCase)
            };
        #endregion

        #region Public Methods

        /// <summary>
        /// The run.
        /// </summary>
        public static void Run()
        {
           ServicePointManager.MaxServicePoints = 999999;
           ServicePointManager.DefaultConnectionLimit = 999999;
           ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls;
           ServicePointManager.CheckCertificateRevocationList = true;
           ServicePointManager.EnableDnsRoundRobin = true;

           IFilter[] ExtensionsToSkip = new IFilter[2];
            ExtensionsToSkip[0] = new Filter();
            ExtensionsToSkip[1] =
                (RegexFilter)
                new Regex(
                    @"(\.jpg|\.css|\.js|\.gif|\.jpeg|\.png|\.ico)",
                    RegexOptions.Compiled | RegexOptions.CultureInvariant | RegexOptions.IgnoreCase);
            DbServicesModule.Setup(true);

            NCrawlerModule.Register(
               builder => builder.Register(
                  c=>new Log4NetLogService()).As<NCrawler.Interfaces.ILog>().InstancePerDependency());

            using (
                var c = new Crawler(
                    new Uri("http://www.cnblogs.com"), 
                    new HtmlDocumentProcessor(), 
                    new ParseByTemplate()
                    )
                    {
                        // Custom step to visualize crawl
                        MaximumThreadCount = 1, 
                        MaximumCrawlDepth = 50, 
                        ExcludeFilter = ExtensionsToSkip, 
                       ConnectionTimeout=new TimeSpan(0,1,0),

                    })
            {
                c.AfterDownload += CrawlerAfterDownload;
                c.PipelineException += CrawlerPipelineException;
                c.DownloadException += CrawlerDownloadException;
                c.Crawl();
            }
        }

        #endregion

        #region Methods
        private static void CrawlerAfterDownload(object sender, AfterDownloadEventArgs e)
        {
                System.Console.Out.WriteLine("{0} in {1}".FormatWith(e.CrawlStep.Uri, e.Response.DownloadTime.TotalSeconds));
        }

        private static void CrawlerDownloadException(object sender, DownloadExceptionEventArgs e)
        {
            if (e.Exception is WebException)
            {
                WebException webException = (WebException)e.Exception;
                System.Console.Out.WriteLine("Error downloading '{0}': {1}; {2} - Continueing crawl", e.CrawlStep.Uri, webException.Status, webException.Source);
            }
            else
            {
                System.Console.Out.WriteLine("Error downloading '{0}': {1} - Continueing crawl", e.CrawlStep.Uri, e.Exception.Message);
            }
        }

        private static void CrawlerPipelineException(object sender, PipelineExceptionEventArgs e)
        {
            System.Console.Out.WriteLine("Error processsing '{0}': {1}", e.PropertyBag.Step.Uri, e.Exception.Message);
        }
        private static void Main(string[] args)
        {
            for (int i = 0; i < 1000; i++)
            {
                Thread thread = new Thread(new ThreadStart(Run));
                thread.Start();
            }
            string cmd = Console.ReadLine();
            while(cmd!="quit")
            {
                cmd = Console.ReadLine();
            }
        }

        #endregion
    }


}