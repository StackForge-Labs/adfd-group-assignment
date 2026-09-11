import 'package:http/http.dart' as http;

/// Lỗi khi server trả về mã HTTP không thành công.
///
/// Có class riêng để tầng trên phân biệt được "server sống nhưng từ chối"
/// với "không kết nối được tới server" — hai lỗi này cần thông báo khác nhau.
class ApiException implements Exception {
  final int statusCode;

  ApiException(this.statusCode);

  @override
  String toString() => 'ApiException(HTTP $statusCode)';
}

/// Tầng thấp nhất — chỉ biết gửi HTTP, không biết Contact là gì.
///
/// Vai trò tương đương DatabaseHelper của Lab 5: nó là "cái ống" nối ra thế
/// giới bên ngoài, còn nghiệp vụ thì để tầng trên lo.
class ApiClient {
  // Gom địa chỉ backend về một chỗ duy nhất.
  //
  // 10.0.2.2 là địa chỉ ĐẶC BIỆT chỉ Android emulator hiểu, nó trỏ về máy
  // host. Chạy trên điện thoại thật phải đổi thành IP LAN của máy tính, chạy
  // iOS simulator thì dùng localhost.
  static const String _authority = 'localhost:8082';
  static const String _path = '/api/contacts';

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };

  // Dựng URI bằng Uri.http thay vì nối chuỗi, để Dart tự encode giá trị query.
  // Nối chuỗi tay thì 'A&B' sẽ bị cắt thành 'A', 'C#1' thành 'C'.
  Uri _uri([String extra = '', Map<String, String>? query]) {
    return Uri.http(_authority, '$_path$extra', query);
  }

  Future<http.Response> get([String extra = '', Map<String, String>? query]) {
    return http.get(_uri(extra, query));
  }

  Future<http.Response> post(String body) {
    return http.post(_uri(), headers: _jsonHeaders, body: body);
  }

  Future<http.Response> put(int id, String body) {
    return http.put(_uri('/$id'), headers: _jsonHeaders, body: body);
  }

  Future<http.Response> delete(int id) {
    return http.delete(_uri('/$id'));
  }
}

/*
FLOW

	ContactDataSourceImpl
		↓
	ApiClient
		├── get()
		├── post()
		├── put()
		└── delete()
		↓
	Uri.http()  ← tự encode query
		↓
	HTTP  →  Spring Boot  →  MySQL
*/
