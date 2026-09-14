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
    return Scaffold(
      appBar: AppBar(title: const Text('ADFD 3/7: provider')),
      body: Column(
        children: const [
          PostSummary(),
          Expanded(child: PostList()),
        ],
      ),
    );
  }
}

// * 3. Widget *

class PostSummary extends StatelessWidget {
  const PostSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Liked: ${postProvider.likedCount}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
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
	Flow 3: ChangeNotifierProvider

	Mục tiêu:
		- Giữ nguyên Post và Post List từ Flow 2.
		- Tách State ra khỏi _HomePageState.
		- Dùng PostProvider để quản lý State.
		- Dùng ChangeNotifierProvider để cung cấp PostProvider
		cho các Widget trong Widget Tree.
		- Nhiều Widget có thể cùng sử dụng một PostProvider.

	Flow:

		MyApp
		↓
		ChangeNotifierProvider
		↓
		PostProvider
		↓
		HomePage
		├── PostSummary
		│     ↓
		│   Consumer<PostProvider>
		│
		└── PostList
				↓
			Consumer<PostProvider>
				↓
			List<Post>

	Khi User nhấn Like / Dislike:

		User
		↓
		PostList
		↓
		toggleLike()
		↓
		PostProvider
		↓
		State thay đổi
		↓
		notifyListeners()
		↓
		┌───────────────────────┐
		↓                       ↓
	PostList              PostSummary
		↓                       ↓
	cập nhật             likedCount cập nhật

	Kết quả Flow 3:
		State không còn nằm trong Page.
		PostProvider được cung cấp từ Widget Tree
		và nhiều Widget có thể cùng sử dụng State đó.

	Flow tiếp theo:
		Flow 4 → dùng chung Post State giữa các Page.
*/
