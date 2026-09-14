import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 6/7: Delete')),
        body: Center(
          child: ElevatedButton(
            onPressed: deleteEmployee,
            child: Text('Delete Employee'),
          ),
        ),
      ),
    );
  }
}

Future<void> deleteEmployee() async {
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

  await db.delete('Employee', where: 'id = ?', whereArgs: [1]);

  debugPrint('Employee deleted');

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
	db.delete()
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
	xóa row có id = 1
*/
