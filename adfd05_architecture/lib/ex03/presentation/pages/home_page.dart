import 'package:flutter/material.dart';

import '../providers/post_provider.dart';

class HomePage extends StatelessWidget {
  final PostProvider provider;

  const HomePage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ADFD 3/5: Architecture'), // UPDATE: Flow 3
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Favourite'),
            ],
          ), // UPDATE: Flow 3 - Home/Favourite dùng TabBar
        ),
        body: TabBarView(
          children: [
            _buildPostList(provider.posts),
            _buildPostList(
              provider.posts.where((post) => post.isLike).toList(),
            ), // UPDATE: Flow 3 - Favourite chỉ hiển thị Post đã Like
          ],
        ), // UPDATE: Flow 3 - Nội dung tương ứng với từng Tab
      ),
    );
  }

  Widget _buildPostList(List posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return ListTile(
          title: Text(post.title),
          subtitle: Text(post.content),
          trailing: IconButton(
            icon: Icon(
              post.isLike ? Icons.favorite : Icons.favorite_border,
              color: post.isLike ? Colors.red : null,
            ),
            onPressed: () {
              provider.toggleLike(post);
            },
          ),
        );
      },
    );
  }
}

/*
FLOW

	HomePage
		↓
	PostProvider
		↓
	PostEntity
		├── Home
		│    ↓
		│  All Posts
		│
		└── Favourite
		     ↓
		   isLike == true

	UI
		↓
	TabBar
		├── Home
		└── Favourite
		     ↓
		TabBarView
*/
