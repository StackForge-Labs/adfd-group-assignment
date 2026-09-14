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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADFD 1/7: provider')),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.content),
            trailing: Icon(
              post.isLike ? Icons.favorite : Icons.favorite_border,
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
  Flow 1: Local State

  Mục tiêu:
    - Dùng Post làm Data/Domain xuyên suốt project.
    - Tạo List<Post>.
    - Hiển thị danh sách Post.
    - State của Post List nằm trong _HomePageState.
    - Chưa thay đổi State bằng thao tác của User.
    - Chưa sử dụng setState().

  Data:

    Post 1
      title: Flutter
      content: Build beautiful user interfaces with Flutter.

    Post 2
      title: Dart
      content: Write application logic with Dart.

    Post 3
      title: Provider
      content: Manage application state with Provider.

  Flow:

    MyApp
      ↓
    HomePage
      ↓
    _HomePageState
      ↓
    List<Post>
      ↓
    ListView.builder
      ↓
    Post List UI

  Kết quả Flow 1:
    Có Post List và State nằm tại Page,
    đồng thời Data đã được chuẩn bị để sử dụng xuyên suốt
    các Flow tiếp theo.

  Flow tiếp theo:
    Flow 2 → thay đổi State bằng setState().
*/
