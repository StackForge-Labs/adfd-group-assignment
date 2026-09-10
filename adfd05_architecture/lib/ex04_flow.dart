import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ex04/core/di/injection.dart'; // UPDATE: Flow 4 - Sử dụng DI
import 'ex04/presentation/pages/home_page.dart';
import 'ex04/presentation/providers/post_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!injector.isRegistered<PostProvider>()) {
      setDI();
    } // UPDATE: Flow 4 - Khởi tạo dependency từ Composition Root

    return ChangeNotifierProvider(
      create: (_) => injector<PostProvider>()
        ..loadPosts(), // UPDATE: Flow 4 - Lấy PostProvider từ GetIt
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

	MyApp
		↓
	GetIt
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
