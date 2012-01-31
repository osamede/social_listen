// -----------------------------------------------------------------------
// <copyright file="MongoDBSaver.cs" company="">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace LRCrawler.Persistence
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using NCrawler;
    using MongoDB.Driver;
using System.Xml;
    using MongoDB.Bson;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class MongoDBSaver
    {
        private MongoServer server;
        private MongoDatabase db;
        public MongoDBSaver()
        {
            string connectionString = "mongodb://localhost";
            this.server = MongoServer.Create(connectionString);
           this.db = server.GetDatabase("News");
        }


        public void Save(PropertyBag propertyBag,XmlDocument data)
        {
           MongoCollection<BsonDocument> collection= this.db.GetCollection(data.DocumentElement.Name);
            BsonDocument doc = new BsonDocument();
            foreach(XmlElement e in data.DocumentElement.ChildNodes)
            {
                doc.Add(e.Name, new BsonString(e.InnerXml));
            }
            doc.Add("Url",  new BsonString(propertyBag.OriginalUrl));
            if (propertyBag.Referrer.Uri != null)
            {
                doc.Add("Referrer", new BsonString(propertyBag.Referrer.Uri.AbsoluteUri));
            }
            Console.WriteLine(propertyBag.Title);
            collection.Insert(doc);
        }
    }
}
