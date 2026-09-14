import 'package:flutter/material.dart';

import './ex08/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

/*
	Ex08 │ Structure
	│
	├── 01. App
	├── 02. Page
	│      └── HomePage
	├── 03. Widget
	│      └── StartCard
	├── 04. Custom Drawer
	│      └── Sidebar / Navigation
	├── 05. Model
	│      └── StartCardModel
	├── 06. Feature
	│      ├── Attendance
	│      │      ├── AttendancePage
	│      │      └── AttendanceModel
	│      ├── Payroll
	│      │      ├── PayrollPage
	│      │      └── PayrollModel
	│      ├── Team
	│      │      ├── TeamPage
	│      │      └── TeamModel
	│      └── Game
	│             ├── GamePage
	│             └── GameModel
	└── 07. Shared
		└── SharedWidget

	Final Structure:
	ex08/
	├── pages/
	│   └── home_page.dart
	├── widgets/
	│   └── start_card.dart
	├── models/
	│   └── start_card_model.dart
	├── features/
	│   ├── attendance/
	│   │   ├── attendance_page.dart
	│   │   └── attendance_model.dart
	│   ├── payroll/
	│   │   ├── payroll_page.dart
	│   │   └── payroll_model.dart
	│   ├── team/
	│   │   ├── team_page.dart
	│   │   └── team_model.dart
	│   └── game/
	│       ├── game_page.dart
	│       └── game_model.dart
	└── shared/
		└── shared_widget.dart

	SharedWidget:
		├── HomePage
		├── AttendancePage
		├── PayrollPage
		├── TeamPage
		└── GamePage

	Khái niệm chính:
		- Page
		- Widget
		- Model
		- Feature
		- Shared
		- SharedWidget được dùng chung
		- Không import chéo giữa các Ex
*/
