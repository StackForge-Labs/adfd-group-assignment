import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ex03/core/database/database_helper.dart'; // UPDATE: Flow 3 - Sử dụng structure ex03
import 'ex03/data/repositories/post_repository_impl.dart'; // UPDATE: Flow 3 - Repository sử dụng Mapping
import 'ex03/domain/repositories/i_post_repository.dart';
import 'ex03/presentation/pages/home_page.dart';
import 'ex03/presentation/providers/post_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<IPostRepository>(
      create: (_) => PostRepositoryImpl(DatabaseHelper()), // UPDATE: Flow 3 - PostRepositoryImpl thực hiện SQLite → Model → Entity
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
	PostModel
		↕
	Mapping
		↕
	PostEntity
		↓
	DatabaseHelper
		↓
	SQLite
*/
