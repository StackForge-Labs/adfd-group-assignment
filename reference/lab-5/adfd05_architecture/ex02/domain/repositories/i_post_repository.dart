import '../entities/post_entity.dart';

abstract class IPostRepository {
  Future<List<PostEntity>> getPosts();

  Future<void> toggleLike(PostEntity post);
}

/*
FLOW

	PostProvider
		↓
	IPostRepository
		├── getPosts()
		└── toggleLike()
*/
