// -----------------------------------------------------------------------
// <copyright file="XSLTTemplate.cs" company="">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace LRCrawler.Template
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
using System.Xml.Xsl;
    using System.Xml;
    using System.IO;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class XSLTTemplate : ITemplate
    {
        private XslTransform transformer = new XslTransform();
        public XSLTTemplate(System.Xml.XPath.IXPathNavigable stylesheet)
        {
            transformer.Load(stylesheet);
        }

        public  System.Xml.XmlDocument Parse(System.Xml.XPath.IXPathNavigable input)
        {
            MemoryStream ms = new MemoryStream();
            XmlTextWriter writer = new XmlTextWriter(ms, Encoding.UTF8);
            transformer.Transform(input,null, writer);
            writer.Flush();
            XmlDocument doc = new XmlDocument();
            string xml = Encoding.UTF8.GetString(ms.GetBuffer()).Trim();
            if(xml.StartsWith(char.ConvertFromUtf32(65279)))
            {
                xml = xml.Substring(1);
            }
            doc.LoadXml(xml);
            writer.Close();
            return doc;

        }

    }
}
