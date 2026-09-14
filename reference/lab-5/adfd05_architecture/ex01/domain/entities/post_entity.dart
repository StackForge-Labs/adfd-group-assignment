class PostEntity {
  final String title;
  final String content;
  bool isLike;

  PostEntity({required this.title, required this.content, this.isLike = false});
}

/*
FLOW

	PostProvider
		↓
	PostEntity
		├── title
		├── content
		└── isLike
*/
