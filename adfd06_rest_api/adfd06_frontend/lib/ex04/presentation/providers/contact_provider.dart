import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/network/api_client.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/i_contact_repository.dart';

class ContactProvider extends ChangeNotifier {
  final IContactRepository repository;

  ContactProvider(this.repository);

  List<ContactEntity> contacts = [];
  bool loading = true;

  String? error;

  String _describe(Object e) {
    if (e is http.ClientException) {
      return 'Không kết nối được tới server.\n\n'
          'Kiểm tra hai thứ:\n'
          '• Backend đã chạy chưa (cổng 8082)\n'
          '• Emulator đã tắt chế độ máy bay chưa';
    }

    if (e is ApiException) {
      return 'Server trả về HTTP ${e.statusCode}';
    }

    return 'Lỗi không xác định: $e';
  }

  Future<void> _load(Future<List<ContactEntity>> Function() action) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      contacts = await action();
    } catch (e) {
      error = _describe(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> _mutate(Future<void> Function() action) async {
    try {
      await action();
      await loadContacts();
    } catch (e) {
      error = _describe(e);
      notifyListeners();
    }
  }

  Future<void> loadContacts() => _load(repository.getContacts);

  Future<void> searchContacts(String keyword) =>
      _load(() => repository.searchContacts(keyword));

  Future<void> addContact(ContactEntity contact) =>
      _mutate(() => repository.createContact(contact));

  Future<void> updateContact(int id, ContactEntity contact) =>
      _mutate(() => repository.updateContact(id, contact));

  Future<void> deleteContact(int id) =>
      _mutate(() => repository.deleteContact(id));
}

/*
FLOW

	ContactList (UI)
		↓  context.watch<ContactProvider>()
	ContactProvider
		↓
	IContactRepository
		↓
	... → ApiClient → Spring Boot


CẢI TIẾN — ba trạng thái thay vì hai

	                  gọi Repository
	                       ↓
	         ┌─────────────┼─────────────┐
	         ↓             ↓             ↓
	     thành công   ApiException   ClientException
	         ↓             ↓             ↓
	     contacts        error         error
	         └─────────────┼─────────────┘
	                       ↓
	                    finally
	                       ↓
	              loading = false   ← luôn chạy
	                       ↓
	               notifyListeners()
*/
