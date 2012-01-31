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

    /// <summary>
    /// The program.
    /// </summary>
    internal class Program
    {
        #region Constants and Fields

        /// <summary>
        /// The extensions to skip.
        /// </summary>
        public static IFilter[] ExtensionsToSkip = new[]
            {
                (RegexFilter)
                new Regex(
                    @"(\.jpg|\.css|\.js|\.gif|\.jpeg|\.png|\.ico)", 
                    RegexOptions.Compiled | RegexOptions.CultureInvariant | RegexOptions.IgnoreCase)
            };

        #endregion

        #region Public Methods

        /// <summary>
        /// The run.
        /// </summary>
        public static void Run()
        {
           Console.Out.WriteLine("Simple crawl demo using local database a storage");

            // Setup crawler to crawl http://ncrawler.codeplex.com
            // with 1 thread adhering to robot rules, and maximum depth
            // of 2 with 4 pipeline steps:
            // 	* Step 1 - The Html Processor, parses and extracts links, text and more from html
            // * Step 2 - Processes PDF files, extracting text
            // * Step 3 - Try to determine language based on page, based on text extraction, using google language detection
            // * Step 4 - Dump the information to the console, this is a custom step, see the DumperStep class
            DbServicesModule.Setup(false);
            using (
                var c = new Crawler(
                    new Uri("http://news.sina.com.cn"), 
                    new HtmlDocumentProcessor(), 
                    // Process html
                    new DumperStep(),
                    new ParseByTemplate()
                    )
                    {
                        // Custom step to visualize crawl
                        MaximumThreadCount = 2, 
                        MaximumCrawlDepth = 10, 
                        ExcludeFilter = ExtensionsToSkip, 
                       
                    })
            {
               
                // Begin crawl
                c.Crawl();
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// The main.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        private static void Main(string[] args)
        {
            Run();
        }

        #endregion
    }

    /// <summary>
    /// The dumper step.
    /// </summary>
    internal class DumperStep : IPipelineStep
    {
        #region Public Methods

        /// <summary>
        /// The process.
        /// </summary>
        /// <param name="crawler">
        /// The crawler.
        /// </param>
        /// <param name="propertyBag">
        /// The property bag.
        /// </param>
        public void Process(Crawler crawler, PropertyBag propertyBag)
        {
            var contentCulture = (CultureInfo)propertyBag["LanguageCulture"].Value;
            string cultureDisplayValue = "N/A";
            if (!contentCulture.IsNull())
            {
                cultureDisplayValue = contentCulture.DisplayName;
            }

            lock (this)
            {
               Console.Out.WriteLine(ConsoleColor.Gray, "Url: {0}", propertyBag.Step.Uri);
               Console.Out.WriteLine(ConsoleColor.DarkGreen, "\tContent type: {0}", propertyBag.ContentType);
               Console.Out.WriteLine(
                    ConsoleColor.DarkGreen, 
                    "\tContent length: {0}", 
                    propertyBag.Text.IsNull() ? 0 : propertyBag.Text.Length);
                Console.Out.WriteLine(ConsoleColor.DarkGreen, "\tDepth: {0}", propertyBag.Step.Depth);
               Console.Out.WriteLine(ConsoleColor.DarkGreen, "\tCulture: {0}", cultureDisplayValue);
                Console.Out.WriteLine(
                    ConsoleColor.DarkGreen, "\tThreadId: {0}", Thread.CurrentThread.ManagedThreadId);
                Console.Out.WriteLine(ConsoleColor.DarkGreen, "\tThread Count: {0}", crawler.ThreadsInUse);
               Console.Out.WriteLine();
            }
        }

        #endregion
    }


}