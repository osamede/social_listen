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

        protected virtual Template.ITemplate SelectTemplate(PropertyBag propertyBag)
        {
            if (propertyBag.OriginalUrl.StartsWith("http://news.sina.com.cn/c/"))
            {
                XmlDocument doc = new XmlDocument();
                doc.Load("Sina-NewsContent.xslt");
                return new XSLTTemplate(doc);
            }else
            {
                return null;
            }
        }
    }
}
