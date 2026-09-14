import 'package:flutter/material.dart';

import './ex05/pages/home_page.dart';

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
Ex05 │ Structure
│
├── 01. App
├── 02. Page
│      └── HomePage
├── 03. Shared Widget
│      └── StartCard
├── 04. Custom Drawer
│      └── Sidebar / Navigation
└── 05. Model
       └── StartCardModel

Structure:
ex05/
├── pages/
│   └── home_page.dart
├── widgets/
│   └── start_card.dart
└── models/
    └── start_card_model.dart

Khái niệm chính:
- Model tách dữ liệu khỏi Widget
- StartCard nhận dữ liệu thông qua Model
*/
