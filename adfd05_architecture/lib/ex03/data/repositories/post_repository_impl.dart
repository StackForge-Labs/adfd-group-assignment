import '../../core/database/database_helper.dart';
import '../models/post_model.dart'; // UPDATE: Flow 3 - Repository sử dụng PostModel để mapping
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/i_post_repository.dart';

class PostRepositoryImpl implements IPostRepository {
  final DatabaseHelper databaseHelper;

  PostRepositoryImpl(this.databaseHelper);

  @override
  Future<List<PostEntity>> getPosts() async {
    final db = await databaseHelper.getDatabase();

    final rows = await db.query('posts', orderBy: 'id asc');

    return rows.map((row) {
      final model = PostModel(
        id: row['id'] as int,
        title: row['title'] as String,
        content: row['content'] as String,
        isLike: row['is_like'] as int,
      ); // UPDATE: Flow 3 - SQLite Map → PostModel

      return model.toEntity(); // UPDATE: Flow 3 - PostModel → PostEntity
    }).toList();
  }

  @override
  Future<void> toggleLike(PostEntity post) async {
    final db = await databaseHelper.getDatabase();

    final model = PostModel.fromEntity(post);
    // UPDATE: Flow 3 - PostEntity → PostModel

    await db.update(
      'posts',
      {
        'is_like': model.isLike,
      }, // UPDATE: Flow 3 - PostModel cung cấp giá trị theo Data Source
      where: 'id = ?',
      whereArgs: [model.id],
    );
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
	PostModel
		↕
	Mapping
	↕
	PostEntity

	PostModel
		↓
	DatabaseHelper
		↓
	SQLite
*/
