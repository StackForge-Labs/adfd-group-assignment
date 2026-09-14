import 'package:flutter/material.dart';

import 'ex01/pages/contact_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 1/4: HTTP GET')),
        body: const ContactList(),
      ),
    );
  }
}

/*
FLOW

	MyApp
	    ↓
	ContactList
	    ↓
	ApiService
	    ↓
	HTTP GET
	    ↓
	REST API
	    ↓
	Contact List
*/
