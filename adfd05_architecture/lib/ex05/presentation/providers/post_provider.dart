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

  Future<void> toggleLike(PostEntity post) async {
    post.isLike = !post.isLike;

    await repository.toggleLike(post);

    notifyListeners();
  }

  // UPDATE: Flow 5 - Thêm Search vào Provider
  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      await loadPosts();
      return;
    }

    // UPDATE: Flow 5 - Provider yêu cầu Repository thực hiện Search
    posts = await repository.searchPosts(keyword);

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
		↓
	searchPosts()
*/
