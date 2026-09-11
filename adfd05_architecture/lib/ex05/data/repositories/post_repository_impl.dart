import '../data_sources/i_post_data_source.dart';

import '../models/post_model.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/i_post_repository.dart';

class PostRepositoryImpl implements IPostRepository {
  // UPDATE: Flow 5 - Thay DatabaseHelper bằng IPostDataSource
  final IPostDataSource dataSource;

  PostRepositoryImpl(this.dataSource);

  @override
  Future<List<PostEntity>> getPosts() async {
    // UPDATE: Flow 5 - Lấy dữ liệu thông qua Data Source
    final rows = await dataSource.getPosts();

    return rows.map((row) {
      final model = PostModel(
        id: row['id'] as int,
        title: row['title'] as String,
        content: row['content'] as String,
        isLike: row['is_like'] as int,
      );

      return model.toEntity();
    }).toList();
  }

  @override
  Future<void> toggleLike(PostEntity post) async {
    // UPDATE: Flow 5 - Giao việc cập nhật dữ liệu cho Data Source
    await dataSource.toggleLike(post);
  }

  @override
  Future<List<PostEntity>> searchPosts(String keyword) async {
    // UPDATE: Flow 5 - Repository lấy kết quả Search từ Data Source
    final rows = await dataSource.searchPosts(keyword);

    return rows.map((row) {
      final model = PostModel(
        id: row['id'] as int,
        title: row['title'] as String,
        content: row['content'] as String,
        isLike: row['is_like'] as int,
      );

      return model.toEntity();
    }).toList();
  }
}

/*
FLOW

	PostProvider
		↓
	IPostRepository
	↑
	PostRepositoryImpl
		↓
	IPostDataSource
	↑
	PostDataSourceImpl
		↓
	DatabaseHelper
		↓
	SQLite
*/
