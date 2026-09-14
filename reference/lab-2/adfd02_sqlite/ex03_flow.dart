import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 3/7: Insert')),
        body: Center(
          child: ElevatedButton(
            onPressed: insertEmployee,
            child: Text('Insert Employee'),
          ),
        ),
      ),
    );
  }
}

Future<void> insertEmployee() async {
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

  await db.insert('Employee', {
    'name': 'John',
    'email': 'john@example.com',
    'gender': 'Male',
  });

  debugPrint('Employee inserted');

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
	Employee
		|
		V
	db.insert()
		|
		V
	Employee được thêm
*/
