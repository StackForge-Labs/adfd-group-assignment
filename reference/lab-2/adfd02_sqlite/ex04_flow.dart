import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 4/7: Select')),
        body: Center(
          child: ElevatedButton(
            onPressed: selectEmployees,
            child: Text('Select Employees'),
          ),
        ),
      ),
    );
  }
}

Future<void> selectEmployees() async {
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

  final data = await db.rawQuery('select * from Employee');

  debugPrint('Employees: $data');

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
	select * from Employee
		|
		V
	Employee List
		|
		V
	debugPrint()
*/
