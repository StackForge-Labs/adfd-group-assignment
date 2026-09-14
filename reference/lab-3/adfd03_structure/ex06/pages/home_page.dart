import 'package:flutter/material.dart';

import '../models/start_card_model.dart';
import '../widgets/start_card.dart';

import '../features/attendance/attendance_page.dart';
import '../features/payroll/payroll_page.dart';
import '../features/team/team_page.dart';
import '../features/game/game_page.dart';

//* 02. Home Page *

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StartCardModel> cards = [
      const StartCardModel(
        title: 'Attendance',
        icon: Icons.check_circle_outline,
      ),
      const StartCardModel(title: 'Payroll', icon: Icons.payments_outlined),
      const StartCardModel(title: 'Team', icon: Icons.people),
      const StartCardModel(title: 'Game', icon: Icons.games),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ADFD 6/8: Structure'),
        centerTitle: true,
      ),

      //* 04. Custom Drawer
      drawer: const CustomDrawer(),

      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(11),
        children: [
          StartCard(
            model: cards[0],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AttendancePage()),
              );
            },
          ),
          StartCard(
            model: cards[1],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PayrollPage()),
              );
            },
          ),
          StartCard(
            model: cards[2],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeamPage()),
              );
            },
          ),
          StartCard(
            model: cards[3],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GamePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

//* 04. Custom Drawer *

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'ADFD 6/8: Structure',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          //* Attendance
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text(
              'Attendance',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AttendancePage()),
              );
            },
          ),

          //* Payroll
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text(
              'Payroll',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PayrollPage()),
              );
            },
          ),

          //* Team
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text(
              'Team',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeamPage()),
              );
            },
          ),

          //* Game
          ListTile(
            leading: const Icon(Icons.games),
            title: const Text(
              'Game',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GamePage()),
              );
            },
          ),

          const Divider(thickness: 2),

          //* Exit
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              'Exit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/*
	Ex06 │ Feature
	│
	├── 01. App
	├── 02. Page
	│      └── HomePage
	├── 03. Widget
	│      └── StartCard
	├── 04. Feature
	│      ├── Attendance
	│      │      ├── AttendancePage
	│      │      └── AttendanceModel
	│      │
	│      ├── Payroll
	│      │      ├── PayrollPage
	│      │      └── PayrollModel
	│      │
	│      ├── Team
	│      │      ├── TeamPage
	│      │      └── TeamModel
	│      │
	│      └── Game
	│             ├── GamePage
	│             └── GameModel
	│
	└── 05. Model
		└── StartCardModel

	Final Structure:
	ex06/
	├── pages/
	│   └── home_page.dart
	├── widgets/
	│   └── start_card.dart
	├── models/
	│   └── start_card_model.dart
	└── features/
		├── attendance/
		│   ├── attendance_page.dart
		│   └── attendance_model.dart
		├── payroll/
		│   ├── payroll_page.dart
		│   └── payroll_model.dart
		├── team/
		│   ├── team_page.dart
		│   └── team_model.dart
		└── game/
			├── game_page.dart
			└── game_model.dart

	Khái niệm chính:
		- Page
		- Widget
		- Model
		- Feature
		- 4 StartCard tương ứng 4 Feature
		- Không import chéo giữa các Ex
*/
