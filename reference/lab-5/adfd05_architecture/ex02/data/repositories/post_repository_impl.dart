import '../../core/database/database_helper.dart';
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
      return PostEntity(
        id: row['id'] as int,
        title: row['title'] as String,
        content: row['content'] as String,
        isLike: (row['is_like'] as int) == 1,
      );
    }).toList();
  }

  @override
  Future<void> toggleLike(PostEntity post) async {
    final db = await databaseHelper.getDatabase();

    await db.update(
      'posts',
      {'is_like': post.isLike ? 1 : 0},
      where: 'id = ?',
      whereArgs: [post.id],
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
	DatabaseHelper
		↓
	SQLite
		↓
	posts
		↓
	PostEntity
*/
