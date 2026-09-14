import 'package:get_it/get_it.dart';

import '../database/database_helper.dart';
// UPDATE: Flow 5 - Thêm abstraction của Data Source
import '../../data/data_sources/i_post_data_source.dart';
// UPDATE: Flow 5 - Thêm implementation của Data Source
import '../../data/data_sources/post_data_source_impl.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/repositories/i_post_repository.dart';
import '../../presentation/providers/post_provider.dart';

final injector = GetIt.instance;

void setDI() {
  injector.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // UPDATE: Flow 5 - Đăng ký IPostDataSource và nối với DatabaseHelper
  injector.registerLazySingleton<IPostDataSource>(
    () => PostDataSourceImpl(injector<DatabaseHelper>()),
  );

  // UPDATE: Flow 5 - Repository nhận IPostDataSource thay vì DatabaseHelper
  injector.registerLazySingleton<IPostRepository>(
    () => PostRepositoryImpl(injector<IPostDataSource>()),
  );

  injector.registerFactory<PostProvider>(
    () => PostProvider(injector<IPostRepository>()),
  );
}
