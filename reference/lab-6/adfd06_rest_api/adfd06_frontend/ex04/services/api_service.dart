import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/contact_model.dart';

/// Service giao tiếp với REST API của Contact.
class ApiService {
  // Lấy danh sách Contact.
  Future<http.Response> getContacts() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8082/api/contacts'),
    );

    return response;
  }

  // Tạo Contact mới.
  Future<http.Response> createContact(ContactModel contact) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8082/api/contacts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contact.toJson()),
    );

    return response;
  }

  // UPDATE: Bổ sung Update Contact thông qua HTTP PUT.
  Future<http.Response> updateContact(int id, ContactModel contact) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8082/api/contacts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contact.toJson()),
    );

    return response;
  }

  // UPDATE: Bổ sung Delete Contact thông qua HTTP DELETE.
  Future<http.Response> deleteContact(int id) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8082/api/contacts/$id'),
    );

    return response;
  }

  // UPDATE: Bổ sung Search Contact thông qua HTTP GET.
  Future<http.Response> searchContacts(String keyword) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8082/api/contacts/search?keyword=$keyword'),
    );

    return response;
  }
}

/*
FLOW

	ApiService
	    ↓
	┌─────────────────────────────────────┐
	│                                     │
	getContacts()     createContact()     │
	    ↓                   ↓             │
	   GET                 POST            │
	    ↓                   ↓             │
	/api/contacts       /api/contacts     │
	│                                     │
	├── updateContact()                   │
	│       ↓                             │
	│      PUT                            │
	│       ↓                             │
	│   /api/contacts/{id}                │
	│                                     │
	├── deleteContact()                   │
	│       ↓                             │
	│     DELETE                          │
	│       ↓                             │
	│   /api/contacts/{id}                │
	│                                     │
	└── searchContacts()                  │
	        ↓                            │
	       GET                           │
	        ↓                            │
	/api/contacts/search?keyword=...     │
	└─────────────────────────────────────┘
*/
