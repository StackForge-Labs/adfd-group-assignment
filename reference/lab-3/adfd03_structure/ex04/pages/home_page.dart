import 'package:flutter/material.dart';

import '../widgets/start_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADFD 4/8: Structure'),
        centerTitle: true,
      ),

      drawer: const CustomDrawer(),

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

//* Custom Drawer *

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
