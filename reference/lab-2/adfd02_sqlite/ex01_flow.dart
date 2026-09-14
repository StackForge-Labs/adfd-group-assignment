import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

//* 01. App *
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 1/7: Open|Create Database')),
        body: Center(
          child: ElevatedButton(
            onPressed: openDatabaseExample,
            child: const Text('Open Database'),
          ),
        ),
      ),
    );
  }
}

//* 02. openDatabaseExample *
Future<void> openDatabaseExample() async {
  final databasePath = await getDatabasesPath();

  final database = await openDatabase('$databasePath/adfd.db');

  debugPrint('Database opened: ${database.path}');

  await database.close();
}

/* 

	Flow 1 - Open / Create Database 
		Flutter application
			|
			V
		  sqflite
			|
			V
		  SQLite
		 	|
			V
		  adfd.db

*/
