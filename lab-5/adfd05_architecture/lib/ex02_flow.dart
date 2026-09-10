import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ex02/core/database/database_helper.dart';
import 'ex02/data/repositories/post_repository_impl.dart';
import 'ex02/domain/repositories/i_post_repository.dart';
import 'ex02/presentation/pages/home_page.dart';
import 'ex02/presentation/providers/post_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<IPostRepository>(
      // UPDATE: Flow 2 - thay InMemoryPostRepository bằng Repository thật.
      create: (_) => PostRepositoryImpl(DatabaseHelper()),
      child: ChangeNotifierProvider(
        // UPDATE: Flow 2 - PostProvider nhận Repository thật.
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
		↓
	adfd05.db
*/
