import 'package:flutter/material.dart';

import './ex04/pages/home_page.dart';

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
	  
	Ex04 │ Tách Page và Widget thành file riêng
	│
	├── 01. App
	│
	├── 02. Page
	│   └── HomePage
	│
	└── 03. Widget
		└── StartCard

	Structure:
	  ex04/
		├── pages/
		│   └── home_page.dart
		└── widgets/
			└── start_card.dart

	ex04_flow.dart
      │
      └── import   →  ex04/pages/home_page.dart
                            │
                            └── import → ex04/widgets/start_card.dart
	Flow:
		main.dart
			↓
		ex04_flow.dart
			↓
		pages/home_page.dart
			↓
		widgets/start_card.dart
*/
