import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/contact_model.dart';
import '../services/api_service.dart';

/// Lớp quản lý State và logic gọi API của Contact.
class ContactProvider extends ChangeNotifier {
  // ApiService chịu trách nhiệm giao tiếp với REST API.
  final ApiService apiService = ApiService();

  // Danh sách Contact được Provider quản lý.
  List<ContactModel> contacts = [];

  // Trạng thái loading khi đang gọi API.
  bool loading = true;

  // CẢI TIẾN: State thứ ba, cạnh loading và contacts.
  //
  // Bản gốc chỉ có hai trạng thái: "đang tải" và "có dữ liệu". Thiếu mất
  // trạng thái "hỏng". Hậu quả là khi gọi API thất bại, loading không bao giờ
  // được set false và người dùng nhìn spinner quay vĩnh viễn.
  //
  // null = không có lỗi.
  String? error;

  // CẢI TIẾN: gom phần dịch exception sang câu tiếng Việt về một chỗ.
  //
  // Gói http bọc mọi lỗi tầng mạng (SocketException, timeout, DNS hỏng...)
  // lại thành ClientException, nên chỉ cần bắt đúng loại này.
  String _describe(Object e) {
    if (e is http.ClientException) {
      return 'Không kết nối được tới server.\n\n'
          'Kiểm tra hai thứ:\n'
          '• Backend đã chạy chưa (cổng 8082)\n'
          '• Emulator đã tắt chế độ máy bay chưa';
    }

    return 'Lỗi không xác định: $e';
  }

  // CẢI TIẾN: gom phần parse JSON, tránh lặp lại giữa load và search.
  List<ContactModel> _parseList(String body) {
    final List<dynamic> data = jsonDecode(body);

    return data.map((json) => ContactModel.fromJson(json)).toList();
  }

  // Tải danh sách Contact từ REST API.
  Future<void> loadContacts() async {
    // CẢI TIẾN: mỗi lần gọi lại thì xoá lỗi cũ và bật lại spinner,
    // nếu không nút "Thử lại" sẽ không có phản hồi gì trên màn hình.
    loading = true;
    error = null;
    notifyListeners();

    try {
      final response = await apiService.getContacts();

      // Chỉ xử lý dữ liệu khi API trả về HTTP 200 OK.
      if (response.statusCode == 200) {
        contacts = _parseList(response.body);
      } else {
        // CẢI TIẾN: server sống nhưng trả về mã lỗi — vẫn phải báo.
        error = 'Server trả về HTTP ${response.statusCode}';
      }
    } catch (e) {
      error = _describe(e);
    } finally {
      // CẢI TIẾN: đây là điểm mấu chốt. finally chạy trong MỌI trường hợp —
      // thành công, lỗi HTTP, hay exception — nên loading chắc chắn được tắt.
      loading = false;
      notifyListeners();
    }
  }

  // Tạo Contact mới thông qua ApiService.
  Future<void> addContact(ContactModel contact) async {
    try {
      final response = await apiService.createContact(contact);

      // Chỉ tải lại danh sách khi Create thành công.
      if (response.statusCode == 200 || response.statusCode == 201) {
        await loadContacts();
      } else {
        error = 'Tạo Contact thất bại (HTTP ${response.statusCode})';
        notifyListeners();
      }
    } catch (e) {
      error = _describe(e);
      notifyListeners();
    }
  }

  // UPDATE: Bổ sung Update Contact thông qua ApiService.
  Future<void> updateContact(int id, ContactModel contact) async {
    try {
      final response = await apiService.updateContact(id, contact);

      // Sau khi Update thành công, tải lại danh sách.
      if (response.statusCode == 200) {
        await loadContacts();
      } else {
        error = 'Cập nhật thất bại (HTTP ${response.statusCode})';
        notifyListeners();
      }
    } catch (e) {
      error = _describe(e);
      notifyListeners();
    }
  }

  // UPDATE: Bổ sung Delete Contact thông qua ApiService.
  Future<void> deleteContact(int id) async {
    try {
      final response = await apiService.deleteContact(id);

      // Sau khi Delete thành công, tải lại danh sách.
      if (response.statusCode == 200 || response.statusCode == 204) {
        await loadContacts();
      } else {
        error = 'Xoá thất bại (HTTP ${response.statusCode})';
        notifyListeners();
      }
    } catch (e) {
      error = _describe(e);
      notifyListeners();
    }
  }

  // UPDATE: Bổ sung Search Contact thông qua ApiService.
  Future<void> searchContacts(String keyword) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final response = await apiService.searchContacts(keyword);

      // Chỉ xử lý dữ liệu khi API trả về HTTP 200 OK.
      if (response.statusCode == 200) {
        // Provider nhận kết quả Search làm State mới.
        contacts = _parseList(response.body);
      } else {
        error = 'Tìm kiếm thất bại (HTTP ${response.statusCode})';
      }
    } catch (e) {
      error = _describe(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}

/*
FLOW

	ContactProvider
	    ↓
	┌───────────────┬────────────────┬────────────────┬────────────────┐
	Read            Create           Update           Delete           Search
	↓               ↓                ↓                ↓                ↓
	loadContacts()  addContact()     updateContact()  deleteContact()  searchContacts()
	↓               ↓                ↓                ↓                ↓
	GET             POST             PUT              DELETE           GET
	↓               ↓                ↓                ↓                ↓
	REST API        REST API         REST API         REST API         REST API
	                ↓                ↓                ↓                ↓
	                └───────┬────────┴────────┬───────┴────────────────┘
	                        ↓
	                  loadContacts()
	                        ↓
	                 notifyListeners()
	                        ↓
	                 ContactList rebuild


CẢI TIẾN — ba trạng thái thay vì hai

	                  gọi API
	                     ↓
	         ┌───────────┼───────────┐
	         ↓           ↓           ↓
	     HTTP 200    HTTP != 200  Exception
	         ↓           ↓           ↓
	     contacts      error       error
	         └───────────┼───────────┘
	                     ↓
	                  finally
	                     ↓
	            loading = false   ← luôn chạy, không đường nào thoát
	                     ↓
	             notifyListeners()
*/
