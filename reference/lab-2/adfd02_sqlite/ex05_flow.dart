import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 5/7: Update')),
        body: Center(
          child: ElevatedButton(
            onPressed: updateEmployee,
            child: Text('Update Employee'),
          ),
        ),
      ),
    );
  }
}

Future<void> updateEmployee() async {
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

  await db.update(
    'Employee',
    {'name': 'Peter', 'email': 'peter@example.com', 'gender': 'Male'},
    where: 'id = ?',
    whereArgs: [1],
  );

  debugPrint('Employee updated');

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
	db.update()
		|
		V
	Employee
		|
		V
	where: id = ?
		|
		V
	whereArgs: [1]
		|
		V
	row có id = 1 được update
*/
