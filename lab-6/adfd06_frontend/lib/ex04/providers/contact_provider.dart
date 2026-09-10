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

  // Tạo Contact mới thông qua ApiService.
  Future<void> addContact(ContactModel contact) async {
    final response = await apiService.createContact(contact);

    // Chỉ tải lại danh sách khi Create thành công.
    if (response.statusCode == 200 || response.statusCode == 201) {
      await loadContacts();
    }
  }

  // UPDATE: Bổ sung Update Contact thông qua ApiService.
  Future<void> updateContact(int id, ContactModel contact) async {
    final response = await apiService.updateContact(id, contact);

    // Sau khi Update thành công, tải lại danh sách.
    if (response.statusCode == 200) {
      await loadContacts();
    }
  }

  // UPDATE: Bổ sung Delete Contact thông qua ApiService.
  Future<void> deleteContact(int id) async {
    final response = await apiService.deleteContact(id);

    // Sau khi Delete thành công, tải lại danh sách.
    if (response.statusCode == 200 || response.statusCode == 204) {
      await loadContacts();
    }
  }

  // UPDATE: Bổ sung Search Contact thông qua ApiService.
  Future<void> searchContacts(String keyword) async {
    final response = await apiService.searchContacts(keyword);

    // Chỉ xử lý dữ liệu khi API trả về HTTP 200 OK.
    if (response.statusCode == 200) {
      // Response body là JSON String → chuyển thành List.
      final List<dynamic> data = jsonDecode(response.body);

      // Chuyển từng JSON object thành ContactModel.
      final List<ContactModel> result = data
          .map((json) => ContactModel.fromJson(json))
          .toList();

      // Provider nhận kết quả Search làm State mới.
      contacts = result;
      loading = false;
      notifyListeners();
    }
  }
}

/*
FLOW

	ContactProvider
	    ↓
	┌───────────────┬────────────────┬────────────────┬────────────────┐
	Read            Create           Update           Delete           Search
	↓               ↓                ↓                ↓                ↓
	loadContacts()  addContact()     updateContact()  deleteContact()  searchContacts()
	↓               ↓                ↓                ↓                ↓
	GET             POST             PUT              DELETE           GET
	↓               ↓                ↓                ↓                ↓
	REST API        REST API         REST API         REST API         REST API
	                ↓                ↓                ↓                ↓
	                └───────┬────────┴────────┬───────┴────────────────┘
	                        ↓
	                  loadContacts()
	                        ↓
	                 notifyListeners()
	                        ↓
	                 ContactList rebuild
*/
