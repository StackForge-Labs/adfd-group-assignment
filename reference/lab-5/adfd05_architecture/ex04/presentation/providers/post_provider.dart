import 'package:flutter/foundation.dart';

import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/i_post_repository.dart';

class PostProvider extends ChangeNotifier {
  final IPostRepository repository;

  List<PostEntity> posts = [];

  PostProvider(this.repository);

  Future<void> loadPosts() async {
    posts = await repository.getPosts();
    notifyListeners();
  }

  // UPDATE: Flow 2 - thêm xử lý Like/Dislike qua Repository.
  Future<void> toggleLike(PostEntity post) async {
    post.isLike = !post.isLike;

    await repository.toggleLike(post);

    notifyListeners();
  }
}

/*
FLOW

	HomePage
		↓
	PostProvider
		↓
	IPostRepository
	↑
	PostRepositoryImpl
	↓
	DatabaseHelper
	↓
	SQLite
	↓
	PostEntity
*/
