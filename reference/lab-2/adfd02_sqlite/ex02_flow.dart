import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 2/7: Create Table')),
        body: Center(
          child: ElevatedButton(
            onPressed: createTable,
            child: Text('Create Table'),
          ),
        ),
      ),
    );
  }
}

Future<void> createTable() async {
  final databasePath = await getDatabasesPath();

  final path = join(databasePath, 'adfd.db');

  final db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        create table Employee(
          id integer primary key autoincrement,
          name text,
          email text,
          gender text
        )
      ''');
    },
  );

  debugPrint('Database opened: $path');

  await db.close();
}

/*
FLOW

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
		|
		V
	create table Employee
		|
		V
	  Employee
*/
