import 'package:flutter/material.dart';

import '../../domain/entities/contact_entity.dart';

/// Widget hiển thị Form nhập và cập nhật thông tin Contact.
class ContactForm extends StatefulWidget {
  final ContactEntity? contact;
  final void Function(ContactEntity contact) onSave;

  const ContactForm({super.key, this.contact, required this.onSave});

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
  void initState() {
    super.initState();

    // UPDATE: Khi có Contact, nạp dữ liệu hiện tại vào Form.
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      emailController.text = widget.contact!.email;
      phoneController.text = widget.contact!.phone;
      addressController.text = widget.contact!.address;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  // Tạo ContactEntity từ dữ liệu người dùng nhập.
  void saveContact() {
    final ContactEntity contact = ContactEntity(
      // UPDATE: Giữ lại id khi đang Update.
      id: widget.contact?.id,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
    );

    // Gửi ContactEntity về Widget cha.
    widget.onSave(contact);
  }

  @override
  Widget build(BuildContext context) {
    // UPDATE: Xác định Form đang ở chế độ Create hay Update.
    final bool isUpdate = widget.contact != null;

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
              // UPDATE: Đổi tên nút theo Create/Update.
              child: Text(isUpdate ? 'Update' : 'Save'),
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
	┌──────────────────────────────┐
	│                              │
	id == null                id != null
	│                              │
	↓                              ↓
	Create                       Update
	│                              │
	Form trống                    Nạp Contact
	│                              │
	↓                              ↓
	[Save]                       [Update]
	│                              │
	↓                              ↓
	ContactEntity              ContactEntity
	│                              │
	↓                              ↓
	onSave()                   onSave()
	│                              │
	↓                              ↓
	Provider                   Confirm
	│                              │
	addContact()              ┌────┴────┐
	│                         │         │
	POST                    Cancel      OK
	                              │      │
	                              │      ↓
	                              │  updateContact()
	                              │      ↓
	                              │     PUT
	                              │
	                              └── Form
*/
