// -----------------------------------------------------------------------
// <copyright file="ParseByTemplate.cs" company="">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace LRCrawler.PipeLine
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using NCrawler.Interfaces;
using NCrawler;
    using System.Xml;
    using LRCrawler.Template;
    using LRCrawler.Persistence;
    using System.Text.RegularExpressions;
using NCrawler.HtmlProcessor;
    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class ParseByTemplate : IPipelineStep
    {
        public void Process(Crawler crawler, PropertyBag propertyBag)
        {
            ITemplate template = SelectTemplate(propertyBag);
            if(template!=null)
            {
             XmlDocument resut=   template.Parse(propertyBag["HtmlDoc"].Value as HtmlAgilityPack.HtmlDocument);
                MongoDBSaver saver = new MongoDBSaver();
                saver.Save(propertyBag, resut);
            }
        }

        private ITemplate mytemplate;
        protected virtual Template.ITemplate SelectTemplate(PropertyBag propertyBag)
        {

            if (Regex.IsMatch(propertyBag.ResponseUri.AbsoluteUri, "http://archive.cnblogs.com/a/.*"))
            {
                if (mytemplate == null)
                {
                    XmlDocument doc = new XmlDocument();
                    doc.Load("cnblogs-post-lightweight.xslt");
                    mytemplate = new XSLTTemplate(doc);
                }
                return mytemplate;
            }else
            {
                return null;
            }
        }
    }
}
