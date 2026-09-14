import 'package:flutter/material.dart';

// * 1. App *

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

// * 2. Page *

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// * 3. State *

class _HomePageState extends State<HomePage> {
  final List<Post> posts = [
    Post(
      title: 'Flutter',
      content: 'Build beautiful user interfaces with Flutter.',
    ),
    Post(title: 'Dart', content: 'Write application logic with Dart.'),
    Post(title: 'Provider', content: 'Manage application state with Provider.'),
  ];

  void toggleLike(int index) {
    setState(() {
      posts[index].isLike = !posts[index].isLike;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADFD 2/7: provider')),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.content),
            trailing: IconButton(
              onPressed: () {
                toggleLike(index);
              },
              icon: Icon(
                post.isLike ? Icons.favorite : Icons.favorite_border,
                color: post.isLike ? Colors.red : null,
              ),
            ),
          );
        },
      ),
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

/*
  Flow 2: setState()

  Mục tiêu:
    - Giữ nguyên Post và List<Post> từ Flow 1.
    - Cho phép User thay đổi State.
    - Dùng setState() để cập nhật State.
    - UI cập nhật sau khi State thay đổi.
    - Chưa sử dụng ChangeNotifier.
    - Chưa sử dụng Provider.

  Flow:

    MyApp
      ↓
    HomePage
      ↓
    _HomePageState
      ↓
    List<Post>
      ↓
    Post List UI
      ↓
    User nhấn Like / Dislike
      ↓
    toggleLike()
      ↓
    setState()
      ↓
    isLike thay đổi
      ↓
    build()
      ↓
    UI cập nhật

  Kết quả Flow 2:
    State vẫn nằm trong _HomePageState,
    nhưng User đã có thể thay đổi State bằng setState().

  Flow tiếp theo:
    Flow 3 → tách State khỏi Page bằng ChangeNotifier
    và cung cấp PostProvider bằng ChangeNotifierProvider.
*/
