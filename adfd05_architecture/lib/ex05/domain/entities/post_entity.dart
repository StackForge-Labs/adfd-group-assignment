class PostEntity {
  final int? id;
  final String title;
  final String content;
  bool isLike;

  PostEntity({
    this.id,
    required this.title,
    required this.content,
    this.isLike = false,
  });
}

/*
FLOW

	PostProvider
		↓
	IPostRepository
		↓
	PostEntity
		├── id
		├── title
		├── content
		└── isLike
	
	Bản chất của Entity ↔ Model Mapping
	- PostEntity không cần biết SQLite lưu is_like bằng 0/1 hay gì.
	- PostModel tự biết cách biểu diễn dữ liệu theo Data Source.

*/
