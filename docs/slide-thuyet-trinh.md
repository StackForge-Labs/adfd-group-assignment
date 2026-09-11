# Nội dung slide thuyết trình — Lab 5 & Lab 6

Tài liệu nguồn để **Hậu và An** dựng slide trên Canva. Tuấn và Trí đọc để góp ý.

- **39 slide / 40 phút** — trung bình ~1 phút một slide
- Ảnh chụp thật nằm trong `docs/assets/`
- Ngôn ngữ: tiếng Việt, thuật ngữ kỹ thuật giữ nguyên tiếng Anh

## Cách đọc tài liệu này

Mỗi slide có bốn phần:

| Phần | Nghĩa |
|---|---|
| **Nội dung slide** | Chữ và code **chiếu lên màn hình** |
| **Hình cần vẽ** | Mô tả sơ đồ để dựng trên Canva |
| **Người nói** | Lời thoại gợi ý — **đừng đọc y nguyên**, nói bằng lời của mình |
| `[Tên · giây]` | Ai nói và bao lâu |

## Phân bổ thời gian

| Phần | Người | Thời lượng |
|---|---|---|
| Mở đầu | Hậu | 2:00 |
| 5A | Hậu | 8:00 |
| 5B | Tuấn | 8:40 |
| 6A | Trí | 9:10 |
| 6B | An | **10:10** |
| Demo + kết | An chạy, Hậu chốt | 8:00 |
| **Tổng** | | **46:00** |

> ⚠️ **Hai điều cần lưu ý.**
>
> **1. Tổng 46 phút, không phải 40.** Và nội dung nói bao giờ cũng dài hơn dự
> tính — chuyển slide, thầy hỏi xen vào, máy trục trặc. Nếu thầy giới hạn cứng
> 40 phút thì cắt theo danh sách ở [phụ lục cuối tài liệu](#nếu-bị-rút-ngắn-thời-gian),
> bỏ được khoảng 6 phút.
>
> **2. An đang nặng nhất** — 10:10 phần nói, cộng thêm chạy demo 6 phút. Nếu
> tổng duyệt thấy quá tải, chuyển slide 33-34 (cải tiến 2) sang Trí, vì phần
> encode URL liên quan trực tiếp tới đường ống dữ liệu mà Trí phụ trách.

## Nguyên tắc chung

- **Không slide nào quá 5 dòng chữ.** Slide là chỗ dựa, không phải bài đọc.
- Code chiếu lên **tối đa 10 dòng**, chỉ phần đang nói tới.
- Tỷ lệ nhắm tới: **60% sơ đồ · 25% code · 15% ảnh thật**.
- Cả 39 slide dùng **chung một bộ màu và một mẫu** — nếu không sẽ lộ ra bốn người làm rời rạc.

---
---

# MỞ ĐẦU — Hậu · 2 phút

---

### Slide 1 — Bìa `[Hậu · 20 giây]`

**Nội dung slide:**

> **ADFD — Lab 5 & Lab 6**
> Architecture & REST API
>
> Nhóm E — Mai Trung Hậu · Phạm Hoàng Tuấn · Lê Minh Trí · Lâm Hoàng An
>
> GVHD: Lê Thanh Nhân

**Hình cần vẽ:** logo môn hoặc hình nền đơn giản. Đừng rối.

**Người nói:** chào, giới thiệu nhóm và hai lab phụ trách.

---

### Slide 2 — Mục lục `[Hậu · 30 giây]`

**Nội dung slide:**

| | Nội dung | Người trình bày |
|---|---|---|
| 1 | Lab 5 — Vì sao phải tách tầng | Hậu |
| 2 | Lab 5 — Nối các mảnh và chứng minh | Tuấn |
| 3 | Lab 6 — Backend và đường ống dữ liệu | Trí |
| 4 | Lab 6 — Ứng dụng hoàn chỉnh | An |
| 5 | Demo trực tiếp | Cả nhóm |

**Người nói:** *"Bốn phần, mỗi bạn một phần, và cuối buổi nhóm em sẽ demo cả hai sản phẩm chạy thật."*

---

### Slide 3 — Hai lab trả lời hai câu hỏi khác nhau `[Hậu · 70 giây]`

**Nội dung slide:**

| | **Lab 5** | **Lab 6** |
|---|---|---|
| Câu hỏi | *Sắp xếp code sao cho khỏi rối* | *Nói chuyện với server thế nào* |
| Dữ liệu ở đâu | SQLite — **trong máy** | MySQL — **trên server** |
| Có backend | Không | Có — Spring Boot |

**Người nói:** *"Các nhóm trước đã trình bày về widget, SQLite, cách tổ chức code và Provider. Hai lab của nhóm em đi tiếp từ đó. Lab 5 hỏi 'sắp xếp code sao cho khỏi rối', Lab 6 hỏi 'làm sao nói chuyện với server'."*

> **Lưu ý:** lớp đã nghe Lab 1-4 ở các buổi trước, nên **không cần nhắc lại** Provider hay SQLite là gì. Nhắc lại là phí thời gian.

---
---

# PHẦN 5A — Vì sao phải tách tầng · Hậu · 8 phút

---

### Slide 4 — Một câu hỏi trước khi bắt đầu `[Hậu · 60 giây]`

**Nội dung slide:**

> ### Giả sử mai app phải đổi từ SQLite sang gọi API.
> ### Theo các bạn, phải sửa bao nhiêu file?

**Hình cần vẽ:** một dấu hỏi lớn, hoặc hình app với mũi tên đi xuống SQLite rồi một mũi tên khác đi lên đám mây.

**Người nói:** hỏi thật, **chờ vài giây cho lớp suy nghĩ**. Rồi nói: *"Giữ câu trả lời của mình trong đầu. Cuối phần của bạn Tuấn, chúng ta sẽ biết con số thật."*

> Đây là **câu hỏi xuyên suốt** của cả Lab 5. Đừng trả lời ngay.

---

### Slide 5 — Flow 1: Tạo hợp đồng trước `[Hậu · 70 giây]`

**Nội dung slide:**

```dart
abstract class IPostRepository {
  Future<List<PostEntity>> getPosts();
}
```

> Chỉ **khai báo**, không làm gì cả.

**Người nói:** *"Flow 1 chưa có database. Việc đầu tiên là viết ra một bản hợp đồng: 'sẽ có ai đó cung cấp danh sách Post'. Ai làm, làm bằng cách nào — chưa quan tâm."*

Với lớp đã học Java: *"Giống interface trong Java."*

---

### Slide 6 — Provider chỉ biết hợp đồng `[Hậu · 60 giây]`

**Hình cần vẽ:**

```
HomePage  →  PostProvider  →  IPostRepository
                                    ↑
                          InMemoryPostRepository
                              (dữ liệu giả)
```

Mũi tên `↑` **tô màu khác** — đây là chi tiết quan trọng nhất của cả sơ đồ.

**Người nói:** *"Để ý mũi tên này đi ngược lên. `PostProvider` không gọi xuống class cụ thể, mà class cụ thể tự cắm vào hợp đồng. Cả Lab 5 xoay quanh mũi tên đó."*

---

### Slide 7 — Flow 2: Thay ruột bằng SQLite `[Hậu · 70 giây]`

**Nội dung slide:**

```dart
class PostRepositoryImpl implements IPostRepository {
  @override
  Future<List<PostEntity>> getPosts() async {
    final db = await databaseHelper.getDatabase();
    return db.query('posts');        // SQLite thật
  }
}
```

**Người nói:** *"Flow 2 vứt dữ liệu giả đi, thay bằng SQLite thật."*

---

### Slide 8 — Và tầng trên không đổi một dòng nào `[Hậu · 70 giây]`

**Hình cần vẽ:** cùng sơ đồ slide 6, nhưng nhánh dưới đổi từ `InMemoryPostRepository` thành `PostRepositoryImpl → SQLite`. Phần trên (`HomePage`, `PostProvider`, `IPostRepository`) **tô xám và ghi "KHÔNG ĐỔI"**.

**Người nói:** *"Đổi từ dữ liệu giả sang database thật — `HomePage` và `PostProvider` không phải sửa một dòng nào. Đó là lợi ích đầu tiên nhìn thấy được."*

---

### Slide 9 — Flow 3: Một vấn đề nhỏ mà khó chịu `[Hậu · 80 giây]`

**Nội dung slide:**

> ### SQLite không có kiểu `true` / `false`
> Nó chỉ lưu số **`1`** và **`0`**

| | Giá trị |
|---|---|
| Trong database | `is_like = 1` |
| App muốn dùng | `isLike = true` |

**Người nói:** *"Nếu để nguyên số 1 và 0 chạy khắp app, thì mọi chỗ đều phải nhớ '1 nghĩa là đã like'. Hạn chế của database rò rỉ ra toàn bộ chương trình."*

---

### Slide 10 — `PostModel` làm người phiên dịch `[Hậu · 70 giây]`

**Nội dung slide:**

```dart
class PostModel {
  final int isLike;                    // 1 / 0 — kiểu của SQLite

  PostEntity toEntity() => PostEntity(
    isLike: isLike == 1,               // → true / false
  );
}
```

**Hình cần vẽ:**

```
SQLite        PostModel        PostEntity        UI
is_like=1  →  isLike: 1    →   isLike: true  →   ❤️
              (tầng data)      (tầng domain)
```

**Người nói:** *"`PostModel` nhốt cái xấu xí của database lại trong tầng data. `PostEntity` sạch sẽ, và phần còn lại của app không cần biết SQLite lưu kiểu gì."*

**Câu chuyển:** *"Đến đây chúng ta có bốn tầng tách bạch. Nhưng ai là người nối chúng lại với nhau? Mời bạn Tuấn."*

---
---

# PHẦN 5B — Nối các mảnh và chứng minh · Tuấn · 8 phút

---

### Slide 11 — Vấn đề: ai nối các mảnh? `[Tuấn · 60 giây]`

**Nội dung slide:**

```dart
// Ai viết những dòng này, và viết ở đâu?
final helper     = DatabaseHelper();
final dataSource = PostDataSourceImpl(helper);
final repository = PostRepositoryImpl(dataSource);
final provider   = PostProvider(repository);
```

**Người nói:** *"Bốn tầng tách bạch rồi, nhưng cuối cùng vẫn phải có ai đó ghép chúng lại. Nếu viết đống này ngay trong màn hình thì màn hình lại biết hết mọi tầng — công tách ra thành vô nghĩa."*

---

### Slide 12 — Flow 4: GetIt `[Tuấn · 80 giây]`

**Nội dung slide:**

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

**Người nói:** *"GetIt không phải để đỡ phải gõ `new`. Nó tách **nơi quyết định dùng implementation nào** ra khỏi **nơi sử dụng nó**."*

---

### Slide 13 — `setDI()` chưa tạo gì cả `[Tuấn · 60 giây]`

**Nội dung slide:**

| | Khi nào tạo object |
|---|---|
| `registerLazySingleton` | **Một lần duy nhất**, lần đầu có người hỏi tới |
| `registerFactory` | **Mới mỗi lần** được hỏi |

**Người nói:** *"`setDI()` chỉ ghi công thức, chưa tạo gì. Object thật ra đời khi có ai đó hỏi tới — đó là nghĩa của chữ Lazy."*

> Câu này thầy hay hỏi vặn. Chuẩn bị kỹ.

---

### Slide 14 — Flow 5: Chuỗi hoàn chỉnh `[Tuấn · 80 giây]`

**Hình cần vẽ:** sơ đồ trung tâm của cả bài, vẽ to và rõ:

```
HomePage  →  PostProvider  →  IPostRepository
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
```

**Hai mũi tên `↑` tô màu nổi bật.**

**Người nói:** *"Flow 5 tách nốt phần chạy SQL ra sau một hợp đồng thứ hai. Hai mũi tên đi ngược lên này có tên riêng: **Dependency Inversion** — đảo ngược phụ thuộc."*

---

### Slide 15 — Search `[Tuấn · 40 giây]`

**Nội dung slide:**

```dart
Future<List<PostEntity>> searchPosts(String keyword);
```

> Thêm một dòng vào hợp đồng — mọi tầng bên dưới tự biết phải làm gì.

**Người nói:** ngắn gọn, đây là slide đệm trước cao trào.

---

### Slide 16 — Câu hỏi đầu buổi, giờ trả lời được `[Tuấn · 70 giây]`

**Nội dung slide:**

```dart
// adfd05_architecture/lib/ex05/core/di/injection.dart
const bool useInMemoryDataSource = false;   // ← đổi thành true
```

> ### Một dòng.

**Người nói:** *"Đầu buổi bạn Hậu hỏi: đổi nguồn dữ liệu thì phải sửa bao nhiêu file? Câu trả lời là — **một dòng, trong một file**."*

---

### Slide 17 — Bằng chứng `[Tuấn · 80 giây]`

**Nội dung slide:** hai ảnh chụp thật **đặt cạnh nhau**, cùng kích thước.

| `docs/assets/lab5-sqlite.png` | `docs/assets/lab5-inmemory.png` |
|---|---|
| `useInMemoryDataSource = false` | `useInMemoryDataSource = true` |
| Dữ liệu từ **SQLite** | Dữ liệu từ **RAM** |

**Hình cần vẽ:** hai ảnh song song, bên dưới mỗi ảnh một nhãn. Giữa hai ảnh vẽ mũi tên và chữ **"đổi 1 dòng"**.

**Người nói:** *"Cùng một giao diện. Cùng tính năng — Read, Like, Search đều chạy. Chỉ khác nguồn dữ liệu. Và để ý trái tim đỏ ở ảnh bên phải: mapping Model sang Entity vẫn hoạt động nguyên vẹn qua nguồn mới."*

> Đây là **đỉnh của cả buổi**. Nói chậm, để lớp nhìn kỹ hai ảnh.

---

### Slide 18 — Những file KHÔNG phải sửa `[Tuấn · 50 giây]`

**Nội dung slide:**

> ### Không đổi một dòng nào:
> `PostRepositoryImpl` · `PostProvider` · `HomePage` · `PostEntity` · `PostModel`

**Người nói:** *"Vì tất cả chúng chỉ phụ thuộc vào hợp đồng, không phụ thuộc vào class cụ thể."*

**Câu chuyển:** *"Kiến trúc này nhóm em không chỉ dùng cho Lab 5. Lab 6 gọi API thật từ server, và dùng lại đúng khung vừa rồi. Mời bạn Trí."*

---
---

# PHẦN 6A — Backend và đường ống dữ liệu · Trí · 8 phút

---

### Slide 19 — Lab 6 dùng lại kiến trúc vừa rồi `[Trí · 40 giây]`

**Hình cần vẽ:** đúng sơ đồ slide 14, nhưng đổi tầng đáy:

```
...  →  IContactDataSource
              ↑
      ContactDataSourceImpl
              ↓
          ApiClient  →  HTTP  →  Spring Boot  →  MySQL
```

**Người nói:** *"Khung y hệt Lab 5, chỉ khác tầng cuối: thay vì SQLite trong máy thì là server thật. Chi tiết bạn An sẽ nói. Phần em là dữ liệu đi từ database lên tới Model."*

---

### Slide 20 — Backend Spring Boot `[Trí · 70 giây]`

**Hình cần vẽ:**

```
Controller  →  Service  →  Repository  →  JPA  →  MySQL
```

**Nội dung slide:** một dòng nhấn mạnh — *Cấu trúc quen thuộc, lớp mình đã học*

**Người nói:** nói nhanh, đây là phần cả lớp đã biết. **Đừng dừng lâu.**

---

### Slide 21 — 5 endpoint `[Trí · 60 giây]`

**Nội dung slide:**

| Method | Endpoint | Chức năng |
|---|---|---|
| GET | `/api/contacts` | Lấy tất cả |
| POST | `/api/contacts` | Tạo mới |
| PUT | `/api/contacts/{id}` | Cập nhật |
| DELETE | `/api/contacts/{id}` | Xoá |
| GET | `/api/contacts/search?keyword=` | Tìm theo tên |

---

### Slide 22 — Nhóm đổi SQL Server sang MySQL `[Trí · 80 giây]`

**Nội dung slide:**

```diff
- <artifactId>mssql-jdbc</artifactId>
+ <artifactId>mysql-connector-j</artifactId>
```

> ### Code Java: **không đổi một dòng nào**

**Người nói:** *"Đề bài dùng SQL Server, thầy cho phép chọn tự do nên nhóm em dùng MySQL. Toàn bộ thay đổi là hai dòng: driver trong `pom.xml` và connection string. Entity, Repository, Service, Controller — không đụng tới. Vì JPA đã che hết khác biệt giữa hai hệ quản trị."*

---

### Slide 23 — Flow 1: Flutter gọi HTTP GET `[Trí · 60 giây]`

**Nội dung slide:**

```dart
final response = await http.get(
  Uri.http('10.0.2.2:8082', '/api/contacts'),
);
```

> `10.0.2.2` — địa chỉ đặc biệt để **Android emulator** trỏ về máy tính

**Người nói:** giải thích `10.0.2.2`, vì đây là chỗ ai mới học cũng vấp.

---

### Slide 24 — Flow 2: JSON thành Model `[Trí · 80 giây]`

**Hình cần vẽ:** chuỗi biến đổi, vẽ ngang, mỗi bước một hộp:

```
Server  →  chuỗi JSON  →  Map  →  ContactModel  →  UI
                                       ↑
                              ContactModel.fromJson()
```

Và chiều ngược lại bên dưới:

```
ContactModel  →  toJson()  →  chuỗi JSON  →  gửi lên server
```

**Người nói:** *"Flow 2 tồn tại chỉ để làm cho chiều ngược lại — Model thành JSON — hiện lên màn hình được. Nó biến một khái niệm trừu tượng thành thứ nhìn thấy."*

---

### Slide 25 — Cải tiến: nhóm tìm ra một lỗi trong đề bài `[Trí · 80 giây]`

**Nội dung slide:**

```
POST /api/contacts   {}

→ 200 OK
  {"id":10, "name":null, "phone":null, ...}
```

> ### Tạo thành công một Contact **rỗng hoàn toàn**
> Trong khi script database của thầy ghi `name` và `phone` là `not null`

**Người nói:** *"Nhóm em thử gửi một request rỗng lên. Đáng lẽ phải bị từ chối, nhưng nó tạo thành công."*

---

### Slide 26 — Nguyên nhân và cách sửa `[Trí · 80 giây]`

**Nội dung slide:**

```java
// Trước — không có ràng buộc nào
private String name;

// Sau
@Column(length = 100, nullable = false)
private String name;
```

**Nguyên nhân:** entity thiếu `@Column`, cộng với `ddl-auto=update` → Hibernate lấy mặc định của nó và **ghi đè lên schema**.

**Người nói:** *"Đây không phải hậu quả của việc đổi sang MySQL — hành vi này của Hibernate không phụ thuộc hệ quản trị. Sau khi thêm `@Column`, request rỗng bị từ chối đúng như đề bài quy định."*

**Câu chuyển:** *"Dữ liệu đã về tới Model. Giờ làm sao đưa nó lên màn hình và cho người dùng thao tác? Mời bạn An."*

---
---

# PHẦN 6B — Ứng dụng hoàn chỉnh · An · 8 phút

---

### Slide 27 — Flow 3: Provider giữ trạng thái API `[An · 70 giây]`

**Nội dung slide:**

```dart
class ContactProvider extends ChangeNotifier {
  List<ContactEntity> contacts = [];
  bool loading = true;

  Future<void> loadContacts() async {
    contacts = await repository.getContacts();
    loading = false;
    notifyListeners();        // ← báo cho UI vẽ lại
  }
}
```

**Người nói:** *"UI không tự biết dữ liệu đã về. `notifyListeners()` là tiếng gọi, và mọi widget đang lắng nghe sẽ tự chạy lại `build()`."*

---

### Slide 28 — Flow 4: CRUD đầy đủ `[An · 60 giây]`

**Nội dung slide:** ảnh `docs/assets/lab6-list.png` chiếm nửa slide, bên cạnh là danh sách chức năng:

> Xem · Thêm · Sửa · Xoá · Tìm kiếm

**Người nói:** giới thiệu nhanh, vì cuối buổi sẽ demo thật.

---

### Slide 29 — Nhóm áp kiến trúc Lab 5 vào Lab 6 `[An · 80 giây]`

**Hình cần vẽ:** hai cột so sánh.

| Đề bài cho | Nhóm em làm |
|---|---|
| `models/` | `domain/` `data/` `presentation/` `core/` |
| `pages/` | + `IContactRepository` |
| `providers/` | + `IContactDataSource` |
| `services/` | + GetIt |
| **0 interface** | **2 interface** |

**Người nói:** *"Thầy cố tình để Lab 6 đơn giản vì mỗi lab dạy một thứ. Nhưng nhóm em muốn cho thấy đã áp dụng được bài học của Lab 3 và Lab 5 sang bài toán khác. Kết quả: giờ muốn đổi Lab 6 từ REST API sang SQLite cũng chỉ tốn một dòng — y như cú lật bạn Tuấn vừa demo."*

---

### Slide 30 — Cải tiến: app treo spinner vĩnh viễn `[An · 80 giây]`

**Nội dung slide:**

```dart
bool loading = true;              // khởi tạo là true

if (response.statusCode == 200) {
  loading = false;                // CHỈ set false ở đây
  notifyListeners();
}
// không có else, không có try/catch
```

> Backend chết → `http.get` ném exception → **`loading` mãi mãi là `true`**

**Người nói:** *"Nhóm em thử tắt backend. App quay spinner mãi không dừng."*

---

### Slide 31 — Ba trạng thái thay vì hai `[An · 70 giây]`

**Hình cần vẽ:**

```
            gọi API
               ↓
    ┌──────────┼──────────┐
    ↓          ↓          ↓
 thành công  lỗi HTTP  mất mạng
    ↓          ↓          ↓
 contacts    error      error
    └──────────┼──────────┘
               ↓
            finally
               ↓
       loading = false     ← luôn chạy
```

**Người nói:** *"Bản gốc chỉ có hai trạng thái: đang tải và có dữ liệu. Thiếu mất trạng thái hỏng. Nhóm em thêm `error`, và quan trọng nhất là tắt `loading` trong khối `finally` — khối này chạy trong mọi trường hợp, không còn đường nào thoát ra mà spinner vẫn quay."*

---

### Slide 32 — Kết quả `[An · 60 giây]`

**Nội dung slide:** hai ảnh cạnh nhau.

| `docs/assets/lab6-error.png` | `docs/assets/lab6-retry.png` |
|---|---|
| Backend tắt → báo lỗi rõ ràng | Bấm **Thử lại** → danh sách hiện ra |

**Người nói:** *"Thay vì spinner quay mãi, app báo đúng hai nguyên nhân thật và có nút Thử lại — không cần tắt mở app."*

---

### Slide 33 — Cải tiến: search hỏng với ký tự đặc biệt `[An · 70 giây]`

**Nội dung slide:**

| Gõ vào ô search | Server nhận được |
|---|---|
| `John Smith` | `John Smith` ✅ |
| `Nguyễn Văn` | `Nguyễn Văn` ✅ |
| `A&B` | `A` ❌ |
| `C#1` | `C` ❌ |

**Người nói:** *"Dấu cách và tiếng Việt thì không sao. Nhưng `A&B` bị cắt còn `A` — và phần `&B` biến thành một query param khác. Đó là lỗ hổng query injection."*

---

### Slide 34 — Sửa bằng `Uri.http` `[An · 50 giây]`

**Nội dung slide:**

```dart
// Trước — nối chuỗi
Uri.parse('...?keyword=$keyword')

// Sau — để Dart tự encode
Uri.http(authority, path, {'keyword': keyword})
```

---

### Slide 35 — Một cái bẫy chỉ Flutter mới có `[An · 70 giây]`

**Nội dung slide:**

```dart
await context.read<ContactProvider>().addContact(contact);

if (!context.mounted) return;     // ← bắt buộc

Navigator.pop(context);
```

**Người nói:** *"Sau `await`, widget có thể đã bị huỷ — người dùng bấm back trong lúc chờ mạng. Dùng `context` lúc đó là crash. Lab 5 không gặp vì không có `await` nằm giữa thao tác người dùng và điều hướng."*

---
---

# DEMO & KẾT — 8 phút

---

### Slide 36 — Demo trực tiếp `[An chạy · cả nhóm trả lời · 6 phút]`

**Nội dung slide:** chỉ một chữ **DEMO** lớn, kèm checklist nhỏ để nhóm bám theo:

> 1. Danh sách lấy từ MySQL thật *(mở phpMyAdmin song song)*
> 2. Thêm contact → F5 phpMyAdmin → dòng mới xuất hiện
> 3. Search · Sửa · Xoá
> 4. Tắt backend → màn báo lỗi → bật lại → **Thử lại**
> 5. Lab 5 — **cú lật một dòng** chạy lại

**Lưu ý khi demo:**

- **Bật sẵn mọi thứ trước khi lên.** Docker, backend, emulator, app đã mở.
- Mở **phpMyAdmin** ở tab bên cạnh — thấy dữ liệu vào database thật thì thuyết phục hơn nhiều.
- Bước 4 là ấn tượng nhất: cho thấy nhóm nghĩ tới cả trường hợp hỏng.
- **Có video dự phòng.** Nếu quá 30 giây chưa chạy được thì mở video, đừng loay hoay trên bục.

---

### Slide 37 — Tổng kết: 5 lỗi nhóm tìm ra và sửa `[Hậu · 60 giây]`

**Nội dung slide:**

| # | Lỗi | Ở đâu |
|---|---|---|
| 1 | App treo spinner vĩnh viễn khi backend chết | Lab 6 client |
| 2 | Search hỏng với `&` `#` `+` | Lab 6 client |
| 3 | Kiến trúc không chứng minh được giá trị | Lab 5 |
| 4 | Ràng buộc `not null` bị Hibernate xoá mất | Lab 6 backend |
| 5 | Lab 6 chưa áp dụng kiến trúc của Lab 5 | Lab 6 |

**Người nói:** *"Cả năm đều là lỗi thật trong code, không phải thêm tính năng cho đẹp."*

---

### Slide 38 — Tài liệu tham khảo `[Hậu · 30 giây]`

**Nội dung slide:**

> **Tài liệu chính thống**
> - Flutter — <https://docs.flutter.dev>
> - Dart — <https://dart.dev/guides>
> - Spring Boot — <https://docs.spring.io/spring-boot/index.html>
> - MySQL — <https://dev.mysql.com/doc>
>
> **Thư viện**
> - provider · get_it · sqflite · http — <https://pub.dev>
>
> **Mã nguồn nhóm**
> - <https://github.com/StackForge-Labs/adfd-group-assignment>

---

### Slide 39 — Cảm ơn & Hỏi đáp `[Cả nhóm · 30 giây]`

**Nội dung slide:**

> ### Cảm ơn thầy và các bạn đã lắng nghe
> **Nhóm E** — Hậu · Tuấn · Trí · An

**Lưu ý:** khi thầy hỏi, **người phụ trách phần đó trả lời**. Không tranh nhau nói.

---
---

# Phụ lục — chuẩn bị trước buổi

## Ảnh có sẵn trong `docs/assets/`

| File | Dùng ở slide |
|---|---|
| `lab5-sqlite.png` | 17 — bên trái |
| `lab5-inmemory.png` | 17 — bên phải |
| `lab6-list.png` | 28 |
| `lab6-form.png` | dự phòng |
| `lab6-after-create.png` | dự phòng cho demo |
| `lab6-search.png` | dự phòng cho slide 33 |
| `lab6-error.png` | 32 — bên trái |
| `lab6-retry.png` | 32 — bên phải |

## Nếu bị rút ngắn thời gian

Cắt từ dưới lên, giữ phần trên:

| Ưu tiên | Slide |
|---|---|
| **Không được cắt** | 16, 17 (cú lật) · 36 (demo) |
| **Không được cắt** | 4 (câu hỏi mở) — vì 16 trả lời nó |
| Giữ nếu còn giờ | 30, 31, 32 (cải tiến 1) |
| Cắt được | 15, 23, 34 |
| Cắt được | 33 (cải tiến 2) — nói gọn một câu thay vì một slide |

## Trước ngày trình bày

- [ ] Cả 39 slide dùng **chung một mẫu và bộ màu**
- [ ] Tổng duyệt có bấm giờ — mỗi người đúng 8 phút
- [ ] **Hỏi vặn chéo**: mỗi người trả lời 3 câu trong `docs/phan-cong-task.md`
- [ ] Xuất **PDF dự phòng**, để trong USB
- [ ] Quay **video demo 2-3 phút** dự phòng
- [ ] An dựng lại môi trường từ đầu trên máy mình một lần
