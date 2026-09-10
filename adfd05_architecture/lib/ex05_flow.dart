import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ex05/core/di/injection.dart';
import 'ex05/presentation/pages/home_page.dart';
import 'ex05/presentation/providers/post_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!injector.isRegistered<PostProvider>()) {
      setDI();
    }

    return ChangeNotifierProvider(
      create: (_) => injector<PostProvider>()..loadPosts(),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(provider: context.watch<PostProvider>()),
          );
        },
      ),
    );
  }
}

/*
FLOW

	GetIt
		↓
	PostProvider
		↓
	IPostRepository
	↑
	PostRepositoryImpl
		↓
	IPostDataSource
	↑
	PostDataSourceImpl
		↓
	DatabaseHelper
		↓
	SQLite
*/
