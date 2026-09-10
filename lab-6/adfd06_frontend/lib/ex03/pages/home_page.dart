import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contact_provider.dart';
import 'contact_form.dart';
import 'contact_list.dart';

/// Widget màn hình chính của Flow 3.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Mở Form và kết nối Create với ContactProvider.
  void openContactForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          content: ContactForm(
            onSave: (contact) async {
              // Gửi Contact mới cho Provider xử lý Create.
              await context.read<ContactProvider>().addContact(contact);

              // UPDATE: Kiểm tra Context còn hợp lệ sau await.
              if (!context.mounted) {
                return;
              }

              // Đóng Form sau khi Create hoàn tất.
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADFD 3/4: Provider + API State')),

      body: const ContactList(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openContactForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/*
FLOW

	HomePage
	    ↓
	┌──────────────────────────────────┐
	│ Scaffold                         │
	│                                  │
	│ AppBar                           │
	│   ↓                              │
	│ ContactList                      │
	│   ↓                              │
	│ ContactProvider                  │
	│                                  │
	│ FloatingActionButton             │
	│   ↓                              │
	│ ContactForm                      │
	│   ↓                              │
	│ ContactModel                     │
	│   ↓                              │
	│ ContactProvider.addContact()     │
	│   ↓                              │
	│ ApiService.createContact()       │
	│   ↓                              │
	│ POST /api/contacts               │
	│   ↓                              │
	│ loadContacts()                   │
	│   ↓                              │
	│ notifyListeners()                │
	│   ↓                              │
	│ ContactList rebuild              │
	└──────────────────────────────────┘
*/
