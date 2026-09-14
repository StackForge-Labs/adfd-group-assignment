import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ex03/pages/home_page.dart';
import './ex03/providers/contact_provider.dart';

/// Widget gốc của Flow 3.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

/*
FLOW

	MyApp
	    ↓
	ChangeNotifierProvider
	    ↓
	ContactProvider
	    ↓
	HomePage
	    ↓
	┌─────────────────────────────┐
	│ Scaffold                    │
	│                             │
	│ AppBar                      │
	│                             │
	│ ContactList                 │
	│      ↓                      │
	│ ContactProvider             │
	│                             │
	│ FloatingActionButton        │
	│      ↓                      │
	│ ContactForm                 │
	│      ↓                      │
	│ ContactProvider             │
	│      ↓                      │
	│ ApiService                  │
	│      ↓                      │
	│ POST /api/contacts          │
	└─────────────────────────────┘
*/
