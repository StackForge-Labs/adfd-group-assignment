import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/contact_model.dart';

/// Service giao tiếp với REST API của Contact.
class ApiService {
  Future<http.Response> getContacts() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8082/api/contacts'),
    );

    return response;
  }

  // UPDATE: Bổ sung Create Contact thông qua HTTP POST.
  Future<http.Response> createContact(ContactModel contact) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8082/api/contacts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contact.toJson()),
    );

    return response;
  }
}

/*
FLOW

	ApiService
	    ↓
	┌─────────────────────────┐
	│                         │
	getContacts()       createContact()
	    ↓                     ↓
	   GET                   POST
	    ↓                     ↓
	/api/contacts        /api/contacts
	    ↓                     ↓
	 REST API              REST API
	└─────────────────────────┘
*/
