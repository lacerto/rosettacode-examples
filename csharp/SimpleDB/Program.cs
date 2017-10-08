using System;
using System.IO;
using System.Xml.Linq;
using System.Collections.Generic;
using Mono.Options;

namespace SimpleDB
{
    class SimpleDB
    {
        public static void Main(string[] args)
        {
            new SimpleDB(args);   
        }

        private SimpleDB(string[] args)
        {
            SimpleXMLDB db = new SimpleXMLDB("database.xml");
            var commands = new CommandSet("SimpleDB") {
                "usage: SimpleDB COMMAND [OPTIONS]",
                "",
                "Example for the task http://rosettacode.org/wiki/Simple_database",
                "",
                "Available commands:",
                new NewDBEntry(db),
                new PrintLatest(),
                new PrintAll()
            };
            commands.Run(args);
            db.Save();
        }
    }

    interface ISimpleDB
    {
        void Add(string title, string artist, string date, string genre);
    }

    class SimpleXMLDB : ISimpleDB
    {
        private XDocument db;
        private string filename;

        public SimpleXMLDB(string filename) {
            this.filename = filename;
            if (File.Exists(filename)) {
                db = XDocument.Load(filename);
            } else {
                db = new XDocument(
                    new XElement("records")
                );
            }
        }

        public void Add(string title, string artist, string date, string genre) {
            db.Element("records").Add(
                new XElement("record", 
                    new XElement("title", title),
                    new XElement("artist", artist),
                    new XElement("date", date),
                    new XElement("genre", genre)
                )
            );    
        }

        public void Save() {
            db.Save(filename);
        }
    }

    class NewDBEntry : Command
    {
        private ISimpleDB db;

        public NewDBEntry(ISimpleDB db) : 
                base("new", "Add a new database entry") {
            this.db = db;
        }

        public override int Invoke(IEnumerable<string> args) {
            db.Add("Sturmfahrt", "Eisbrecher", "2017", "hard");
            Console.WriteLine("Entry added");
            return 0;
        }
    }

    class PrintLatest : Command
    {
        public PrintLatest() :
                base("latest", "Print the latest database entry.") {}

        public override int Invoke(IEnumerable<string> args) {
            Console.WriteLine("Print");
            return 0;
        }
    }
        
    class PrintAll : Command
    {
        public PrintAll() : 
        base("all", "Print all database entries.") {}

        public override int Invoke(IEnumerable<string> args) {
            Console.WriteLine("All");
            return 0;
        }
    }
}
