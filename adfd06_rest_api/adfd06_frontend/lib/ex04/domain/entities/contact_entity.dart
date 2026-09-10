/// Dữ liệu Contact ở tầng Domain.
///
/// Entity KHÔNG biết gì về JSON, về HTTP, về server. Nó chỉ là dữ liệu thuần
/// mà phần còn lại của app dùng. Muốn mai đổi từ REST API sang SQLite thì
/// class này không phải sửa một dòng nào.
class ContactEntity {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String address;

  ContactEntity({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });
}

/*
FLOW

	ContactProvider
		↓
	IContactRepository
		↓
	ContactEntity
		├── id
		├── name
		├── email
		├── phone
		└── address

	Bản chất của Entity ↔ Model Mapping
	- Server có thể trả email = null. Entity không cần biết chuyện đó.
	- ContactModel tự lo phần dịch null → chuỗi rỗng.
	- Giống hệt Lab 5: SQLite lưu is_like = 0/1, PostEntity chỉ thấy true/false.
*/
