import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ex01/domain/entities/post_entity.dart';
import 'ex01/domain/repositories/i_post_repository.dart';
import 'ex01/presentation/pages/home_page.dart';
import 'ex01/presentation/providers/post_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<IPostRepository>(
      create: (_) => InMemoryPostRepository(),
      child: ChangeNotifierProvider(
        create: (context) =>
            PostProvider(context.read<IPostRepository>())..loadPosts(),
        child: Builder(
          builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HomePage(provider: context.watch<PostProvider>()),
            );
          },
        ),
      ),
    );
  }
}

class InMemoryPostRepository implements IPostRepository {
  @override
  Future<List<PostEntity>> getPosts() async {
    return [
      PostEntity(
        title: 'Flutter',
        content: 'Build beautiful user interfaces with Flutter.',
      ),
      PostEntity(title: 'Dart', content: 'Write application logic with Dart.'),
      PostEntity(
        title: 'Provider',
        content: 'Manage application state with Provider.',
      ),
    ];
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
	InMemoryPostRepository
		↓
	PostEntity
*/
