import 'package:flutter/material.dart';

import '../providers/post_provider.dart';

class HomePage extends StatelessWidget {
  final PostProvider provider;

  const HomePage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADFD 1/5: Architecture')),
      body: ListView.builder(
        itemCount: provider.posts.length,
        itemBuilder: (context, index) {
          final post = provider.posts[index];

          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.content),
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
		↓
	PostEntity
*/
