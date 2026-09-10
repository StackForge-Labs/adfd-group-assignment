import 'package:get_it/get_it.dart';

import '../database/database_helper.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/repositories/i_post_repository.dart';
import '../../presentation/providers/post_provider.dart';

final injector = GetIt.instance;

void setDI() {
  injector.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  injector.registerLazySingleton<IPostRepository>(
    () => PostRepositoryImpl(injector<DatabaseHelper>()),
  );

  injector.registerFactory<PostProvider>(
    () => PostProvider(injector<IPostRepository>()),
  );
}

/*
FLOW

	setDI()
		↓
	GetIt
		├── DatabaseHelper
		│
		├── IPostRepository
		│       ↓
		│   PostRepositoryImpl
		│
		└── PostProvider
		        ↓
		    IPostRepository
*/
