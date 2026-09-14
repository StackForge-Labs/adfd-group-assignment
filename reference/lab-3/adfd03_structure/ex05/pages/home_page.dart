import 'package:flutter/material.dart';

import '../models/start_card_model.dart';
import '../widgets/start_card.dart';

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
        title: const Text('ADFD 5/8: Structure'),
        centerTitle: true,
      ),

      drawer: const CustomDrawer(),

      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(11),
        children: [for (final model in cards) StartCard(model: model)],
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

Quan hệ:
StartCardModel
      ↓
   StartCard
      ↓
     Card
*/
