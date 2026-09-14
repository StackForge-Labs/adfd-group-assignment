import 'package:flutter/material.dart';

import './ex02/pages/contact_list.dart';

///1. Widget gốc của Flow 2.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 2/4: JSON ↔ Model')),
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
	ContactModel
	    ↓
	[JSON]
	    ↓
	JsonPreview
	    ↓
	ContactModel.toJson()
	    ↓
	JSON String
*/
