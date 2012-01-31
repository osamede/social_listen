// Type: MongoDB.Bson.BsonDocument
// Assembly: MongoDB.Bson, Version=1.3.1.4349, Culture=neutral, PublicKeyToken=f686731cfb9cc103
// Assembly location: D:\MongoDB\CSharpDriver 1.3.1\MongoDB.Bson.dll

using MongoDB.Bson.IO;
using MongoDB.Bson.Serialization;

using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace MongoDB.Bson
{
    [Serializable]
    public class BsonDocument : BsonValue, IBsonSerializable, IComparable<BsonDocument>, IConvertibleToBsonDocument, IEnumerable<BsonElement>, IEnumerable, IEquatable<BsonDocument>
    {
        #region Constructors and Destructors

        public BsonDocument();

        public BsonDocument(bool allowDuplicateNames);

        public BsonDocument(BsonElement element);

        public BsonDocument(Dictionary<string, object> dictionary);

        public BsonDocument(Dictionary<string, object> dictionary, IEnumerable<string> keys);

        public BsonDocument(IDictionary<string, object> dictionary);

        public BsonDocument(IDictionary<string, object> dictionary, IEnumerable<string> keys);

        public BsonDocument(IDictionary dictionary);

        public BsonDocument(IDictionary dictionary, IEnumerable keys);

        public BsonDocument(IEnumerable<BsonElement> elements);

        public BsonDocument(params BsonElement[] elements);

        public BsonDocument(string name, BsonValue value);

        #endregion

        #region Public Properties

        public bool AllowDuplicateNames { get; set; }

        public int ElementCount { get; }

        public IEnumerable<BsonElement> Elements { get; }

        public IEnumerable<string> Names { get; }

        public IEnumerable<object> RawValues { get; }

        public IEnumerable<BsonValue> Values { get; }

        #endregion

        #region Public Indexers

        public BsonValue this[int index] { get; set; }

        public BsonValue this[string name, BsonValue defaultValue] { get; }

        public BsonValue this[string name] { get; set; }

        #endregion

        #region Public Methods

        public static new BsonDocument Create(object value);

        public static BsonDocument Parse(string json);

        public static BsonDocument ReadFrom(BsonBuffer buffer);

        public static new BsonDocument ReadFrom(BsonReader bsonReader);

        public static BsonDocument ReadFrom(byte[] bytes);

        public static BsonDocument ReadFrom(Stream stream);

        public static BsonDocument ReadFrom(string filename);

        public BsonDocument Add(BsonElement element);

        public BsonDocument Add(Dictionary<string, object> dictionary);

        public BsonDocument Add(Dictionary<string, object> dictionary, IEnumerable<string> keys);

        public BsonDocument Add(IDictionary<string, object> dictionary);

        public BsonDocument Add(IDictionary<string, object> dictionary, IEnumerable<string> keys);

        public BsonDocument Add(IDictionary dictionary);

        public BsonDocument Add(IDictionary dictionary, IEnumerable keys);

        public BsonDocument Add(IEnumerable<BsonElement> elements);

        public BsonDocument Add(params BsonElement[] elements);

        public BsonDocument Add(string name, BsonValue value);

        public BsonDocument Add(string name, BsonValue value, bool condition);

        public void Clear();

        public override BsonValue Clone();

        public int CompareTo(BsonDocument other);

        public override int CompareTo(BsonValue other);

        public bool Contains(string name);

        public bool ContainsValue(BsonValue value);

        public override BsonValue DeepClone();

        public object Deserialize(BsonReader bsonReader, Type nominalType, IBsonSerializationOptions options);

        public bool Equals(BsonDocument rhs);

        public override bool Equals(object obj);

        public bool GetDocumentId(out object id, out Type idNominalType, out IIdGenerator idGenerator);

        public BsonElement GetElement(int index);

        public BsonElement GetElement(string name);

        public IEnumerator<BsonElement> GetEnumerator();

        public override int GetHashCode();

        public BsonValue GetValue(int index);

        public BsonValue GetValue(string name);

        public BsonValue GetValue(string name, BsonValue defaultValue);

        public void InsertAt(int index, BsonElement element);

        public BsonDocument Merge(BsonDocument document);

        public BsonDocument Merge(BsonDocument document, bool overwriteExistingElements);

        public void Remove(string name);

        public void RemoveAt(int index);

        public void RemoveElement(BsonElement element);

        public void Serialize(BsonWriter bsonWriter, Type nominalType, IBsonSerializationOptions options);

        public BsonDocument Set(int index, BsonValue value);

        public BsonDocument Set(string name, BsonValue value);

        public void SetDocumentId(object id);

        public BsonDocument SetElement(int index, BsonElement element);

        public BsonDocument SetElement(BsonElement element);

        public Dictionary<string, object> ToDictionary();

        public Hashtable ToHashtable();

        public override string ToString();

        public bool TryGetElement(string name, out BsonElement value);

        public bool TryGetValue(string name, out BsonValue value);

        public new void WriteTo(BsonWriter bsonWriter);

        public void WriteTo(BsonBuffer buffer);

        public void WriteTo(Stream stream);

        public void WriteTo(string filename);

        #endregion

        #region Explicit Interface Methods

        BsonDocument IConvertibleToBsonDocument.ToBsonDocument();

        IEnumerator IEnumerable.GetEnumerator();

        #endregion

        #region Operators

        public static bool operator ==(BsonDocument lhs, BsonDocument rhs);

        public static bool operator !=(BsonDocument lhs, BsonDocument rhs);

        #endregion
    }
}
