import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ex04/pages/home_page.dart';
import './ex04/providers/contact_provider.dart';

/// Widget gốc của Flow 4.
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
	┌────────────────────────────────┐
	│ Scaffold                       │
	│                                │
	│ AppBar                         │
	│                                │
	│ ContactList                    │
	│   ├── Search                   │
	│   ├── Contact                  │
	│   │    ├── Edit                │
	│   │    └── Delete              │
	│   │                            │
	│   └── ContactProvider          │
	│                                │
	│ FloatingActionButton           │
	│   ↓                            │
	│ ContactForm                    │
	│   └── Create                   │
	└────────────────────────────────┘
*/
