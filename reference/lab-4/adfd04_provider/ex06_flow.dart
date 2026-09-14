import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// * 1. App *

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}

// * 2. Page *

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController txtSearch = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load Post khi HomePage được tạo.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadPosts();
    });
  }

  @override
  void dispose() {
    txtSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ADFD 6/7: provider'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Favourite'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeTab(txtSearch: txtSearch),
            const PostLikePage(),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final TextEditingController txtSearch;

  const HomeTab({super.key, required this.txtSearch});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    if (postProvider.loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: txtSearch,
            onChanged: (value) {
              context.read<PostProvider>().search(value);
            },
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: txtSearch.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        txtSearch.clear();
                        context.read<PostProvider>().search('');
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
            ),
          ),
        ),
        const PostSummary(),
        const Expanded(child: PostList()),
      ],
    );
  }
}

class PostLikePage extends StatelessWidget {
  const PostLikePage({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    if (postProvider.loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      );
    }

    final likedPosts = postProvider.posts.where((post) => post.isLike).toList();

    if (likedPosts.isEmpty) {
      return const Center(child: Text('No liked posts'));
    }

    return ListView.builder(
      itemCount: likedPosts.length,
      itemBuilder: (context, index) {
        final post = likedPosts[index];

        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.content),
          trailing: IconButton(
            onPressed: () {
              postProvider.toggleLike(postProvider.posts.indexOf(post));
            },
            icon: const Icon(Icons.favorite, color: Colors.red),
          ),
        );
      },
    );
  }
}

// * 3. Widget *

class PostSummary extends StatelessWidget {
  const PostSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Liked: ${postProvider.likedCount}',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    return ListView.builder(
      itemCount: postProvider.posts.length,
      itemBuilder: (context, index) {
        final post = postProvider.posts[index];

        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.content),
          trailing: IconButton(
            onPressed: () {
              postProvider.toggleLike(index);
            },
            icon: Icon(
              post.isLike ? Icons.favorite : Icons.favorite_border,
              color: post.isLike ? Colors.red : null,
            ),
          ),
        );
      },
    );
  }
}

// * 4. Model *

class Post {
  String title;
  String content;
  bool isLike;

  Post({required this.title, required this.content, this.isLike = false});
}

// * 5. ChangeNotifier *

class PostProvider extends ChangeNotifier {
  final List<Post> _allPosts = [
    Post(
      title: 'Flutter',
      content: 'Build beautiful user interfaces with Flutter.',
    ),
    Post(title: 'Dart', content: 'Write application logic with Dart.'),
    Post(title: 'Provider', content: 'Manage application state with Provider.'),
  ];

  List<Post> posts = [];

  bool _loading = false;

  bool get loading => _loading;

  String query = '';

  int get likedCount {
    return posts.where((post) => post.isLike).length;
  }

  Future<void> loadPosts() async {
    _loading = true;
    notifyListeners();

    // Mô phỏng quá trình tải dữ liệu.
    await Future.delayed(const Duration(seconds: 5));

    posts = List.from(_allPosts);

    _loading = false;
    notifyListeners();
  }

  void search(String keyword) {
    query = keyword;

    if (keyword.isEmpty) {
      posts = List.from(_allPosts);
    } else {
      final value = keyword.toLowerCase();
      posts = _allPosts.where((post) {
        return post.title.toLowerCase().contains(value);
      }).toList();
      //   posts = _allPosts.where((post) {
      //     return post.title.toLowerCase().contains(value) ||
      //         post.content.toLowerCase().contains(value);
      //   }).toList();
    }

    notifyListeners();
  }

  void toggleLike(int index) {
    posts[index].isLike = !posts[index].isLike;

    notifyListeners();
  }
}

/*
  Flow 6: Search State

  Mục tiêu:
    - Giữ nguyên PostProvider từ Flow 5.
    - Giữ nguyên hai tab Home và Favourite.
    - Bổ sung Search State.
    - Provider quản lý query.
    - Provider xử lý Search.
    - Search chỉ xuất hiện ở tab Home.
    - Favourite vẫn sử dụng cùng PostProvider.

  Flow:

    Home
      ↓
    Search
      ↓
    search(keyword)
      ↓
    query thay đổi
      ↓
    lọc List<Post>
      ↓
    posts thay đổi
      ↓
    notifyListeners()
      ↓
    Home cập nhật kết quả

  Shared State:

    PostProvider
      ├── Home
      └── Favourite

    Search State cũng nằm trong
    chính PostProvider.

  Kết quả Flow 6:
    PostProvider quản lý thêm Search State
    và kết quả tìm kiếm của Post.

  Flow tiếp theo:
    Flow 7 → Complete Post App.
*/
