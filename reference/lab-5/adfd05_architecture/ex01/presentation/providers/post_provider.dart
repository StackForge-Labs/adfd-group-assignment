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
}

/*
FLOW

	HomePage
		↓
	PostProvider
		↓
	IPostRepository
		↓
	PostEntity
*/
