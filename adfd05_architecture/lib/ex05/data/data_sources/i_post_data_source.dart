import '../../domain/entities/post_entity.dart';

abstract class IPostDataSource {
  Future<List<Map<String, dynamic>>> getPosts();

  Future<void> toggleLike(PostEntity post);

  Future<List<Map<String, dynamic>>> searchPosts(String keyword);
}

/*
FLOW

	PostRepositoryImpl
		↓
	IPostDataSource
		├── getPosts()
		├── toggleLike()
		└── searchPosts()
		↑
	PostDataSourceImpl
*/
