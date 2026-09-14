import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/contact_model.dart';
import '../services/api_service.dart';

/// Lớp quản lý State và logic gọi API của Contact.
class ContactProvider extends ChangeNotifier {
  // ApiService chịu trách nhiệm giao tiếp với REST API.
  final ApiService apiService = ApiService();

  // Danh sách Contact được Provider quản lý.
  List<ContactModel> contacts = [];

  // Trạng thái loading khi đang gọi API.
  bool loading = true;

  // Tải danh sách Contact từ REST API.
  Future<void> loadContacts() async {
    // Gọi API và nhận HTTP Response.
    final response = await apiService.getContacts();

    // Chỉ xử lý dữ liệu khi API trả về HTTP 200 OK.
    if (response.statusCode == 200) {
      // Response body là JSON String → chuyển thành List.
      final List<dynamic> data = jsonDecode(response.body);

      // Chuyển từng JSON object thành ContactModel.
      final List<ContactModel> result = data
          .map((json) => ContactModel.fromJson(json))
          .toList();

      // Provider nhận State mới và thông báo cho UI rebuild.
      contacts = result;
      loading = false;
      notifyListeners();
    }
  }

  // UPDATE: Bổ sung Create Contact thông qua ApiService.
  Future<void> addContact(ContactModel contact) async {
    final response = await apiService.createContact(contact);

    // Chỉ tải lại danh sách khi Create thành công.
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
