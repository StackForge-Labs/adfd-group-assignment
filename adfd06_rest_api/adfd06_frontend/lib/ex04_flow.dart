import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ex04/core/di/injection.dart';
import './ex04/presentation/pages/home_page.dart';
import './ex04/presentation/providers/contact_provider.dart';

/// Widget gốc của Flow 4.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Đăng ký dependency một lần duy nhất, giống ex05_flow.dart của Lab 5.
    if (!injector.isRegistered<ContactProvider>()) {
      setDI();
    }

    return ChangeNotifierProvider(
      // Provider được GetIt lắp ráp sẵn với Repository và Data Source.
      create: (_) => injector<ContactProvider>()..loadContacts(),
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
	setDI()  →  GetIt ghi công thức lắp ráp
	    ↓
	ChangeNotifierProvider
	    ↓
	ContactProvider  ←  IContactRepository  ←  IContactDataSource  ←  ApiClient
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
