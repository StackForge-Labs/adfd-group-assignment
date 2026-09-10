/// Hợp đồng của Data Source.
///
/// Data Source chỉ nói chuyện bằng dữ liệu THÔ — Map, đúng như server trả về.
/// Nó không biết ContactEntity là gì. Việc phiên dịch là của Repository.
///
/// Nhờ hợp đồng này, mai muốn đổi nguồn dữ liệu từ REST API sang SQLite thì
/// chỉ cần viết một implementation khác, Repository không phải sửa.
abstract class IContactDataSource {
  Future<List<Map<String, dynamic>>> getContacts();

  Future<List<Map<String, dynamic>>> searchContacts(String keyword);

  Future<void> createContact(Map<String, dynamic> json);

  Future<void> updateContact(int id, Map<String, dynamic> json);

  Future<void> deleteContact(int id);
}

/*
FLOW

	ContactRepositoryImpl
		↓
	IContactDataSource
		├── getContacts()
		├── searchContacts()
		├── createContact()
		├── updateContact()
		└── deleteContact()
		↑
	ContactDataSourceImpl
		↓
	ApiClient
*/
