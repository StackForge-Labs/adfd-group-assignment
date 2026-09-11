# Hiểu sâu Lab 5 — tài liệu cho người trình bày

Dành cho **Hậu (5A)** và **Tuấn (5B)**. Mục tiêu: hiểu tới mức **tự giải thích
lại được** và **trả lời được câu hỏi vặn**, không chỉ đọc thuộc slide.

Đọc `docs/tong-quan-lab-5-6.md` trước nếu chưa nắm bức tranh lớn.

---

# Phần 1 — Lab 5 thật ra giải quyết vấn đề gì

## Vấn đề, phát biểu cho thật cụ thể

Giả sử app đang đọc dữ liệu từ SQLite. Mai công ty bảo: *"Đổi sang gọi API đi."*

**Nếu code viết kiểu thông thường** — màn hình gọi thẳng xuống database:

```
HomePage  →  sqflite  →  SQLite
```

Thì `HomePage` đang **biết** những thứ nó không nên biết:
- Biết dữ liệu nằm trong SQLite
- Biết tên bảng là `posts`
- Biết cột tên `is_like` và lưu số `1`/`0`

Đổi sang API nghĩa là **sửa lại `HomePage`**. Mà `HomePage` là chỗ vẽ giao diện —
nó không liên quan gì tới chuyện dữ liệu đến từ đâu.

## Lab 5 làm gì

Chèn các **tầng trung gian** vào giữa, sao cho mỗi tầng chỉ biết đúng phần việc
của mình:

```
HomePage        biết cách VẼ, không biết dữ liệu ở đâu
PostProvider    biết cách GIỮ trạng thái, không biết dữ liệu ở đâu
IPostRepository chỉ là HỢP ĐỒNG, không làm gì cả
    ↑
PostRepositoryImpl   biết cách PHIÊN DỊCH dữ liệu
IPostDataSource      lại là HỢP ĐỒNG
    ↑
PostDataSourceImpl   biết SQL, biết tên cột
DatabaseHelper       biết mở file .db
```

**Câu chốt để nói trên sân khấu:**

> *"Mục tiêu không phải làm code phức tạp lên. Mục tiêu là để khi một thứ thay
> đổi, chỉ đúng một chỗ phải sửa."*

---

# Phần 2 — Bốn tầng, mỗi tầng làm gì

| Tầng | Thư mục | Chứa gì | Được phép biết gì |
|---|---|---|---|
| **Presentation** | `presentation/` | `HomePage`, `PostProvider` | Chỉ biết `PostEntity` và `IPostRepository` |
| **Domain** | `domain/` | `PostEntity`, `IPostRepository` | **Không biết gì cả** — không biết SQLite, không biết Flutter |
| **Data** | `data/` | `PostModel`, `PostRepositoryImpl`, `IPostDataSource`, `PostDataSourceImpl` | Biết SQLite, biết tên cột, biết `1/0` |
| **Core** | `core/` | `DatabaseHelper`, `injection.dart` | Hạ tầng dùng chung |

## Quy tắc vàng — nhớ cái này là hiểu cả lab

> **Domain là tầng TRONG CÙNG. Nó không được import từ tầng nào khác.**

Mở `domain/entities/post_entity.dart` ra xem: nó **không có dòng `import` nào**.
Không import `sqflite`, không import `flutter`, không import gì hết. Đó là bằng
chứng cụ thể nhất của kiến trúc này.

Mũi tên phụ thuộc luôn chỉ **vào trong**:

```
Presentation  →  Domain  ←  Data
```

Cả hai tầng ngoài đều phụ thuộc vào Domain. Domain **không phụ thuộc ai**.

---

# Phần 3 — Đi qua từng file

Thứ tự dưới đây đi từ **trong ra ngoài**, đúng thứ tự nên hiểu.

## 3.1 · `domain/entities/post_entity.dart`

```dart
class PostEntity {
  final int? id;
  final String title;
  final String content;
  bool isLike;                    // ← CHÚ Ý: không có final

  PostEntity({
    this.id,
    required this.title,
    required this.content,
    this.isLike = false,
  });
}
```

**Đây là dữ liệu Post ở dạng thuần tuý.** Không biết JSON, không biết SQL.

**Ba điều cần để ý:**

1. `id` là `int?` — có dấu `?` nghĩa là **có thể null**. Vì lúc tạo Post mới,
   chưa lưu vào database thì chưa có id. Database sinh id.

2. `isLike` là `bool` — đúng kiểu mà lập trình viên muốn dùng.

3. **`isLike` KHÔNG có `final`** — tức là **sửa được sau khi tạo**. Ba trường kia
   đều `final`. Đây là chủ ý, sẽ giải thích ở mục 6.1.

## 3.2 · `domain/repositories/i_post_repository.dart`

```dart
abstract class IPostRepository {
  Future<List<PostEntity>> getPosts();
  Future<void> toggleLike(PostEntity post);
  Future<List<PostEntity>> searchPosts(String keyword);
}
```

**`abstract class` trong Dart = `interface` trong Java.**

Nó chỉ nói *"sẽ có ba việc này"*, **không nói làm thế nào**. Không có thân hàm,
không có dấu `{}`.

**Vì sao chữ `I` ở đầu tên?** Quy ước đặt tên, `I` = Interface. Dart không bắt
buộc, nhưng nhìn tên là biết ngay đây là hợp đồng.

> **Câu hỏi hay bị vặn:** *"Khai báo mà không làm gì thì có tác dụng gì?"*
>
> **Trả lời:** Tác dụng là cho phép tầng trên **phụ thuộc vào lời hứa thay vì
> phụ thuộc vào người thực hiện**. `PostProvider` chỉ cần biết "có ai đó hứa trả
> về danh sách Post". Ai hứa, hứa bằng SQLite hay bằng API — không liên quan.

## 3.3 · `data/models/post_model.dart`

```dart
class PostModel {
  final int? id;
  final String title;
  final String content;
  final int isLike;               // ← int, KHÔNG phải bool

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      title: title,
      content: content,
      isLike: isLike == 1,        // ← 1 → true, 0 → false
    );
  }

  factory PostModel.fromEntity(PostEntity entity) {
    return PostModel(
      ...
      isLike: entity.isLike ? 1 : 0,   // ← true → 1, false → 0
    );
  }
}
```

**Đây là người phiên dịch.**

| | `PostModel` | `PostEntity` |
|---|---|---|
| `isLike` | `int` — `1` hoặc `0` | `bool` — `true` hoặc `false` |
| Thuộc tầng | Data | Domain |
| Biết SQLite không? | **Có** | **Không** |

**Vì sao SQLite dùng `1`/`0`?** Vì SQLite **không có kiểu boolean**. Nó chỉ có 5
kiểu: `NULL`, `INTEGER`, `REAL`, `TEXT`, `BLOB`. Muốn lưu đúng/sai thì phải quy
ước bằng số.

> **Câu hỏi hay bị vặn:** *"Hai class giống nhau gần hết, sao không gộp?"*
>
> **Trả lời:** Vì nếu gộp, cả app phải dùng `isLike == 1`. Lúc đó một hạn chế
> của SQLite lan ra tới tận `HomePage`. Và ngày đổi sang API — nơi JSON trả về
> `true`/`false` thật — thì phải sửa khắp nơi. Tách ra thì chỗ sửa duy nhất là
> `PostModel`.

## 3.4 · `data/data_sources/i_post_data_source.dart`

```dart
abstract class IPostDataSource {
  Future<List<Map<String, dynamic>>> getPosts();
  Future<void> toggleLike(PostEntity post);
  Future<List<Map<String, dynamic>>> searchPosts(String keyword);
}
```

**Hợp đồng thứ hai.** Khác hợp đồng thứ nhất ở kiểu trả về:

| | Trả về gì |
|---|---|
| `IPostRepository` | `List<PostEntity>` — dữ liệu **đã sạch** |
| `IPostDataSource` | `List<Map<String, dynamic>>` — dữ liệu **thô**, y như database trả ra |

`Map<String, dynamic>` là một hàng trong bảng, dạng `{'id': 1, 'title': 'Flutter',
'is_like': 0}`.

## 3.5 · `data/data_sources/post_data_source_impl.dart`

```dart
class PostDataSourceImpl implements IPostDataSource {
  final DatabaseHelper databaseHelper;

  PostDataSourceImpl(this.databaseHelper);

  @override
  Future<List<Map<String, dynamic>>> getPosts() async {
    final db = await databaseHelper.getDatabase();
    return db.query('posts', orderBy: 'id asc');
  }

  @override
  Future<List<Map<String, dynamic>>> searchPosts(String keyword) async {
    final db = await databaseHelper.getDatabase();
    return db.query(
      'posts',
      where: 'title LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'id asc',
    );
  }
}
```

**Đây là nơi DUY NHẤT biết SQL và biết tên cột.**

- `implements IPostDataSource` — cam kết làm đủ ba việc trong hợp đồng
- `@override` — đánh dấu "hàm này thực hiện lời hứa trong hợp đồng"
- `where: 'title LIKE ?'` với `whereArgs` — dùng **tham số** thay vì nối chuỗi,
  tránh SQL injection
- `'%$keyword%'` — dấu `%` là ký tự đại diện của SQL, nghĩa là "chứa chuỗi này ở
  bất kỳ đâu"

> **Search chạy bằng SQL, không phải lọc trong bộ nhớ.** Gõ chữ nào là gọi
> database chữ đó.

## 3.6 · `data/repositories/post_repository_impl.dart`

```dart
class PostRepositoryImpl implements IPostRepository {
  final IPostDataSource dataSource;          // ← phụ thuộc HỢP ĐỒNG

  PostRepositoryImpl(this.dataSource);

  @override
  Future<List<PostEntity>> getPosts() async {
    final rows = await dataSource.getPosts();     // Map thô

    return rows.map((row) {
      final model = PostModel(
        id: row['id'] as int,
        title: row['title'] as String,
        content: row['content'] as String,
        isLike: row['is_like'] as int,            // ← đọc tên cột
      );

      return model.toEntity();                    // ← dịch sang Entity
    }).toList();
  }
}
```

**Đây là nơi phiên dịch xảy ra.** Ba bước:

```
Map thô  →  PostModel  →  PostEntity
```

**Chú ý dòng `final IPostDataSource dataSource;`** — Repository phụ thuộc vào
**hợp đồng**, không phụ thuộc `PostDataSourceImpl`. Đây chính là chỗ cho phép cú
lật một dòng hoạt động.

## 3.7 · `core/database/database_helper.dart`

```dart
class DatabaseHelper {
  static const String dbName = 'adfd05.db';

  Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          create table posts (
            id integer primary key autoincrement,
            title text not null,
            content text not null,
            is_like integer not null default 0
          )
        ''');

        await db.transaction((txn) async {
          await txn.insert('posts', {'title': 'Flutter', ...});
          await txn.insert('posts', {'title': 'Dart', ...});
          await txn.insert('posts', {'title': 'Provider', ...});
        });
      },
    );
  }
}
```

**Ba điều đáng nói:**

1. **`onCreate` chỉ chạy MỘT LẦN** — lần đầu tiên file `adfd05.db` được tạo.
   Mở app lần thứ hai trở đi, `onCreate` không chạy nữa. Đó là lý do dữ liệu
   like được giữ lại sau khi tắt app.

2. **`is_like integer`** — lại thấy SQLite không có boolean.

3. **`transaction`** — ba lệnh insert chạy trong một giao dịch. Hoặc cả ba thành
   công, hoặc không cái nào. Tránh trường hợp tạo được 2 post rồi lỗi.

> **Câu hỏi hay bị vặn:** *"Xoá app rồi cài lại thì dữ liệu thế nào?"*
>
> **Trả lời:** File `.db` bị xoá theo, nên `onCreate` chạy lại và seed lại 3 post
> ban đầu. Mọi like đều mất.

## 3.8 · `core/di/injection.dart`

```dart
final injector = GetIt.instance;

const bool useInMemoryDataSource = false;   // ← công tắc của nhóm

void setDI() {
  injector.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  injector.registerLazySingleton<IPostDataSource>(
    () => useInMemoryDataSource
        ? InMemoryPostDataSource()
        : PostDataSourceImpl(injector<DatabaseHelper>()),
  );

  injector.registerLazySingleton<IPostRepository>(
    () => PostRepositoryImpl(injector<IPostDataSource>()),
  );

  injector.registerFactory<PostProvider>(
    () => PostProvider(injector<IPostRepository>()),
  );
}
```

**Đọc kỹ cấu trúc:** `register<KIỂU HỢP ĐỒNG>(() => TẠO RA CÁI GÌ)`

```dart
injector.registerLazySingleton<IPostRepository>(   // khi ai hỏi IPostRepository
  () => PostRepositoryImpl(...),                   // thì đưa cái này
);
```

Đây là **chỗ duy nhất trong toàn app** biết `IPostRepository` thật ra là
`PostRepositoryImpl`.

**Ba kiểu đăng ký:**

| Kiểu | Khi nào tạo object | Dùng cho |
|---|---|---|
| `registerLazySingleton` | Lần đầu có người hỏi, rồi **dùng lại mãi** | Repository, DataSource, DatabaseHelper |
| `registerSingleton` | **Ngay lúc gọi `setDI()`** | Thứ cần sẵn sàng ngay |
| `registerFactory` | **Tạo mới mỗi lần hỏi** | Provider |

> **Vì sao `PostProvider` dùng `Factory` mà không dùng `Singleton`?**
>
> Vì Provider giữ **trạng thái màn hình**. Nếu là singleton, mở lại màn hình sẽ
> thấy trạng thái cũ còn nguyên. Factory đảm bảo mỗi lần tạo màn hình là một
> Provider sạch.

## 3.9 · `presentation/providers/post_provider.dart`

```dart
class PostProvider extends ChangeNotifier {
  final IPostRepository repository;       // ← lại là HỢP ĐỒNG

  List<PostEntity> posts = [];

  PostProvider(this.repository);

  Future<void> loadPosts() async {
    posts = await repository.getPosts();
    notifyListeners();                    // ← báo UI vẽ lại
  }

  Future<void> toggleLike(PostEntity post) async {
    post.isLike = !post.isLike;           // ① đổi trong bộ nhớ TRƯỚC
    await repository.toggleLike(post);    // ② rồi mới ghi database
    notifyListeners();                    // ③ báo UI
  }

  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      await loadPosts();                  // ô search rỗng → tải lại hết
      return;
    }
    posts = await repository.searchPosts(keyword);
    notifyListeners();
  }
}
```

**`extends ChangeNotifier`** cho class này khả năng **phát tín hiệu**.
`notifyListeners()` là tiếng gọi *"ai đang nghe thì vẽ lại đi"*.

**Thứ tự trong `toggleLike` rất đáng chú ý** — xem mục 6.2.

## 3.10 · `presentation/pages/home_page.dart`

```dart
class HomePage extends StatelessWidget {
  final PostProvider provider;            // ← nhận từ bên ngoài

  const HomePage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [Tab(text: 'Home'), Tab(text: 'Favourite')]),
        ),
        body: TabBarView(
          children: [
            // Tab Home: ô search + danh sách đầy đủ
            Column(children: [
              TextField(onChanged: (value) => provider.search(value)),
              Expanded(child: _buildPostList(provider.posts)),
            ]),

            // Tab Favourite: lọc ngay trong UI
            _buildPostList(
              provider.posts.where((post) => post.isLike).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Chú ý:** `HomePage` là **`StatelessWidget`** — nó không tự giữ trạng thái nào.
Toàn bộ trạng thái nằm ở `PostProvider`.

**Tab Favourite lọc bằng Dart, không bằng SQL:**
`provider.posts.where((post) => post.isLike)` — lọc trên danh sách đang có trong
bộ nhớ. Đây là chỗ sinh ra một hành vi lạ, xem mục 6.3.

## 3.11 · `ex05_flow.dart` — nơi mọi thứ khởi động

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!injector.isRegistered<PostProvider>()) {
      setDI();                                    // ① đăng ký công thức
    }

    return ChangeNotifierProvider(
      create: (_) => injector<PostProvider>()..loadPosts(),   // ② lấy + gọi
      child: Builder(
        builder: (context) {
          return MaterialApp(
            home: HomePage(provider: context.watch<PostProvider>()),   // ③
          );
        },
      ),
    );
  }
}
```

**Ba chi tiết quan trọng:**

**① `if (!injector.isRegistered<PostProvider>())`**
Vì `build()` có thể chạy **nhiều lần** (hot reload, xoay màn hình). GetIt sẽ ném
lỗi nếu đăng ký trùng kiểu. Câu `if` này chặn điều đó.

**② `..loadPosts()`**
Dấu `..` là **cascade operator** của Dart. Nó nghĩa là *"gọi `loadPosts()` trên
object vừa tạo, nhưng vẫn trả về chính object đó"*. Viết dài ra thì tương đương:

```dart
create: (_) {
  final provider = injector<PostProvider>();
  provider.loadPosts();
  return provider;      // ← trả về provider, KHÔNG phải kết quả loadPosts()
}
```

**③ `Builder`**
Cần `Builder` vì `context.watch<PostProvider>()` chỉ hoạt động ở **bên dưới**
`ChangeNotifierProvider` trong cây widget. Nếu gọi `context.watch` ngay trong
`MyApp.build`, context đó nằm **trên** Provider nên sẽ không tìm thấy.

---

# Phần 4 — Luồng chạy, ba kịch bản

## Kịch bản A · Mở app lên

```
①  main() chạy
    ↓ runApp(MyApp())
②  MyApp.build()
    ↓ setDI()  →  GetIt GHI CÔNG THỨC (chưa tạo object nào)
③  ChangeNotifierProvider create:
    ↓ injector<PostProvider>()
    ↓ GetIt lắp ráp NGƯỢC TỪ DƯỚI LÊN:
         DatabaseHelper()                      ← tạo trước
         PostDataSourceImpl(DatabaseHelper)    ← rồi tới
         PostRepositoryImpl(IPostDataSource)   ← rồi tới
         PostProvider(IPostRepository)         ← cuối cùng
④  ..loadPosts()
    ↓
⑤  repository.getPosts()          → PostRepositoryImpl
    ↓
⑥  dataSource.getPosts()          → PostDataSourceImpl
    ↓
⑦  databaseHelper.getDatabase()   → mở file adfd05.db
    ↓ lần đầu: onCreate chạy, tạo bảng, seed 3 post
    ↓ db.query('posts')
    ↑ trả về List<Map>: [{'id':1,'title':'Flutter','is_like':0}, ...]
⑧  Repository: Map → PostModel → PostEntity
    ↑ is_like: 0  →  isLike: false
⑨  PostProvider.posts = [PostEntity, PostEntity, PostEntity]
    ↓ notifyListeners()
⑩  HomePage.build() chạy lại  →  ListView hiện 3 post
```

**Điểm đáng nhấn khi trình bày:** bước ③ — GetIt lắp ráp **từ dưới lên**, vì lớp
trên cần lớp dưới làm tham số.

## Kịch bản B · Bấm nút trái tim

```
①  IconButton onPressed  →  provider.toggleLike(post)
②  post.isLike = !post.isLike        ← đổi NGAY trong bộ nhớ
③  repository.toggleLike(post)
④  dataSource.toggleLike(post)
⑤  db.update('posts', {'is_like': post.isLike ? 1 : 0}, where: 'id = ?')
    ↑ true  →  1
⑥  notifyListeners()
⑦  HomePage.build()  →  trái tim đổi màu, tab Favourite cập nhật
```

## Kịch bản C · Gõ vào ô search

```
①  TextField onChanged  →  provider.search('Fl')
②  keyword không rỗng
③  repository.searchPosts('Fl')
④  dataSource.searchPosts('Fl')
⑤  db.query('posts', where: 'title LIKE ?', whereArgs: ['%Fl%'])
    ↑ trả về hàng khớp
⑥  Map → PostModel → PostEntity
⑦  posts = kết quả search
    ↓ notifyListeners()
⑧  ListView chỉ còn post khớp
```

> **`onChanged` chạy mỗi lần gõ một ký tự.** Gõ "Flutter" = 7 lần truy vấn
> database. Xem mục 6.4.

---

# Phần 5 — Bốn khái niệm cốt lõi

## 5.1 · Abstraction (trừu tượng hoá)

**Định nghĩa dễ hiểu:** tách *"làm được gì"* ra khỏi *"làm bằng cách nào"*.

**Ví dụ đời thường:** ổ cắm điện. Bạn cắm sạc vào ổ mà không cần biết điện đến
từ thuỷ điện hay điện mặt trời. Ổ cắm là **hợp đồng**; nhà máy điện là
**implementation**.

Trong Lab 5: `IPostRepository` là ổ cắm, `PostRepositoryImpl` là nhà máy điện.

## 5.2 · Dependency Inversion (đảo ngược phụ thuộc)

**Tên nghe đáng sợ, ý thì đơn giản.**

Bình thường, lớp trên phụ thuộc lớp dưới:

```
PostProvider  →  PostRepositoryImpl  →  SQLite
(phụ thuộc vào class cụ thể)
```

Đảo ngược nghĩa là **cả hai cùng phụ thuộc vào hợp đồng**:

```
PostProvider  →  IPostRepository  ←  PostRepositoryImpl
                  (hợp đồng)
```

Để ý mũi tên bên phải **đi ngược lên**. Đó là chữ "Inversion".

**Lợi ích cụ thể:** `PostProvider` giờ không biết `PostRepositoryImpl` tồn tại.
Thay implementation khác vào, Provider không hay biết gì.

## 5.3 · Dependency Injection (tiêm phụ thuộc)

**Tiêm nghĩa là đưa từ ngoài vào, thay vì tự tạo bên trong.**

```dart
// KHÔNG tiêm — Provider tự tạo, tự trói mình vào class cụ thể
class PostProvider {
  final repository = PostRepositoryImpl(...);   // ✗
}

// CÓ tiêm — nhận từ bên ngoài qua constructor
class PostProvider {
  final IPostRepository repository;
  PostProvider(this.repository);                // ✓
}
```

**GetIt là công cụ tự động hoá việc tiêm đó.** Không có GetIt vẫn tiêm được — chỉ
là phải tự viết đống `new` ở đâu đó.

> **Câu hỏi hay bị vặn:** *"Không dùng GetIt thì sao?"*
>
> **Trả lời:** Vẫn chạy được. Nhưng đống code lắp ráp sẽ nằm trong
> `ex05_flow.dart` hoặc trong màn hình — và lúc đó chỗ đó lại biết hết mọi tầng.
> GetIt gom việc lắp ráp về một file riêng, để không chỗ nào khác phải biết.

## 5.4 · Entity ↔ Model Mapping

**Một dữ liệu, hai cách biểu diễn, cho hai mục đích khác nhau.**

| | Mục đích | Tối ưu cho |
|---|---|---|
| `PostModel` | Nói chuyện với database | Cách database lưu trữ |
| `PostEntity` | Dùng trong logic app | Cách lập trình viên suy nghĩ |

**Phép thử để biết tách đúng chưa:** nếu đổi database mà `PostEntity` phải sửa
→ tách sai. Nếu chỉ `PostModel` sửa → tách đúng.

---

# Phần 6 — Chi tiết tinh vi, để trả lời câu hỏi khó

Đây là phần phân biệt *"đã hiểu"* với *"đọc thuộc"*.

## 6.1 · Vì sao `isLike` không có `final`?

```dart
final int? id;
final String title;
final String content;
bool isLike;          // ← không final
```

Vì `PostProvider.toggleLike` sửa trực tiếp:

```dart
post.isLike = !post.isLike;
```

Nếu `isLike` là `final` thì dòng này không biên dịch được, và phải tạo `PostEntity`
mới thay vì sửa tại chỗ.

> **Nếu thầy hỏi "như vậy có tốt không?"** — trả lời thật: **Entity nên bất biến
> (immutable) mới đúng chuẩn.** Ở đây để mutable cho đơn giản, đổi lại là bất kỳ
> ai cầm `PostEntity` cũng sửa được nó, khó kiểm soát hơn. Đây là đánh đổi có ý
> thức trong phạm vi bài tập.

## 6.2 · `toggleLike` sửa bộ nhớ TRƯỚC, ghi database SAU

```dart
post.isLike = !post.isLike;        // ① bộ nhớ
await repository.toggleLike(post); // ② database
notifyListeners();                 // ③ UI
```

Kiểu này gọi là **optimistic update** — cập nhật lạc quan. Giao diện phản hồi
ngay, không chờ database.

**Được:** người dùng thấy trái tim đổi màu tức thì, cảm giác mượt.

**Mất:** nếu bước ② thất bại, **giao diện đang hiển thị sai**. Không có đoạn code
nào hoàn tác lại bước ①.

> Với SQLite trong máy thì khả năng lỗi rất thấp. Nhưng nếu đây là API qua mạng
> thì đó là lỗi thật — và chính là **cải tiến 1** ở Lab 6.

## 6.3 · Tab Favourite có một hành vi lạ

```dart
provider.posts.where((post) => post.isLike).toList()
```

Nó lọc trên `provider.posts` — tức là **danh sách đang hiện tại**.

**Hệ quả:** nếu bạn gõ search "Dart" rồi chuyển sang tab Favourite, bạn chỉ thấy
các post đã like **trong kết quả search**, không phải toàn bộ post đã like.

> **Nếu thầy phát hiện và hỏi** — thừa nhận thẳng: *"Đúng, vì tab Favourite lọc
> trên state hiện tại của Provider chứ không truy vấn riêng. Muốn đúng thì cần
> thêm một hàm `getLikedPosts()` trong Repository."* Trả lời thế này cho thấy bạn
> hiểu code chứ không chỉ đọc thuộc.

## 6.4 · Search gọi database mỗi lần gõ một ký tự

`onChanged` kích hoạt ở **mỗi lần nhấn phím**. Gõ "Flutter" = 7 truy vấn.

**Cách làm đúng trong app thật:** *debounce* — chờ người dùng ngừng gõ khoảng
300ms rồi mới truy vấn.

Với 3 dòng dữ liệu thì không sao. Với 10.000 dòng thì app sẽ giật.

## 6.5 · `getDatabase()` được gọi ở MỌI thao tác

Mỗi hàm trong `PostDataSourceImpl` đều mở database lại:

```dart
final db = await databaseHelper.getDatabase();
```

**Có tệ không?** Không đến mức tệ — `sqflite` giữ cache kết nối bên trong, nên
lần thứ hai trở đi không mở file thật. Nhưng viết đúng hơn thì nên giữ một
`Database` dùng lại.

## 6.6 · `IPostDataSource.toggleLike` nhận `PostEntity` — hơi lẫn tầng

```dart
abstract class IPostDataSource {
  Future<List<Map<String, dynamic>>> getPosts();   // trả Map thô
  Future<void> toggleLike(PostEntity post);        // nhưng NHẬN Entity
}
```

**Không nhất quán.** Data Source lẽ ra chỉ nên nói chuyện bằng dữ liệu thô. Nhận
`PostEntity` nghĩa là tầng Data đang biết tới tầng Domain.

> Nhóm **không sửa** ở Lab 5 vì đang khớp đề bài của thầy. Nhưng ở **Lab 6 thì có
> sửa** — `IContactDataSource` chỉ nhận và trả `Map`. Nếu thầy hỏi, đây là câu
> trả lời cho thấy nhóm đọc code kỹ tới mức nhận ra điểm chưa nhất quán.

## 6.7 · Cú lật một dòng hoạt động được nhờ đâu

```dart
const bool useInMemoryDataSource = false;   // → true
```

Đổi được là nhờ **ba điều kiện cùng đúng**:

1. `PostRepositoryImpl` phụ thuộc `IPostDataSource`, không phụ thuộc class cụ thể
2. `InMemoryPostDataSource` cũng `implements IPostDataSource` — cùng hợp đồng
3. Nơi quyết định nằm ở `injection.dart`, tách khỏi nơi sử dụng

**Thiếu bất kỳ điều nào là cú lật không chạy.** Nếu thầy hỏi "chứng minh đi", đây
là ba ý cần nói.

---

# Phần 7 — Bộ câu hỏi tự kiểm

Trả lời trôi chảy **không nhìn tài liệu** thì mới thật sự nắm.

| # | Câu hỏi | Mục tham khảo |
|---|---|---|
| 1 | `abstract class` khác class thường chỗ nào? | 3.2 |
| 2 | Vì sao `PostEntity` không có dòng `import` nào? | 2 |
| 3 | `PostModel` và `PostEntity` khác nhau chỗ nào, vì sao cần cả hai? | 3.3, 5.4 |
| 4 | SQLite lưu `true`/`false` bằng cách nào? | 3.3 |
| 5 | `registerLazySingleton` khác `registerFactory` chỗ nào? | 3.8 |
| 6 | Vì sao `PostProvider` dùng Factory chứ không Singleton? | 3.8 |
| 7 | GetIt lắp ráp object theo thứ tự nào? | 4 kịch bản A |
| 8 | `notifyListeners()` làm gì? | 3.9 |
| 9 | Dấu `..` trong `..loadPosts()` nghĩa là gì? | 3.11 |
| 10 | Vì sao cần `Builder` trong `ex05_flow.dart`? | 3.11 |
| 11 | Đổi Data Source mà Provider không sửa — vì sao? | 6.7 |
| 12 | `isLike` sao không có `final`? | 6.1 |
| 13 | Bấm like xong mà ghi database lỗi thì sao? | 6.2 |
| 14 | Gõ search 7 ký tự thì gọi database mấy lần? | 6.4 |
| 15 | `onCreate` chạy mấy lần? | 3.7 |

## Cách luyện

1. Đọc hết tài liệu này một lượt
2. Che đi, tự trả lời 15 câu trên, **nói thành tiếng**
3. Câu nào ấp úng → quay lại đọc mục tương ứng
4. Nhờ Tuấn hỏi vặn chéo trước buổi tổng duyệt

> **Mẹo:** câu trả lời tốt nhất luôn có dạng **"vì nếu không thế thì sẽ gặp vấn
> đề X"**. Ví dụ đừng nói *"tách Model và Entity cho đúng kiến trúc"* — hãy nói
> *"nếu không tách thì cả app phải nhớ 1 nghĩa là đã like, và ngày đổi sang API
> phải sửa khắp nơi"*.
