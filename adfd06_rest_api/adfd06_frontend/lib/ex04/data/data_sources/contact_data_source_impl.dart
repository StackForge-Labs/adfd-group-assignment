import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/network/api_client.dart';
import 'i_contact_data_source.dart';

/// Data Source gọi REST API.
///
/// Nhiệm vụ: gọi ApiClient, kiểm tra mã HTTP, và trả về dữ liệu thô dạng Map.
/// Không đụng tới ContactEntity — đó là việc của Repository.
class ContactDataSourceImpl implements IContactDataSource {
  final ApiClient apiClient;

  ContactDataSourceImpl(this.apiClient);

  // Server sống nhưng từ chối thì ném ApiException để tầng trên báo cho đúng.
  void _ensureOk(http.Response response, List<int> accepted) {
    if (!accepted.contains(response.statusCode)) {
      throw ApiException(response.statusCode);
    }
  }

  List<Map<String, dynamic>> _decodeList(String body) {
    final List<dynamic> data = jsonDecode(body);

    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<List<Map<String, dynamic>>> getContacts() async {
    final response = await apiClient.get();
    _ensureOk(response, const [200]);

    return _decodeList(response.body);
  }

  @override
  Future<List<Map<String, dynamic>>> searchContacts(String keyword) async {
    final response = await apiClient.get('/search', {'keyword': keyword});
    _ensureOk(response, const [200]);

    return _decodeList(response.body);
  }

  @override
  Future<void> createContact(Map<String, dynamic> json) async {
    final response = await apiClient.post(jsonEncode(json));
    _ensureOk(response, const [200, 201]);
  }

  @override
  Future<void> updateContact(int id, Map<String, dynamic> json) async {
    final response = await apiClient.put(id, jsonEncode(json));
    _ensureOk(response, const [200]);
  }

  @override
  Future<void> deleteContact(int id) async {
    final response = await apiClient.delete(id);
    _ensureOk(response, const [200, 204]);
  }
}

/*
FLOW

	IContactDataSource
		↑
	ContactDataSourceImpl
		↓
	ApiClient  →  HTTP  →  Spring Boot
		↓
	kiểm tra statusCode
		├── hợp lệ    → jsonDecode → List<Map>
		└── không hợp lệ → throw ApiException
*/
