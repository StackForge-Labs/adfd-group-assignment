import '../entities/contact_entity.dart';

/// Hợp đồng của Repository — chỉ khai báo, không làm.
///
/// ContactProvider phụ thuộc vào interface này chứ không phụ thuộc vào
/// ContactRepositoryImpl. Nhờ vậy Provider không biết dữ liệu đến từ REST API
/// hay từ đâu khác, và cũng không cần biết.
abstract class IContactRepository {
  Future<List<ContactEntity>> getContacts();

  Future<List<ContactEntity>> searchContacts(String keyword);

  Future<void> createContact(ContactEntity contact);

  Future<void> updateContact(int id, ContactEntity contact);

  Future<void> deleteContact(int id);
}

/*
FLOW

	ContactProvider
		↓
	IContactRepository
		├── getContacts()
		├── searchContacts()
		├── createContact()
		├── updateContact()
		└── deleteContact()
		↑
	ContactRepositoryImpl
*/
