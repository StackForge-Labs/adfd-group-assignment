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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ADFD 4/7: provider'),
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

    final likedPosts = postProvider.posts.where((post) => post.isLike).toList();

    return likedPosts.isEmpty
        ? const Center(child: Text('No liked posts'))
        : ListView.builder(
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
    // Lắng nghe PostProvider.
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
    // Lắng nghe PostProvider.
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
  final List<Post> posts = [
    Post(
      title: 'Flutter',
      content: 'Build beautiful user interfaces with Flutter.',
    ),
    Post(title: 'Dart', content: 'Write application logic with Dart.'),
    Post(title: 'Provider', content: 'Manage application state with Provider.'),
  ];

  int get likedCount {
    return posts.where((post) => post.isLike).length;
  }

  void toggleLike(int index) {
    posts[index].isLike = !posts[index].isLike;

    notifyListeners();
  }
}

/*
	Flow 4: Shared State between Pages

	Mục tiêu:
		- Giữ nguyên PostProvider từ Flow 3.
		- Giữ nguyên PostSummary và PostList.
		- Tạo hai tab: Home và Favourite.
		- Home và Favourite cùng sử dụng một PostProvider.
		- PostLikePage hiển thị các Post đang được Like.

	Flow:

		ChangeNotifierProvider
		↓
		PostProvider
		↓
		HomePage
		├── Home
		│    └── PostList
		│
		└── Favourite
		     └── PostLikePage

		Home và Favourite
			 ↓
		cùng PostProvider

	Khi User Like một Post ở Home:

		User
		↓
		PostList
		↓
		toggleLike()
		↓
		PostProvider
		↓
		notifyListeners()
		↓
		Favourite
		↓
		PostLikePage
		↓
		Post xuất hiện

	Kết quả Flow 4:
		Home và Favourite cùng nhìn thấy
		một State được quản lý bởi PostProvider.

	Flow tiếp theo:
		Flow 5 → Loading / Async State.
*/
