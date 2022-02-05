import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'journal_entries.dart';
import 'settings_drawer.dart';


class JournalEntryFields {
  late String? title;
  late String? body;
  late String? dateTime;
  late int? rating;
  String toString() {
    return 'Title: $title, Body: $body, Time: $dateTime, Rating: $rating';
  }
}

class JournalEntryForm extends StatefulWidget {

  @override
  _JournalEntryFormState createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  final formKey = GlobalKey<FormState>();
  final journalEntryFields = JournalEntryFields();
  final List months = ["January", "Febuary", "March", "April", "May", "June",
   "July", "August", "September", "October", "November", "December"];
  final List weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", 
   "Saturday", "Sunday"];

  String dbText = "";

  Future<void> loadAsset() async {
    final openText = await rootBundle.loadString(
      'assets/documents/schema_1.sql.txt');
  setState(() {
    dbText = openText;
  });

  }

  

  @override
  Widget build(BuildContext context) {
    loadAsset();
    return Scaffold(
      endDrawer: Settings(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [Text('New Journal Entry')]
        ),
        centerTitle: true,
        actions: [Padding(
          padding: EdgeInsets.only(right:10),
          child: Builder(builder: (context) => IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Scaffold.of(context). openEndDrawer(),
            )
          ),  
        )],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back)
        )
      ),
        body: 
          SingleChildScrollView(
            child:Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    inputBox("Title"),
                    inputBox("Body"),
                    inputBox("Rating"),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [button("Cancel"), button("Save")]
                    )
                  ]
                )
              )
            )
          )
    );
  }

  Widget inputBox(String text) {
    final double padding;
    if (text == "Rating") {
      padding = 0;
    } else {
      padding = 10;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: '$text', 
          border: OutlineInputBorder()
        ),
        onSaved: (value) {
          if (text == "Title") {
            journalEntryFields.title = value;
          }
          if (text == "Rating") {
            journalEntryFields.rating = int.parse(value!);
          } else {
            journalEntryFields.body = value;
          }
          DateTime now = DateTime.now();
          var month = months[now.month - 1];
          var weekday = weekdays[now.weekday - 1];
          String formattedDate = "$weekday $month " + 
          "${now.day.toString().padLeft(2,'0')}, ${now.year.toString()}";
          journalEntryFields.dateTime = formattedDate;
        },
        validator: (value) {
          if(value!.isEmpty) {
            if (text == "Rating"){
              return 'Please fill out a rating';
            }
            if (text == "Body"){
              return 'Please fill out a body';
            } else {
              return "Please fill out a title";
            }
          } 
          if (text == "Rating"){
            if (value == "1" || value == "2" || value == "3" || value == "4") {
              return null;
            } else {
              return "Please enter a number between 1 & 4";
            }
          } else {
            return null;
          }
        },
      )
    );
  }

  Widget button(String text) {
    return Padding(
      padding: EdgeInsets.only(left: padding(context), right: padding(context)),
      child: ElevatedButton(
        onPressed: () async {
          if(text == "Cancel"){Navigator.pop(context);
          } else{
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              // await deleteDatabase('journal.sqlite3.db');
              final Database database = await openDatabase(
                'journal.sqlite3.db', 
                version: 1, 
                onCreate: (Database db, int version) async {
                  await db.execute(dbText);
                }
              );
              await database.transaction((txn) async {
                await txn.rawInsert(
                  'INSERT INTO journal_entries(title, body, rating, date)'+ 
                  ' VALUES(?, ?, ?, ?)',
                  [journalEntryFields.title, 
                  journalEntryFields.body, 
                  journalEntryFields.rating, 
                  journalEntryFields.dateTime]
                );
              });
              await database.close();
              Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => JournalEntries()),
                (route) => false,
              );
            }
            formKey.currentState!.save();
          }
        },
        child: Text("$text",
          style: TextStyle(
            fontFamily: 'Work Sans')
        )
      )
    );
  }

  double padding(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return MediaQuery.of(context).size.width * 0.15;
    } else {
      return MediaQuery.of(context).size.width * 0.08;
    }
  }

}
