class ContactModel {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String address;

  ContactModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'],
      name: json['name'],
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'] ?? '',
    );
  }

  // UPDATE: Bổ sung chuyển ContactModel → JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}

/*
FLOW

	JSON
	    ↓
	ContactModel.fromJson()
	    ↓
	ContactModel
	    ↓
	ContactModel.toJson()
	    ↓
	JSON
*/
