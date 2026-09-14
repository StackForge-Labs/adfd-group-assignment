import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//* 01. App *

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: EmployeePage());
  }
}

//* 02. Employee Page *

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => EmployeePageState();
}

//* 03. Employee Page State *

class EmployeePageState extends State<EmployeePage> {
  //* Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  //State
  String selectedGender = 'Male';
  int? editingId;

  List<Map<String, Object?>> employees = [];

  @override
  void initState() {
    super.initState();
    selectEmployees();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  //* 04. Open / Create Database *

  Future<Database> openEmployeeDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, 'adfd.db');

    return openDatabase(
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
  }

  //* 05. SELECT *

  Future<void> selectEmployees() async {
    final db = await openEmployeeDatabase();

    final data = await db.rawQuery('select * from Employee');

    await db.close();

    setState(() {
      employees = data;
    });
  }

  //* 06. INSERT / UPDATE / DELETE *

  Future<void> saveEmployee() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
      return;
    }

    final db = await openEmployeeDatabase();

    if (editingId == null) {
      await db.insert('Employee', {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'gender': selectedGender,
      });

      debugPrint('Employee inserted');
    } else {
      await db.update(
        'Employee',
        {
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'gender': selectedGender,
        },
        where: 'id = ?',
        whereArgs: [editingId],
      );

      debugPrint('Employee updated');
    }

    await db.close();

    nameController.clear();
    emailController.clear();

    setState(() {
      selectedGender = 'Male';
      editingId = null;
    });

    await selectEmployees();
  }

  Future<void> deleteEmployee(int id) async {
    final db = await openEmployeeDatabase();

    await db.delete('Employee', where: 'id = ?', whereArgs: [id]);

    await db.close();

    debugPrint('Employee deleted');

    await selectEmployees();
  }

  //* 07. Edit / Cancel *

  void editEmployee(Map<String, Object?> employee) {
    nameController.text = employee['name'].toString();
    emailController.text = employee['email'].toString();
    selectedGender = employee['gender'].toString();
    editingId = employee['id'] as int;

    setState(() {});
  }

  void cancelEdit() {
    nameController.clear();
    emailController.clear();

    setState(() {
      selectedGender = 'Male';
      editingId = null;
    });
  }

  //* 08. UI *

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADFD 7/7: Complete CRUD')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Gender:'),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedGender,
                      items: [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: saveEmployee,
                      child: Text(editingId == null ? 'Create' : 'Update'),
                    ),
                    SizedBox(width: 10),
                    if (editingId != null)
                      ElevatedButton(
                        onPressed: cancelEdit,
                        child: Text('Cancel'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: employees.isEmpty
                ? Center(child: Text('No data'))
                : ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final employee = employees[index];

                      return ListTile(
                        title: Text(employee['name'].toString()),
                        subtitle: Text(
                          '${employee['email']} - ${employee['gender']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                editEmployee(employee);
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteEmployee(employee['id'] as int);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/*
FLOW

	EmployeePage
		|
		V
	EmployeePageState
		|
		+----------------------+
		|                      |
		V                      V
	Controllers             State
		|                      |
		|                      V
		|                  employees
		|                      |
		+----------+-----------+
		           |
		           V
		openEmployeeDatabase()
		           |
		           V
		        SQLite
		           |
		           V
		     Employee
		           |
		           +-------------------+
		           |                   |
		           V                   V
		     selectEmployees()    saveEmployee()
		           |                   |
		           V                   +--------+
		     employees List            |        |
		                               V        V
	                              INSERT    UPDATE
		                               |
		                               V
		                         Employee
		                               |
		                               V
		                         selectEmployees()
		                               |
		                               V
		                         setState()
		                               |
		                               V
		                              UI
		                               |
		              +----------------+----------------+
		              |                                 |
		              V                                 V
		          Edit Employee                    Delete Employee
		              |                                 |
		              V                                 V
		    editEmployee(employee)              deleteEmployee(id)
		              |                                 |
		              V                                 V
		          setState()                      db.delete()
		              |                                 |
		              +---------------+-----------------+
		                              |
		                              V
		                       selectEmployees()
		                              |
		                              V
		                             UI
*/
