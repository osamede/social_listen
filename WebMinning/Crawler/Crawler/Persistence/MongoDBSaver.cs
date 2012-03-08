// -----------------------------------------------------------------------
// <copyright file="MongoDBSaver.cs" company="">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace LRCrawler.Persistence
{
    using System;
    using System.Xml;

    using MongoDB.Bson;
    using MongoDB.Driver;

    using NCrawler;

    /// <summary>
    ///   TODO: Update summary.
    /// </summary>
    public class MongoDBSaver
    {
        private MongoServer server;

        private MongoDatabase db;

        public MongoDBSaver()
        {
            string connectionString = "mongodb://localhost";
            this.server = MongoServer.Create(connectionString);
            this.db = this.server.GetDatabase("News");
        }

        public void Save(PropertyBag propertyBag, XmlDocument data)
        {
            foreach (XmlElement e in data.DocumentElement.ChildNodes)
            {
                Save(propertyBag, e);
            }
        }

        private void Save(PropertyBag propertyBag, XmlElement data)
        {
            MongoCollection<BsonDocument> collection = this.db.GetCollection(data.Name);
            BsonDocument doc = new BsonDocument();
            foreach (XmlElement e in data.ChildNodes)
            {
                if(!string.IsNullOrEmpty(e.InnerXml))
                {
                    doc.Add(e.Name, new BsonString(e.InnerXml));
                }
            }
            doc.Add("url", new BsonString(propertyBag.ResponseUri.AbsoluteUri));
            if (propertyBag.Referrer.Uri != null)
            {
                doc.Add("referrer", new BsonString(propertyBag.Referrer.Uri.AbsoluteUri));
            }
            Console.WriteLine(doc[0].AsString);
            collection.Insert(doc);
        }
    }
}
