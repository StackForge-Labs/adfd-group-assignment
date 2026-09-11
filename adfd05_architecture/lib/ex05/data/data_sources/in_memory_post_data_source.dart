import '../../domain/entities/post_entity.dart';
import 'i_post_data_source.dart';

class InMemoryPostDataSource implements IPostDataSource {
  final List<Map<String, dynamic>> _posts = [
    {
      'id': 1,
      'title': 'In-Memory Data Source',
      'content': 'Dữ liệu này nằm trong RAM, không đọc từ SQLite.',
      'is_like': 0,
    },
    {
      'id': 2,
      'title': 'Dependency Inversion',
      'content': 'Repository phụ thuộc abstraction nên đổi nguồn rất rẻ.',
      'is_like': 1,
    },
    {
      'id': 3,
      'title': 'Một dòng trong injection.dart',
      'content': 'Đổi Data Source mà UI và Provider không hay biết gì.',
      'is_like': 0,
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> getPosts() async {
    return _posts.map((post) => Map<String, dynamic>.from(post)).toList();
  }

  @override
  Future<void> toggleLike(PostEntity post) async {
    final index = _posts.indexWhere((item) => item['id'] == post.id);

    if (index != -1) {
      _posts[index]['is_like'] = post.isLike ? 1 : 0;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchPosts(String keyword) async {
    final lower = keyword.toLowerCase();

    return _posts
        .where((post) => '${post['title']}'.toLowerCase().contains(lower))
        .map((post) => Map<String, dynamic>.from(post))
        .toList();
  }
}

/*
FLOW

	              IPostDataSource
	                    ↑
	        ┌───────────┴───────────┐
	PostDataSourceImpl      InMemoryPostDataSource
	        ↓                       ↓
	 DatabaseHelper            List trong RAM
	        ↓
	     SQLite

	Repository chỉ thấy IPostDataSource, nên nhánh nào cắm vào cũng chạy.
*/
