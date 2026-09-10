class PostEntity {
  final int? id; // UPDATE: Flow 2 - thêm id để ánh xạ với SQLite
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
*/
