import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/contact_model.dart';
import '../services/api_service.dart';
import './json_preview.dart';

///1. Widget hiển thị màn hình danh sách danh bạ.
class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

///2. Lớp quản lý trạng thái và logic xử lý dữ liệu của ContactList.
class _ContactListState extends State<ContactList> {
  // ApiService chịu trách nhiệm giao tiếp với REST API.
  final ApiService apiService = ApiService();

  // Danh sách Contact sau khi JSON được chuyển thành ContactModel.
  List<ContactModel> contacts = [];

  // Hiển thị trạng thái loading trong khi chờ API response.
  bool loading = true;

  @override
  void initState() {
    super.initState();

    // Gọi API khi ContactList được khởi tạo.
    loadContacts();
  }

  Future<void> loadContacts() async {
    // Gọi REST API và nhận HTTP Response.
    final response = await apiService.getContacts();

    // Chỉ xử lý dữ liệu khi API trả về HTTP 200 OK.
    if (response.statusCode == 200) {
      // Response body là JSON String → chuyển thành List.
      final List<dynamic> data = jsonDecode(response.body);

      // Chuyển từng JSON object thành ContactModel.
      final List<ContactModel> result = data
          .map((json) => ContactModel.fromJson(json))
          .toList();

      // Cập nhật State để Flutter rebuild UI.
      setState(() {
        contacts = result;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trong lúc chờ API, hiển thị loading.
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Khi đã có dữ liệu, hiển thị Contact List.
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];

        return ListTile(
          title: Text(contact.name),
          subtitle: Text(contact.phone),

          // UPDATE: Nối nút JSON với màn hình JSON Preview.
          trailing: OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return JsonPreview(contact: contact);
                },
              );
            },
            child: const Text('JSON'),
          ),
        );
      },
    );
  }
}

/*
FLOW

	ContactList
	    ↓
	ApiService
	    ↓
	HTTP GET
	    ↓
	http.Response
	    ↓
	jsonDecode()
	    ↓
	ContactModel.fromJson()
	    ↓
	List<ContactModel>
	    ↓
	ListView
	    ↓
	[JSON]
	    ↓
	JsonPreview
	    ↓
	ContactModel.toJson()
	    ↓
	JSON String
*/
