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

  void addPostShowDialog(BuildContext context) {
    final txtTitle = TextEditingController();
    final txtContent = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: txtTitle,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: txtContent,
                decoration: const InputDecoration(hintText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<PostProvider>().addPost(
                  txtTitle.text,
                  txtContent.text,
                );

                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ADFD 7/7: provider'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Favourite'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeTab(
              txtSearch: txtSearch,
              onAddPost: () {
                addPostShowDialog(context);
              },
            ),
            const PostLikePage(),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final TextEditingController txtSearch;
  final VoidCallback onAddPost;

  const HomeTab({super.key, required this.txtSearch, required this.onAddPost});

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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton.icon(
                onPressed: onAddPost,
                icon: const Icon(Icons.add),
                label: const Text('Add Post'),
              ),
            ),
          ],
        ),
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  postProvider.toggleLike(postProvider.posts.indexOf(post));
                },
                icon: const Icon(Icons.favorite, color: Colors.red),
              ),
              IconButton(
                onPressed: () {
                  postProvider.deletePost(post);
                },
                icon: const Icon(Icons.delete),
              ),
            ],
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  postProvider.toggleLike(index);
                },
                icon: Icon(
                  post.isLike ? Icons.favorite : Icons.favorite_border,
                  color: post.isLike ? Colors.red : null,
                ),
              ),
              IconButton(
                onPressed: () {
                  postProvider.deletePost(post);
                },
                icon: const Icon(Icons.delete),
              ),
            ],
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
    }

    notifyListeners();
  }

  void toggleLike(int index) {
    posts[index].isLike = !posts[index].isLike;

    notifyListeners();
  }

  void addPost(String title, String content) {
    final newTitle = title.trim();
    final newContent = content.trim();

    if (newTitle.isEmpty || newContent.isEmpty) {
      return;
    }

    _allPosts.add(Post(title: newTitle, content: newContent));

    search(query);
  }

  void deletePost(Post post) {
    _allPosts.remove(post);

    search(query);
  }
}

/*
  Flow 7: Complete Post App

  Mục tiêu:
    - Hoàn thiện Post App từ các Flow trước.
    - Giữ nguyên PostProvider và Shared State.
    - Giữ nguyên Home và Favourite.
    - Giữ nguyên Loading / Async State.
    - Giữ nguyên Search State.
    - Giữ nguyên Like / Dislike.
    - Bổ sung Add Post.
    - Bổ sung Delete Post.

  Flow:

    MyApp
      ↓
    ChangeNotifierProvider
      ↓
    PostProvider
      ├── posts
      ├── loading
      ├── query
      ├── loadPosts()
      ├── search()
      ├── toggleLike()
      ├── addPost()
      └── deletePost()
      ↓
    HomePage
      ├── Home
      │    ├── Search
      │    ├── PostSummary
      │    ├── Add Post
      │    └── PostList
      │
      └── Favourite
           └── PostLikePage

  Add Post:

    User
      ↓
    Add Post
      ↓
    Dialog
      ↓
    addPost()
      ↓
    PostProvider
      ↓
    posts cập nhật
      ↓
    notifyListeners()
      ↓
    UI cập nhật

  Delete Post:

    User
      ↓
    Delete
      ↓
    deletePost()
      ↓
    PostProvider
      ↓
    posts cập nhật
      ↓
    notifyListeners()
      ↓
    UI cập nhật

  Search:

    User
      ↓
    Search ở Home
      ↓
    search()
      ↓
    query
      ↓
    lọc theo Post.title
      ↓
    notifyListeners()
      ↓
    Home cập nhật

  Shared State:

    PostProvider
      ├── Home
      └── Favourite

  Kết quả Flow 7:
    Hoàn thiện Post App với toàn bộ State
    được quản lý bởi PostProvider và dùng chung
    giữa các Page.

  Đây là Flow cuối của adfd04_provider.
*/
