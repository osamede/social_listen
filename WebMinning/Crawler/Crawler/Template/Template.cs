// -----------------------------------------------------------------------
// <copyright file="Template.cs" company="">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace LRCrawler.Template
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
using System.Xml;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public interface ITemplate
    {
        XmlDocument Parse(System.Xml.XPath.IXPathNavigable input);
    }
}
