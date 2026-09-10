import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/i_contact_repository.dart';
import '../data_sources/i_contact_data_source.dart';
import '../models/contact_model.dart';

/// Repository — nơi DUY NHẤT biết cả Model lẫn Entity.
///
/// Nó nhận dữ liệu thô từ Data Source, dịch sang Entity cho tầng trên; và
/// ngược lại, nhận Entity từ tầng trên rồi dịch sang JSON cho Data Source.
///
/// Phụ thuộc vào IContactDataSource chứ không phải implementation cụ thể —
/// đúng như PostRepositoryImpl của Lab 5.
class ContactRepositoryImpl implements IContactRepository {
  final IContactDataSource dataSource;

  ContactRepositoryImpl(this.dataSource);

  List<ContactEntity> _toEntities(List<Map<String, dynamic>> rows) {
    return rows.map((row) => ContactModel.fromJson(row).toEntity()).toList();
  }

  @override
  Future<List<ContactEntity>> getContacts() async {
    final rows = await dataSource.getContacts();

    return _toEntities(rows);
  }

  @override
  Future<List<ContactEntity>> searchContacts(String keyword) async {
    final rows = await dataSource.searchContacts(keyword);

    return _toEntities(rows);
  }

  @override
  Future<void> createContact(ContactEntity contact) async {
    await dataSource.createContact(ContactModel.fromEntity(contact).toJson());
  }

  @override
  Future<void> updateContact(int id, ContactEntity contact) async {
    await dataSource.updateContact(
      id,
      ContactModel.fromEntity(contact).toJson(),
    );
  }

  @override
  Future<void> deleteContact(int id) async {
    await dataSource.deleteContact(id);
  }
}

/*
FLOW

	ContactProvider
		↓
	IContactRepository
	↑
	ContactRepositoryImpl   ← mapping Model ⇄ Entity xảy ra Ở ĐÂY
		↓
	IContactDataSource
	↑
	ContactDataSourceImpl
		↓
	ApiClient
		↓
	Spring Boot  →  MySQL
*/
