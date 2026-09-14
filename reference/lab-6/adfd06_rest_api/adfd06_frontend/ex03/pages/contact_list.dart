import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contact_provider.dart';

///1. Widget hiển thị màn hình danh sách Contact.
class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

///2. Lớp quản lý vòng đời và giao diện của ContactList.
class _ContactListState extends State<ContactList> {
  @override
  void initState() {
    super.initState();

    // Gọi Provider sau khi Widget được tạo.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactProvider>().loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // UPDATE: Đọc State từ ContactProvider thay vì tự quản lý State.
    final provider = context.watch<ContactProvider>();

    // Trong lúc Provider đang gọi API, hiển thị loading.
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: provider.contacts.length,
      itemBuilder: (context, index) {
        final contact = provider.contacts[index];

        return ListTile(
          title: Text(contact.name),
          subtitle: Text(contact.phone),
        );
      },
    );
  }
}

/*
FLOW

	ContactList
	    ↓
	ContactProvider
	    ↓
	┌─────────────────────┐
	│ contacts            │
	│ loading             │
	└─────────────────────┘
	    ↓
	context.watch()
	    ↓
	ContactList rebuild
	    ↓
	ListView
	    ↓
	Contact
*/
