import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/contact_model.dart';

///1. Widget hiển thị JSON của một Contact.
class JsonPreview extends StatelessWidget {
  final ContactModel contact;

  const JsonPreview({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    // Chuyển ContactModel thành Map<String, dynamic>.
    final Map<String, dynamic> json = contact.toJson();

    // Chuyển Map thành JSON String để hiển thị trên UI.
    final String jsonString = const JsonEncoder.withIndent('  ').convert(json);

    return AlertDialog(
      title: const Text('JSON Preview'),
      content: SingleChildScrollView(child: SelectableText(jsonString)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/*
FLOW

	ContactModel
	    ↓
	contact.toJson()
	    ↓
	Map<String, dynamic>
	    ↓
	JsonEncoder
	    ↓
	JSON String
	    ↓
	JSON Preview
*/
