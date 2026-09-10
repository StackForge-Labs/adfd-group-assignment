import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact_model.dart';
import '../providers/contact_provider.dart';
import 'contact_form.dart';

///1. Widget hiển thị màn hình danh sách Contact.
class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

///2. Lớp quản lý vòng đời và giao diện của ContactList.
class _ContactListState extends State<ContactList> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Gọi Provider sau khi Widget được tạo.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactProvider>().loadContacts();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // UPDATE: Tìm kiếm Contact theo Name.
  void searchContacts(String keyword) {
    final provider = context.read<ContactProvider>();

    if (keyword.trim().isEmpty) {
      // Khi ô Search rỗng, tải lại toàn bộ danh sách.
      provider.loadContacts();
      return;
    }

    provider.searchContacts(keyword.trim());
  }

  // UPDATE: Mở ContactForm để Edit Contact.
  void editContact(ContactModel contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Contact'),
          content: ContactForm(
            contact: contact,
            onSave: (updatedContact) async {
              // Hiển thị Confirm sau khi người dùng nhấn Update.
              final bool? confirmed = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirm Update'),
                    content: const Text('Do you want to update this contact?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );

              // Không tiếp tục nếu người dùng Cancel.
              if (confirmed != true) {
                return;
              }

              // Gọi Provider thực hiện Update.
              await context.read<ContactProvider>().updateContact(
                updatedContact.id!,
                updatedContact,
              );

              // UPDATE: Kiểm tra Context còn hợp lệ sau await.
              if (!context.mounted) {
                return;
              }

              // Đóng ContactForm sau khi Update hoàn tất.
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  // UPDATE: Xác nhận trước khi Delete Contact.
  void deleteContact(ContactModel contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: Text('Do you want to delete ${contact.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await context.read<ContactProvider>().deleteContact(
                  contact.id!,
                );

                // UPDATE: Kiểm tra Context còn hợp lệ sau await.
                if (!context.mounted) {
                  return;
                }

                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // CẢI TIẾN: màn hình báo lỗi thay cho spinner quay vĩnh viễn.
  //
  // Ba thứ người dùng cần khi có sự cố: biết là đã hỏng, biết hỏng vì sao,
  // và có cách thử lại mà không phải tắt mở app.
  Widget buildError(ContactProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 56),
            const SizedBox(height: 16),
            Text(
              provider.error ?? 'Đã có lỗi xảy ra',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                searchController.clear();
                provider.loadContacts();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  // CẢI TIẾN: phân biệt "không có kết quả" với "chưa tải xong".
  Widget buildEmpty() {
    return const Center(child: Text('Không tìm thấy Contact nào'));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContactProvider>();

    return Column(
      children: [
        // UPDATE: Bổ sung Search Contact.
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            onChanged: searchContacts,
            decoration: InputDecoration(
              labelText: 'Search by name',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  searchController.clear();
                  searchContacts('');
                },
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
        ),

        // CẢI TIẾN: bốn nhánh thay vì hai — loading, lỗi, rỗng, có dữ liệu.
        Expanded(
          child: provider.loading
              ? const Center(child: CircularProgressIndicator())
              : provider.error != null
              ? buildError(provider)
              : provider.contacts.isEmpty
              ? buildEmpty()
              : ListView.builder(
                  itemCount: provider.contacts.length,
                  itemBuilder: (context, index) {
                    final contact = provider.contacts[index];

                    return ListTile(
                      title: Text(contact.name),
                      subtitle: Text(contact.phone),

                      // UPDATE: Bổ sung Edit.
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              editContact(contact);
                            },
                            icon: const Icon(Icons.edit),
                          ),

                          // UPDATE: Bổ sung Delete.
                          IconButton(
                            onPressed: () {
                              deleteContact(contact);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/*
FLOW

	ContactList
	    ↓
	┌──────────────────────────────────────┐
	│                                      │
	│ Search                               │
	│   ↓                                  │
	│ searchContacts()                     │
	│   ↓                                  │
	│ ContactProvider                      │
	│   ↓                                  │
	│ GET /search                          │
	│                                      │
	│ Contact                              │
	│   ├── Edit                           │
	│   │    ↓                             │
	│   │  ContactForm                     │
	│   │    ↓                             │
	│   │  [Update]                        │
	│   │    ↓                             │
	│   │  Confirm                         │
	│   │    ↓                             │
	│   │  Provider.updateContact()       │
	│   │    ↓                             │
	│   │  PUT                             │
	│   │                                  │
	│   └── Delete                         │
	│        ↓                             │
	│      Confirm                         │
	│        ↓                             │
	│      Provider.deleteContact()       │
	│        ↓                             │
	│      DELETE                          │
	│                                      │
	└──────────────────────────────────────┘
	                ↓
	         loadContacts()
	                ↓
	         notifyListeners()
	                ↓
	          ContactList rebuild
*/
