import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import '../app.dart';


class Settings extends StatefulWidget {
  const Settings({ Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [ListTile(
          title: DrawerHeader(
            child: Wrap(
              children: [
                Text("Settings"),
                Padding(
                  padding: EdgeInsets.only(top:20),
                  child: Row(
                    children: [
                      Text("Dark Mode"), 
                      Padding(
                        padding: EdgeInsets.only(left:112), 
                        child: Switch(
                          value: darkMode,
                          onChanged: (value) {
                            setState(() {
                              darkMode = value;
                              if(darkMode == true) {
                                App.of(context)!.changeTheme(ThemeMode.dark);
                              } else {
                                App.of(context)!.changeTheme(ThemeMode.light);
                              }
                              saveLightMode(darkMode);
                            });
                          })
                      )
                    ]
                  )
                )
              ]
            )
          )
        )]
      )
    );
  }

  void saveLightMode(darkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mode', darkMode.toString());
  }
}