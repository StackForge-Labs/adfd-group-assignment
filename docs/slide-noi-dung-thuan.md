# Nội dung thuần để dựng slide — 24 slide

> **File này CHỈ chứa thứ hiện lên màn hình.** Không có lời thoại, không có ghi
> chú đạo diễn. Dùng làm đầu vào cho Canva hoặc bất kỳ công cụ tạo slide nào.
>
> Muốn biết **nói gì** ở mỗi slide → đọc `docs/slide-thuyet-trinh-v2.md`.

Sơ đồ nằm ở `docs/assets/*.svg` · Ảnh chụp thật nằm ở `docs/assets/*.png`

---

## Slide 1 — Bìa

**ADFD — Lab 5 & Lab 6**
Architecture & REST API

Nhóm E — Mai Trung Hậu · Phạm Hoàng Tuấn · Lê Minh Trí · Lâm Hoàng An

GVHD: Lê Thanh Nhân

---

## Slide 2 — Mục lục

| | Nội dung | Trình bày |
|---|---|---|
| 1 | Lab 5 — Vì sao phải tách tầng | Hậu |
| 2 | Lab 5 — Nối các mảnh và chứng minh | Tuấn |
| 3 | Lab 6 — Backend và đường ống dữ liệu | Trí |
| 4 | Lab 6 — Ứng dụng hoàn chỉnh | An |
| 5 | Demo trực tiếp | Cả nhóm |

---

## Slide 3 — Hai lab, hai câu hỏi

| | **Lab 5** | **Lab 6** |
|---|---|---|
| Câu hỏi | Sắp xếp code sao cho khỏi rối | Nói chuyện với server thế nào |
| Dữ liệu ở đâu | SQLite — trong máy | MySQL — trên server |
| Có backend | Không | Có — Spring Boot |

---

## Slide 4 — Câu hỏi mở đầu

# Giả sử mai app phải đổi từ SQLite sang gọi API.

# Theo các bạn, phải sửa bao nhiêu file?

*(slide chỉ có hai dòng này, để trống nhiều — cho lớp có thời gian nghĩ)*

---

## Slide 5 — Flow 1: Tạo hợp đồng trước

```dart
abstract class IPostRepository {
  Future<List<PostEntity>> getPosts();
}
```

🖼️ **Sơ đồ:** `assets/so-do-1-hop-dong.svg`

---

## Slide 6 — Flow 2: Thay ruột, tầng trên không đổi

```dart
class PostRepositoryImpl implements IPostRepository {
  Future<List<PostEntity>> getPosts() async {
    final db = await databaseHelper.getDatabase();
    return db.query('posts');
  }
}
```

🖼️ **Sơ đồ:** `assets/so-do-2-thay-ruot.svg`

---

## Slide 7 — Flow 3: `PostModel` làm người phiên dịch

> **SQLite không có kiểu `true` / `false`** — nó chỉ lưu số `1` và `0`

```dart
class PostModel {
  final int isLike;

  PostEntity toEntity() => PostEntity(
    isLike: isLike == 1,
  );
}
```

🖼️ **Sơ đồ:** `assets/so-do-3-mapping.svg`

---

## Slide 8 — Ai nối các mảnh?

```dart
final helper     = DatabaseHelper();
final dataSource = PostDataSourceImpl(helper);
final repository = PostRepositoryImpl(dataSource);
final provider   = PostProvider(repository);
```

> Ai viết những dòng này, và viết ở đâu?

---

## Slide 9 — Flow 4: GetIt

```dart
void setDI() {
  injector.registerLazySingleton<IPostRepository>(
    () => PostRepositoryImpl(injector<IPostDataSource>()),
  );

  injector.registerFactory<PostProvider>(
    () => PostProvider(injector<IPostRepository>()),
  );
}
```

> Một file duy nhất biết "ai tạo ra ai" — `core/di/injection.dart`
> `LazySingleton` tạo **một lần** · `Factory` tạo **mới mỗi lần**

---

## Slide 10 — Flow 5: Chuỗi phụ thuộc hoàn chỉnh

🖼️ **Sơ đồ:** `assets/so-do-4-chuoi-phu-thuoc.svg` — *vẽ to, chiếm gần hết slide*

> Hai mũi tên đi ngược lên = **Dependency Inversion**

---

## Slide 11 — Câu trả lời

```dart
// adfd05_architecture/lib/ex05/core/di/injection.dart
const bool useInMemoryDataSource = false;   // → true
```

# Một dòng.

---

## Slide 12 — Bằng chứng

🖼️ **Hai ảnh đặt cạnh nhau:**

| `assets/lab5-sqlite.png` | `assets/lab5-inmemory.png` |
|---|---|
| `false` — dữ liệu từ **SQLite** | `true` — dữ liệu từ **RAM** |

*Giữa hai ảnh: mũi tên + chữ **"đổi 1 dòng"***

> Không đổi một dòng nào:
> `PostRepositoryImpl` · `PostProvider` · `HomePage` · `PostEntity` · `PostModel`

---

## Slide 13 — Lab 6 dùng lại kiến trúc, đổi tầng đáy

🖼️ **Sơ đồ:** `assets/so-do-5-lab6-kien-truc.svg`

---

## Slide 14 — 5 endpoint

| Method | Endpoint | Chức năng |
|---|---|---|
| GET | `/api/contacts` | Lấy tất cả |
| POST | `/api/contacts` | Tạo mới |
| PUT | `/api/contacts/{id}` | Cập nhật |
| DELETE | `/api/contacts/{id}` | Xoá |
| GET | `/api/contacts/search?keyword=` | Tìm theo tên |

---

## Slide 15 — Từ JSON tới Model

🖼️ **Sơ đồ:** `assets/so-do-6-json-model.svg`

```dart
Uri.http('10.0.2.2:8082', '/api/contacts')   // 10.0.2.2 = máy host
```

---

## Slide 16 — Provider giữ trạng thái API

```dart
class ContactProvider extends ChangeNotifier {
  List<ContactEntity> contacts = [];
  bool loading = true;

  Future<void> loadContacts() async {
    contacts = await repository.getContacts();
    loading = false;
    notifyListeners();
  }
}
```

---

## Slide 17 — Ứng dụng hoàn chỉnh

🖼️ **Ảnh:** `assets/lab6-list.png` *(chiếm nửa slide)*

Xem · Thêm · Sửa · Xoá · Tìm kiếm

---

## Slide 18 — Nhóm áp kiến trúc Lab 5 vào Lab 6

| Đề bài cho | Nhóm em làm |
|---|---|
| `models/` `pages/` | `domain/` `data/` |
| `providers/` `services/` | `presentation/` `core/` |
| **0 interface** | **2 interface** + GetIt |

---

## Slide 19 — Cải tiến: app treo spinner vĩnh viễn

```dart
bool loading = true;

if (response.statusCode == 200) {
  loading = false;          // CHỈ set false ở đây
}
// không có else, không có try/catch
```

🖼️ **Sơ đồ:** `assets/so-do-7-ba-trang-thai.svg`

---

## Slide 20 — Kết quả

🖼️ **Hai ảnh đặt cạnh nhau:**

| `assets/lab6-error.png` | `assets/lab6-retry.png` |
|---|---|
| Backend tắt → báo lỗi rõ ràng | Bấm **Thử lại** → danh sách hiện ra |

---

## Slide 21 — Một cái bẫy chỉ Flutter mới có

```dart
await context.read<ContactProvider>().addContact(contact);

if (!context.mounted) return;

Navigator.pop(context);
```

---

## Slide 22 — Demo

# DEMO

1. Danh sách lấy từ MySQL thật
2. Thêm contact → dòng mới xuất hiện trong database
3. Search · Sửa · Xoá
4. Tắt backend → màn báo lỗi → bật lại → **Thử lại**
5. Lab 5 — **cú lật một dòng**

---

## Slide 23 — Tài liệu tham khảo

**Tài liệu chính thống**
- Flutter — https://docs.flutter.dev
- Dart — https://dart.dev/guides
- Spring Boot — https://docs.spring.io/spring-boot/index.html
- MySQL — https://dev.mysql.com/doc

**Thư viện** — provider · get_it · sqflite · http — https://pub.dev

**Mã nguồn nhóm**
- https://github.com/StackForge-Labs/adfd-group-assignment

---

## Slide 24 — Cảm ơn

# Cảm ơn thầy và các bạn đã lắng nghe

**Nhóm E** — Hậu · Tuấn · Trí · An

---
---

# Tài nguyên cần chèn

| File | Slide | Loại |
|---|---|---|
| `so-do-1-hop-dong.svg` | 5 | sơ đồ |
| `so-do-2-thay-ruot.svg` | 6 | sơ đồ |
| `so-do-3-mapping.svg` | 7 | sơ đồ |
| `so-do-4-chuoi-phu-thuoc.svg` | 10 | sơ đồ — **quan trọng nhất** |
| `so-do-5-lab6-kien-truc.svg` | 13 | sơ đồ |
| `so-do-6-json-model.svg` | 15 | sơ đồ |
| `so-do-7-ba-trang-thai.svg` | 19 | sơ đồ |
| `lab5-sqlite.png` | 12 | ảnh chụp |
| `lab5-inmemory.png` | 12 | ảnh chụp |
| `lab6-list.png` | 17 | ảnh chụp |
| `lab6-error.png` | 20 | ảnh chụp |
| `lab6-retry.png` | 20 | ảnh chụp |
