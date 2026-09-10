import '../../domain/entities/contact_entity.dart';

/// Contact ở tầng Data — biết cách nói chuyện với JSON.
///
/// Đây là nơi DUY NHẤT trong app biết server đặt tên trường là gì và có thể
/// trả về null. Nhờ vậy phần còn lại của app chỉ làm việc với ContactEntity
/// sạch sẽ.
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
      name: json['name'] ?? '',
      // Cột email và address cho phép null trong database.
      // Model nuốt luôn chuyện đó, Entity không cần biết.
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
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

  // ContactModel → ContactEntity.
  ContactEntity toEntity() {
    return ContactEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      address: address,
    );
  }

  // ContactEntity → ContactModel.
  factory ContactModel.fromEntity(ContactEntity entity) {
    return ContactModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
    );
  }
}

/*
FLOW

	JSON  ⇄  ContactModel  ⇄  ContactEntity
	      ↑                ↑
	 fromJson()       toEntity()
	 toJson()         fromEntity()

	Server trả email = null
		↓
	ContactModel.fromJson()  →  email = ''
		↓
	ContactEntity            →  email luôn là String, không bao giờ null
*/
