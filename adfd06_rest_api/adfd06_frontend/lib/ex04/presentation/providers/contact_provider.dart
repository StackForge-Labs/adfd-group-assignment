import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/network/api_client.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/i_contact_repository.dart';

/// Quản lý State của màn hình Contact.
///
/// Phụ thuộc vào IContactRepository — KHÔNG biết dữ liệu đến từ REST API,
/// SQLite hay bộ nhớ. Muốn đổi nguồn thì chỉ sửa injection.dart.
class ContactProvider extends ChangeNotifier {
  final IContactRepository repository;

  ContactProvider(this.repository);

  // Danh sách Contact được Provider quản lý.
  List<ContactEntity> contacts = [];

  // Trạng thái loading khi đang gọi API.
  bool loading = true;

  // CẢI TIẾN: State thứ ba, cạnh loading và contacts.
  //
  // Bản gốc chỉ có hai trạng thái: "đang tải" và "có dữ liệu". Thiếu mất
  // trạng thái "hỏng", nên khi gọi API thất bại thì loading không bao giờ
  // được tắt và người dùng nhìn spinner quay vĩnh viễn.
  String? error;

  // Dịch exception sang câu tiếng Việt cho người dùng đọc được.
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

  // Chạy một thao tác đọc dữ liệu và cập nhật State theo kết quả.
  Future<void> _load(Future<List<ContactEntity>> Function() action) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      contacts = await action();
    } catch (e) {
      error = _describe(e);
    } finally {
      // finally chạy trong MỌI trường hợp, nên loading chắc chắn được tắt.
      loading = false;
      notifyListeners();
    }
  }

  // Chạy một thao tác ghi dữ liệu, xong thì tải lại danh sách.
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
