import 'package:flutter/material.dart';

import './ex06/pages/home_page.dart';

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
	Ex06 │ Structure
	│
	├── 01. App
	├── 02. Page
	│      └── HomePage
	├── 03. Shared Widget
	│      └── StartCard
	├── 04. Custom Drawer
	│      └── Sidebar / Navigation
	└── 05. Feature
		└── Attendance
				├── AttendancePage
				└── AttendanceModel

	Khái niệm chính:
		- Feature
		- Feature có Page riêng
		- Feature có Model riêng
		- Không import chéo giữa các Ex
*/
