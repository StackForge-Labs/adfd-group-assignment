import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String dbName = 'adfd05.db';
  static const int dbVersion = 1;

  Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          create table posts (
            id integer primary key autoincrement,
            title text not null,
            content text not null,
            is_like integer not null default 0
          )
        ''');

        await db.transaction((txn) async {
          await txn.insert('posts', {
            'title': 'Flutter',
            'content': 'Build beautiful user interfaces with Flutter.',
            'is_like': 0,
          });

          await txn.insert('posts', {
            'title': 'Dart',
            'content': 'Write application logic with Dart.',
            'is_like': 0,
          });

          await txn.insert('posts', {
            'title': 'Provider',
            'content': 'Manage application state with Provider.',
            'is_like': 0,
          });
        });
      },
    );
  }
}

/*
FLOW

	DatabaseHelper
		↓
	SQLite
		↓
	adfd05.db
		↓
	posts
		├── id
		├── title
		├── content
		└── is_like

	Initial Data
		├── Flutter
		├── Dart
		└── Provider
*/

/*
	await db.insert('posts', {
		'title': 'Flutter',
		'content': 'Build beautiful user interfaces with Flutter.',
		'is_like': 0,
	});

	await db.insert('posts', {
		'title': 'Dart',
		'content': 'Write application logic with Dart.',
		'is_like': 0,
	});

	await db.insert('posts', {
		'title': 'Provider',
		'content': 'Manage application state with Provider.',
		'is_like': 0,
	});

*/
