import 'package:flutter/material.dart';

import '../models/contact_model.dart';

/// Widget hiển thị Form nhập thông tin Contact.
class ContactForm extends StatefulWidget {
  final void Function(ContactModel contact) onSave;

  const ContactForm({super.key, required this.onSave});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

/// Lớp quản lý dữ liệu nhập và xử lý Form của Contact.
class _ContactFormState extends State<ContactForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Tạo ContactModel từ dữ liệu người dùng nhập.
  void saveContact() {
    final ContactModel contact = ContactModel(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
    );

    // Gửi ContactModel về Widget cha.
    widget.onSave(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),

          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),

          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),

          TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: 'Address'),
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: saveContact,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}

/*
FLOW

	ContactForm
	    ↓
	User nhập dữ liệu
	    ↓
	TextEditingController
	    ↓
	[Save]
	    ↓
	Tạo ContactModel
	    ↓
	widget.onSave(contact)
	    ↓
	Widget cha
*/
