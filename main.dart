import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);
  var screen;
  // await deleteDatabase('journal.sqlite3.db');
  bool db = await databaseFactory.databaseExists('journal.sqlite3.db');
  if(db == true ) {
    screen = true;
  }  else {
    screen = false;
  }
  runApp(App(preferences: await SharedPreferences.getInstance(), screen: screen));
  }
