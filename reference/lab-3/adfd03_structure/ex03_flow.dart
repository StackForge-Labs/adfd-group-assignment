import 'package:flutter/material.dart';

//* 01. App
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

//* 02. Home Page *

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADFD 3/8: Structure'),
        centerTitle: true,
      ),

      //* 04. Custom Drawer *
      drawer: const CustomDrawer(),

      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(11),
        children: const [
          //* 03. Shared Widget *

          StartCard(title: 'Attendance', icon: Icons.check_circle_outline),
          StartCard(title: 'Payroll', icon: Icons.payments_outlined),
          StartCard(title: 'Team', icon: Icons.people),
          StartCard(title: 'Game', icon: Icons.games),
        ],
      ),
    );
  }
}

//* 03. Shared Widget *

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

//* 04. Custom Drawer *

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
              child: Text(
                'Menu',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text(
              'Attendance',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text(
              'Payroll',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text(
              'Team',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.games),
            title: const Text(
              'Game',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(thickness: 2),

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
	+ Drawer tương tữ sidebar
	+ Ex03 │ Structure
		├── 01. App
		├── 02. Home Page
		├── 03. Shared Widget
		│      └── StartCard
		└── 04. Custom Drawer
			└── Sidebar / Navigation

	+ Code được tổ chức theo vai trò:
		- Page
		- Feature Widget
		- Shared Widget
*/
