import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:journal/screens/view_journal_entry.dart';
import 'new_journal_entry.dart';
import 'settings_drawer.dart';
import '../models/journalData.dart';

class JournalEntries extends StatefulWidget {
  const JournalEntries({ Key? key }) : super(key: key);

  @override
  _JournalEntriesState createState() => _JournalEntriesState();
}

class JournalEntryFields {
  late String? title;
  late String? body;
  late String? dateTime;
  late String? rating;
  String toString() {
    return 'Title: $title, Body: $body, Time: $dateTime, Rating: $rating';
  } 
}

class _JournalEntriesState extends State<JournalEntries> {

  final journalEntryFields = JournalEntryFields();
  var journalEntries;
  final journal = Journal();

  @override
  void initState() {
    super.initState();
    loadJournal();
  }

  Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/documents/schema_1.sql.txt');
  }

  void loadJournal() async {
    final Database database = await openDatabase(
      'journal.sqlite3.db', 
      version: 1, 
      onCreate: (Database db, int version) async {
        await db.execute(loadAsset().toString());
      }
    );
    List<Map> journalRecords = await database.rawQuery(
      'SELECT * FROM journal_entries');
    journalEntries = journalRecords.map ( (record){
      return journal.journalData(
        record['title'],
        record['body'],
        record['rating'],
        record['date']
      );
    }).toList();
    setState(() {
      build(context);
    });
  }

    Widget build(BuildContext context) {
      return Scaffold(
        endDrawer: Settings(),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [Text('Journal Entries')]
          ),
          centerTitle: true,
          actions: [Padding(
              padding: EdgeInsets.only(right:10),
              child: Builder(builder: (context) => IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Scaffold.of(context). openEndDrawer(),
              )),  
            )],
        ),
        body: LayoutBuilder(builder: layoutDecider),
        floatingActionButton: FloatingActionButton(
          tooltip: 'New Jounral Entry',
          child: Icon(Icons.add),
          onPressed:() {Navigator.push(context,
            MaterialPageRoute(builder: (context) => JournalEntryForm()));
            }, 
        )
      );
    }

    Widget layoutDecider(BuildContext context, BoxConstraints constraints) =>
      constraints.maxWidth < 700 ? entries(context) : horizontalView(context);

    entries(BuildContext context) {
      if (journalEntries == null) {
        return Center(child: CircularProgressIndicator());
      }
      return ListView(
        children: [for (int i = 0; i < journalEntries.length; i++)
          ListTile(
            title: Text(journalEntries[i][0]),
            subtitle: Text(journalEntries[i][3]),
            onTap: () {Navigator.push(context,
              MaterialPageRoute(builder: (context) => ViewEntry(
                title: journalEntries[i][0], 
                subtitle: journalEntries[i][1], 
                dateTime: nonWeekdayDate(journalEntries[i][3]),
                rating: journalEntries[i][2].toString()
                )
              ),
            );}
          ),],
      );
    }

    nonWeekdayDate(date) {
      var splitDate = date.split(' ');
      String nonWeekdayDates = splitDate[1] + " " + splitDate[2] + " " + 
        splitDate[3];
      return nonWeekdayDates;
    }

    Widget horizontalView(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Expanded(
          child: entries(context)), 
          Expanded(
            child: Column(
              children: [Padding(
                padding: EdgeInsets.only(
                  top: topPadding(context), 
                  left: leftPadding(context)
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(journalEntries[0][0], 
                    style: TextStyle(fontSize: 30)
                  )
                )
              ), 
                Padding(
                  padding: EdgeInsets.only(
                    left: leftPadding(context),
                    top: topPadding(context)
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(journalEntries[0][1])
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: leftPadding(context),
                    top: topPadding(context)
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Rating: ${journalEntries[0][2]} out of 4")
                  )
                )
              ])
          )
        ]
      );
    }

    double topPadding(BuildContext context) {
      return MediaQuery.of(context).size.height * 0.02;
    }

    double leftPadding(BuildContext context){
      return MediaQuery.of(context).size.width * 0.13;
    }
}

