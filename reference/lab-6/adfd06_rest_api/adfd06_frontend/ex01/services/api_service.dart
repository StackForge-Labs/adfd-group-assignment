import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response> getContacts() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8082/api/contacts'),
    );

    return response;
  }
}

/*
FLOW

	ContactList
		↓
	ApiService
		↓
	http.get()
		↓
	GET /api/contacts
		↓
	REST API
		↓
	http.Response
*/
