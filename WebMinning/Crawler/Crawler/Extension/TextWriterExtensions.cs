// -----------------------------------------------------------------------
// <copyright file="TextWriterExtensions.cs" company="">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace LRCrawler.Extension
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.IO;
    using NCrawler.Utils;
    using NCrawler.Extensions;
    public static class TextWriterExtensions
    {
        #region Class Methods

        public static void WriteLine(this TextWriter writer, ConsoleColor color, string format, params object[] args)
        {
            AspectF.Define.
                NotNull(writer, "writer").
                NotNull(format, "format");

            Console.ForegroundColor = color;
            writer.WriteLine(format, args);
            Console.ResetColor();
        }

        #endregion
    }
}
