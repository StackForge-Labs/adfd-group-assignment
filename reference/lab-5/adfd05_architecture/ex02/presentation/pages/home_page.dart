import 'package:flutter/material.dart';

import '../providers/post_provider.dart';

class HomePage extends StatelessWidget {
  final PostProvider provider;

  const HomePage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADFD 2/5: Architecture')),
      body: ListView.builder(
        itemCount: provider.posts.length,
        itemBuilder: (context, index) {
          final post = provider.posts[index];

          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.content),
            // UPDATE: Flow 2 - thêm Like/Dislike để tương tác với Repository.
            trailing: IconButton(
              icon: Icon(
                post.isLike ? Icons.favorite : Icons.favorite_border,
                color: post.isLike ? Colors.red : null,
              ),
              onPressed: () {
                // UPDATE: Flow 2 - gửi thao tác Like/Dislike xuống Provider.
                provider.toggleLike(post);
              },
            ),
          );
        },
      ),
    );
  }
}

/*
FLOW

	HomePage
		↓
	PostProvider
		↓
	IPostRepository
		↑
	PostRepositoryImpl
		↓
	DatabaseHelper
		↓
	SQLite
*/
