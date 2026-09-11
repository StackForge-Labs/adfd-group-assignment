import '../entities/post_entity.dart';

abstract class IPostRepository {
  Future<List<PostEntity>> getPosts();

  Future<void> toggleLike(PostEntity post);

  Future<List<PostEntity>> searchPosts(String keyword);
}

/*
FLOW

	PostProvider
		↓
	IPostRepository
		├── getPosts()
		├── toggleLike()
		└── searchPosts()
*/
