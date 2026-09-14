import 'package:flutter/material.dart';

//* 01. App *
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

//* 02. Home Page *
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADFD 2/8: Structure'),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(11),
        children: const [
          StartCard(title: 'Attendance', icon: Icons.check_circle_outline),
          StartCard(title: 'Payroll', icon: Icons.payments_outlined),
          StartCard(title: 'Team', icon: Icons.people),
          StartCard(title: 'Game', icon: Icons.games),
        ],
      ),
    );
  }
}

//* 03. Custom Widget *
class StartCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const StartCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/*
	  Ex02
		│
		├── 01. App
		├── 02. Home Page
		└── 03. Custom Widget
				│
				└── được sử dụng lại → Shared Widget
*/
