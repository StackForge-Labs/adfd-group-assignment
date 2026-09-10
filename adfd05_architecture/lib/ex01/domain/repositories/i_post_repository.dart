import '../entities/post_entity.dart';

abstract class IPostRepository {
  Future<List<PostEntity>> getPosts();
}

/*
FLOW

	PostProvider
		↓
	IPostRepository
		↓
	PostEntity
*/
