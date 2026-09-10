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
          title: const Text(
            'ADFD 4/5: Architecture',
          ), // UPDATE: Flow 4 - Đổi AppBar title

          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Favourite'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search posts...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ), // UPDATE: Flow 4 - Thêm Search UI, chưa có Search logic

                Expanded(
                  child: _buildPostList(provider.posts),
                ), // UPDATE: Flow 4 - Search UI nằm phía trên Post List
              ],
            ),

            _buildPostList(
              provider.posts.where((post) => post.isLike).toList(),
            ),
          ],
        ),
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
		│    ├── Search UI
		│    │     ↓
		│    │   chưa có Search logic
		│    │
		│    └── All Posts
		│
		└── Favourite
		     ↓
		   isLike == true

	UI
		↓
	TabBar
		├── Home
		│    ↓
		│  Search UI
		│
		└── Favourite
		     ↓
		   Favourite Posts
*/
