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
  @override
  void initState() {
    super.initState();

    // Load Post khi HomePage được tạo.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ADFD 5/7: provider'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Favourite'),
            ],
          ),
        ),
        body: const TabBarView(children: [HomeTab(), PostLikePage()]),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

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
      children: const [
        PostSummary(),
        Expanded(child: PostList()),
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
          trailing: const Icon(Icons.favorite, color: Colors.red),
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
  final List<Post> posts = [];

  bool _loading = false;

  bool get loading => _loading;

  int get likedCount {
    return posts.where((post) => post.isLike).length;
  }

  Future<void> loadPosts() async {
    _loading = true;
    notifyListeners();

    // Mô phỏng quá trình tải dữ liệu.
    await Future.delayed(const Duration(seconds: 5));

    posts
      ..clear()
      ..addAll([
        Post(
          title: 'Flutter',
          content: 'Build beautiful user interfaces with Flutter.',
        ),
        Post(title: 'Dart', content: 'Write application logic with Dart.'),
        Post(
          title: 'Provider',
          content: 'Manage application state with Provider.',
        ),
      ]);

    _loading = false;
    notifyListeners();
  }

  void toggleLike(int index) {
    posts[index].isLike = !posts[index].isLike;

    notifyListeners();
  }
}

/*
  Flow 5: Loading / Async State

  Mục tiêu:
    - Giữ nguyên Post và PostProvider từ Flow 4.
    - Bổ sung loading State.
    - Provider quản lý trạng thái trong quá trình tải dữ liệu.
    - UI phản ứng với loading.
    - Hai tab Home và Favourite vẫn dùng chung PostProvider.
    - Chưa sử dụng Repository hoặc Data Source.

  Flow:

    MyApp
      ↓
    ChangeNotifierProvider
      ↓
    PostProvider
      ↓
    HomePage
      ↓
    loadPosts()
      ↓
    loading = true
      ↓
    notifyListeners()
      ↓
    ┌──────────────────────┐
    ↓                      ↓
  HomeTab             PostLikePage
    ↓                      ↓
  Loading...            Loading...
    ↓                      ↓
    └──────────┬───────────┘
               ↓
          tải dữ liệu
               ↓
          posts cập nhật
               ↓
          loading = false
               ↓
          notifyListeners()
               ↓
          PostProvider
               ↓
       ┌───────┴────────┐
       ↓                ↓
     Home           Favourite

  Kết quả Flow 5:
    PostProvider không chỉ quản lý Post State,
    mà còn quản lý Loading State của quá trình
    xử lý dữ liệu bất đồng bộ.

  Flow tiếp theo:
    Flow 6 → Search State.
*/
