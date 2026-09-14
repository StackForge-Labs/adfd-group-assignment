import 'package:flutter/material.dart';

//* 01. App *
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

//* 02. Home Page *
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ADFD 1/8: Structure')),
      body: Center(child: Text('Home Page')),
    );
  }
}

/*
	  Ex01
		│
		├── 01. App
		└── 02. Home Page
*/
