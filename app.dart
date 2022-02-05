import 'package:flutter/material.dart';
import 'package:journal/screens/journal_entries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/new_journal_entry.dart';
import 'screens/settings_drawer.dart';


class App extends StatefulWidget {
  final SharedPreferences preferences;
  final bool screen;
   const App({Key? key, required this.preferences, required this.screen}) : super(key: key);

  @override
  _AppState createState() => _AppState();
  static _AppState? of(BuildContext context) =>
    context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.system;
  late String? theme;
  void initState() {
    super.initState();
    theme = "Light";
    initThemeMode();
  }

  bool db = false;

  initThemeMode() {
    setState(() {
      theme = widget.preferences.getString('mode') ?? 'false';
    });
  }

  var screen;
  
  @override
  Widget build(BuildContext context) {
    if(widget.screen == true ) {
      screen = JournalEntries();
    } else {
      screen = HomeScreen();
    }
    return MaterialApp(
        title: 'Journal',
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        themeMode: selectTheme(theme),
        home: screen
    );
  }

 ThemeMode selectTheme(String? mode) {
    if (theme == "true") {
      return ThemeMode.dark;
    } else {
      return _themeMode;
    }
  }

void changeTheme(ThemeMode themeData) {
  setState(() {
    _themeMode = themeData;
  });
}

}

class HomeScreen extends StatelessWidget {
  const HomeScreen({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Settings(),
      appBar: AppBar(
        title: Text("Welcome"),
        centerTitle: true,
      actions: [Padding(
        padding: EdgeInsets.only(right:10),
        child: Builder(builder: (context) => IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        )),  
      )
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Image.asset('assets/images/journal.png'),
              width: 100,
              height: 100),
            Text('Journal',
              style: TextStyle(
                fontFamily: 'Work Sans',
                color: Colors.black, 
                fontSize: 20)
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New Jounral Entry',
        child: Icon(Icons.add),
        onPressed:() {Navigator.push(context,
          MaterialPageRoute(builder: (context) => JournalEntryForm()),
        );}, 
      )
    );
  }
}


