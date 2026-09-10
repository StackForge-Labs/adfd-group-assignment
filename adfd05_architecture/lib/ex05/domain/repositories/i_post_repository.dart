import '../entities/post_entity.dart';

abstract class IPostRepository {
  Future<List<PostEntity>> getPosts();

  Future<void> toggleLike(PostEntity post);

  // UPDATE: Flow 5 - Thêm contract Search cho Repository
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
