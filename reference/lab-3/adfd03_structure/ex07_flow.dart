import 'package:flutter/material.dart';

import './ex07/pages/home_page.dart';

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
	Ex07 │ Shared
	│
	├── 01. App
	├── 02. Page
	│      └── HomePage
	├── 03. Widget
	│      └── StartCard
	├── 04. Model
	│      └── StartCardModel
	├── 05. Feature
	│      ├── Attendance
	│      ├── Payroll
	│      ├── Team
	│      └── Game
	│
	└── 06. Shared
		└── SharedWidget
				↓
			HomePage sử dụng

	Ex07:
		SharedWidget được giới thiệu
		và sử dụng ở HomePage.

	Các Feature Page sử dụng SharedWidget
	→ hẹn lại Version sau (Ex08):
		├── AttendancePage
		├── PayrollPage
		├── TeamPage
		└── GamePage
*/
