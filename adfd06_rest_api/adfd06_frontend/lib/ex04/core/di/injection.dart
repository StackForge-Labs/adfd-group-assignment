import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import '../../data/data_sources/contact_data_source_impl.dart';
import '../../data/data_sources/i_contact_data_source.dart';
import '../../data/repositories/contact_repository_impl.dart';
import '../../domain/repositories/i_contact_repository.dart';
import '../../presentation/providers/contact_provider.dart';

final injector = GetIt.instance;

void setDI() {
  injector.registerLazySingleton<ApiClient>(() => ApiClient());

  injector.registerLazySingleton<IContactDataSource>(
    () => ContactDataSourceImpl(injector<ApiClient>()),
  );

  injector.registerLazySingleton<IContactRepository>(
    () => ContactRepositoryImpl(injector<IContactDataSource>()),
  );

  injector.registerFactory<ContactProvider>(
    () => ContactProvider(injector<IContactRepository>()),
  );
}

/*
FLOW

	setDI()  ← chỉ GHI CÔNG THỨC, chưa tạo object nào
	   ↓
	ApiClient
	   ↓
	IContactDataSource  ←  ContactDataSourceImpl(ApiClient)
	   ↓
	IContactRepository  ←  ContactRepositoryImpl(IContactDataSource)
	   ↓
	ContactProvider(IContactRepository)
	   ↓
	HomePage

	Object thật chỉ được tạo khi có ai đó hỏi tới — nghĩa của chữ Lazy.
*/
