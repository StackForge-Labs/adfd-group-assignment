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
*/
