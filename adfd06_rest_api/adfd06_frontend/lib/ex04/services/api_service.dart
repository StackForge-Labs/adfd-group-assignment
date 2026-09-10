import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/contact_model.dart';

/// Service giao tiếp với REST API của Contact.
class ApiService {
  // CẢI TIẾN: gom địa chỉ backend về một chỗ.
  //
  // Bản gốc lặp lại chuỗi 'http://10.0.2.2:8082' ở cả 5 phương thức. Đổi máy
  // hay đổi cổng là phải sửa 5 nơi, sót một chỗ là lỗi rất khó tìm.
  //
  // Lưu ý: 10.0.2.2 là địa chỉ ĐẶC BIỆT chỉ Android emulator hiểu, nó trỏ về
  // máy host. Chạy trên điện thoại thật phải đổi thành IP LAN của máy tính,
  // chạy iOS simulator thì dùng localhost.
  static const String _authority = '10.0.2.2:8082';
  static const String _path = '/api/contacts';

  // CẢI TIẾN: dựng URI bằng Uri.http thay vì nối chuỗi.
  //
  // Uri.http tự encode giá trị query. Nối chuỗi tay thì các ký tự có ý nghĩa
  // đặc biệt trong URL sẽ phá cấu trúc:
  //   'A&B' → server chỉ nhận được 'A', phần '&B' biến thành query param khác
  //   'C#1' → server chỉ nhận được 'C', phần sau '#' bị cắt
  //   'a+b' → server đọc thành 'a b'
  static Uri _uri([String extra = '', Map<String, String>? query]) {
    return Uri.http(_authority, '$_path$extra', query);
  }

  // Lấy danh sách Contact.
  Future<http.Response> getContacts() async {
    final response = await http.get(_uri());

    return response;
  }

  // Tạo Contact mới.
  Future<http.Response> createContact(ContactModel contact) async {
    final response = await http.post(
      _uri(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contact.toJson()),
    );

    return response;
  }

  // UPDATE: Bổ sung Update Contact thông qua HTTP PUT.
  Future<http.Response> updateContact(int id, ContactModel contact) async {
    final response = await http.put(
      _uri('/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contact.toJson()),
    );

    return response;
  }

  // UPDATE: Bổ sung Delete Contact thông qua HTTP DELETE.
  Future<http.Response> deleteContact(int id) async {
    final response = await http.delete(_uri('/$id'));

    return response;
  }

  // UPDATE: Bổ sung Search Contact thông qua HTTP GET.
  Future<http.Response> searchContacts(String keyword) async {
    // CẢI TIẾN: keyword đi vào queryParameters, không nối vào chuỗi URL.
    final response = await http.get(_uri('/search', {'keyword': keyword}));

    return response;
  }
}

/*
FLOW

	ApiService
	    ↓
	_uri(extra, query)   ← CẢI TIẾN: một chỗ duy nhất dựng URI
	    ↓
	Uri.http(_authority, path, query)
	    ↓                    ↑
	    │            tự encode giá trị
	    ↓
	┌─────────────────────────────────────┐
	getContacts()      → GET    /api/contacts
	createContact()    → POST   /api/contacts
	updateContact(id)  → PUT    /api/contacts/{id}
	deleteContact(id)  → DELETE /api/contacts/{id}
	searchContacts(kw) → GET    /api/contacts/search?keyword=...
	└─────────────────────────────────────┘


CẢI TIẾN — vì sao không nối chuỗi

	'?keyword=' + keyword          Uri.http(..., {'keyword': keyword})
	        ↓                                    ↓
	  'A&B' → 'A'                          'A&B' → 'A&B'
	  'C#1' → 'C'                          'C#1' → 'C#1'
	  'a+b' → 'a b'                        'a+b' → 'a+b'
*/
