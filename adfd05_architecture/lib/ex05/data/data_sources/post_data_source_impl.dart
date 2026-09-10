import '../../core/database/database_helper.dart';
import '../../domain/entities/post_entity.dart';
import 'i_post_data_source.dart';

class PostDataSourceImpl implements IPostDataSource {
  final DatabaseHelper databaseHelper;

  PostDataSourceImpl(this.databaseHelper);

  @override
  Future<List<Map<String, dynamic>>> getPosts() async {
    final db = await databaseHelper.getDatabase();

    return db.query('posts', orderBy: 'id asc');
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

  @override
  Future<List<Map<String, dynamic>>> searchPosts(String keyword) async {
    final db = await databaseHelper.getDatabase();

    return db.query(
      'posts',
      where: 'title LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'id asc',
    );
  }
}

/*
FLOW

	IPostDataSource
		↑
	PostDataSourceImpl
		↓
	DatabaseHelper
		↓
	SQLite
		↓
	posts
*/
