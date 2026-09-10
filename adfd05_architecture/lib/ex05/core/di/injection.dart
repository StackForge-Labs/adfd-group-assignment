import 'package:get_it/get_it.dart';

import '../database/database_helper.dart';
// UPDATE: Flow 5 - Thêm abstraction của Data Source
import '../../data/data_sources/i_post_data_source.dart';
// UPDATE: Flow 5 - Thêm implementation của Data Source
import '../../data/data_sources/post_data_source_impl.dart';
// CẢI TIẾN: Data Source thứ hai — dùng để chứng minh giá trị của abstraction.
import '../../data/data_sources/in_memory_post_data_source.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/repositories/i_post_repository.dart';
import '../../presentation/providers/post_provider.dart';

final injector = GetIt.instance;

/// CẢI TIẾN: công tắc chọn nguồn dữ liệu.
///
/// Đây là TOÀN BỘ những gì phải sửa để đổi app từ đọc SQLite sang đọc dữ liệu
/// trong RAM. Đổi false thành true, chạy lại, xong.
///
/// Không file nào khác phải sửa — không Repository, không Provider, không UI.
/// Đó là điều mà bốn tầng trừu tượng của Lab 5 mua về được.
const bool useInMemoryDataSource = false;

void setDI() {
  injector.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // UPDATE: Flow 5 - Đăng ký IPostDataSource và nối với DatabaseHelper
  // CẢI TIẾN: chọn implementation theo công tắc ở trên.
  injector.registerLazySingleton<IPostDataSource>(
    () => useInMemoryDataSource
        ? InMemoryPostDataSource()
        : PostDataSourceImpl(injector<DatabaseHelper>()),
  );

  // UPDATE: Flow 5 - Repository nhận IPostDataSource thay vì DatabaseHelper
  injector.registerLazySingleton<IPostRepository>(
    () => PostRepositoryImpl(injector<IPostDataSource>()),
  );

  injector.registerFactory<PostProvider>(
    () => PostProvider(injector<IPostRepository>()),
  );
}

/*
FLOW

	setDI()
	   ↓
	IPostDataSource  ←── useInMemoryDataSource quyết định cắm nhánh nào
	   │
	   ├── false → PostDataSourceImpl → DatabaseHelper → SQLite
	   └── true  → InMemoryPostDataSource → List trong RAM
	   ↓
	IPostRepository → PostRepositoryImpl
	   ↓
	PostProvider
	   ↓
	HomePage

	Ba tầng dưới cùng KHÔNG BIẾT dữ liệu đến từ đâu, và không cần biết.
*/
