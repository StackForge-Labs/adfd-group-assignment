import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/contact_model.dart';
import '../services/api_service.dart';

class ContactProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  List<ContactModel> contacts = [];

  bool loading = true;

  Future<void> loadContacts() async {

    final response = await apiService.getContacts();
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<ContactModel> result = data
          .map((json) => ContactModel.fromJson(json))
          .toList();

      contacts = result;
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addContact(ContactModel contact) async {
    final response = await apiService.createContact(contact);
    if (response.statusCode == 200 || response.statusCode == 201) {
      await loadContacts();
    }
  }
}

/*
FLOW

	ContactProvider
	    ↓
	┌───────────────┬────────────────┐
	Read            Create
	↓               ↓
	loadContacts()  addContact()
	↓               ↓
	GET             POST
	↓               ↓
	REST API        REST API
	└───────────────┴────────────────┘
	                ↓
	          loadContacts()
	                ↓
	         notifyListeners()
	                ↓
	          ContactList rebuild
*/
