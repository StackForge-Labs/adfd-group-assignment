import '../../domain/entities/post_entity.dart';
import 'i_post_data_source.dart';

/// CẢI TIẾN — Data Source thứ hai, không phải SQLite.
///
/// Đây là thứ CHỨNG MINH kiến trúc của Lab 5 có giá trị thật.
///
/// Suốt 5 flow, màn hình chạy lên trông y hệt nhau, nên rất khó thấy được
/// bốn tầng trừu tượng kia mang lại gì. Class này trả lời câu đó bằng một
/// phép thử cụ thể:
///
///   Đổi ĐÚNG MỘT DÒNG trong ex05/core/di/injection.dart:
///
///       PostDataSourceImpl(injector<DatabaseHelper>())   ← SQLite
///       InMemoryPostDataSource()                         ← danh sách trong RAM
///
///   App chạy y nguyên. Read, Like/Dislike, Search đều hoạt động.
///
/// Những file KHÔNG phải sửa một dòng nào:
///   • PostRepositoryImpl   — vì nó phụ thuộc IPostDataSource, không phụ
///                            thuộc PostDataSourceImpl
///   • PostProvider         — vì nó phụ thuộc IPostRepository
///   • HomePage             — vì nó chỉ nói chuyện với Provider
///   • PostEntity, PostModel
///
/// Đó chính là Dependency Inversion. Không có nó, đổi nguồn dữ liệu là phải
/// sửa lan từ tầng data lên tận UI.
///
/// Ngoài mục đích trình bày, một Data Source như thế này còn dùng thật để
/// chạy app khi chưa có database, hoặc để viết test không cần SQLite.
class InMemoryPostDataSource implements IPostDataSource {
  // Dữ liệu giữ nguyên hình dạng Map giống hệt SQLite trả về, kể cả quy ước
  // is_like là số 0/1 chứ không phải bool. Nhờ vậy PostRepositoryImpl mapping
  // sang PostModel theo đúng cách cũ, không cần biết dữ liệu đến từ đâu.
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
    // Trả về bản sao để bên ngoài không sửa trực tiếp được dữ liệu gốc.
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
