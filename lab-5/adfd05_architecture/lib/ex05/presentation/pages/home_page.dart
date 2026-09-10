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
            'ADFD 5/5: Architecture',
          ), // UPDATE: Flow 5 - Đổi AppBar title

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
                    // UPDATE: Flow 5 - Search theo keyword trên Home
                    onChanged: (value) {
                      provider.search(value);
                    },
                  ),
                ),

                Expanded(child: _buildPostList(provider.posts)),
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

	TabBar
		├── Home
		│    ↓
		│  Search UI
		│    ↓
		│  Post List
		│
		└── Favourite
		     ↓
		   Liked Post List
*/
