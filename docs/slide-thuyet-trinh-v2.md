# Nội dung slide thuyết trình — v2 (bản rút gọn)

> **Đây là bản đang dùng.** Bản đầy đủ 39 slide nằm ở
> `docs/slide-thuyet-trinh.md` — giữ lại để tra khi cần chi tiết hơn.

Tài liệu nguồn để **Hậu và An** dựng slide trên Canva. Tuấn và Trí đọc để góp ý.

- **25 slide / ~36 phút** — gọn hơn v1 gần một nửa (v1: 39 slide / 46 phút)
- Ảnh chụp thật nằm trong `docs/assets/`
- Ngôn ngữ: tiếng Việt, thuật ngữ kỹ thuật giữ nguyên tiếng Anh

## v2 khác v1 chỗ nào

Nguyên tắc cắt: **chi tiết nào người nói kể được trong 15 giây thì không cần slide riêng.**

| Đã bỏ | Giờ xử lý thế nào |
|---|---|
| Slide đổi SQL Server → MySQL | Trí nói một câu khi chiếu sơ đồ backend |
| Slide lỗi `@Column` / ràng buộc schema | **Bỏ hẳn** — chỉ giữ để trả lời nếu thầy hỏi |
| Slide tổng kết 5 cải tiến | **Bỏ hẳn** — đã nói rải trong từng phần |
| Slide bảng ký tự `&` `#` `+` | An nói một câu, không cần bảng |
| Slide `Uri.http` | Gộp vào câu nói trên |
| Slide `lazySingleton` vs `factory` | Ghi một dòng ở chân slide GetIt |
| Slide Search của Lab 5 | Tuấn nói lướt khi chiếu chuỗi phụ thuộc |
| Vài slide sơ đồ tách rời | Gộp chung với slide code tương ứng |

**Không cắt** bất kỳ thứ gì thuộc mạch chính: câu hỏi mở → cú lật một dòng →
demo. Đó là xương sống của cả buổi.

## Phân bổ thời gian

| Phần | Người | Thời lượng |
|---|---|---|
| Mở đầu | Hậu | 2:00 |
| 5A | Hậu | **8:00** |
| 5B | Tuấn | 6:30 |
| 6A | Trí | **4:10** |
| 6B | An | **8:40** |
| Demo + kết | An chạy, Hậu chốt | 7:00 |
| **Tổng** | | **36:20** |

Còn dư gần 4 phút so với mốc 40 — vẫn đủ đệm cho câu hỏi xen ngang và trục trặc
máy móc, nhưng đã sát hơn v2 gốc: đừng để phần nào tràn.

> ⚠️ **Phần của Trí giờ chỉ còn 4:10, ngắn hơn hẳn ba người kia.** Bỏ slide lỗi
> `@Column` đã lấy mất gần 1 phút rưỡi của phần này. Hai cách cân bằng:
> - Trí nói kỹ hơn ở slide 14 và 16 — cùng một slide nhưng giải thích sâu hơn
> - Hoặc chuyển slide 22 (`context.mounted`) từ An sang Trí, vì đó là kiến thức
>   Flutter chung. An đang nặng nhất với 8:40 cộng 6 phút demo.

## Cách đọc tài liệu này

| Phần | Nghĩa |
|---|---|
| **Nội dung slide** | Chữ và code **chiếu lên màn hình** |
| **Hình cần vẽ** | Mô tả sơ đồ để dựng trên Canva |
| **Người nói** | Lời thoại gợi ý — **đừng đọc y nguyên** |

## Nguyên tắc chung

- **Không slide nào quá 5 dòng chữ.**
- Code chiếu lên **tối đa 10 dòng**.
- Cả 25 slide dùng **chung một bộ màu và một mẫu**.

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

---

### Slide 3 — Hai lab trả lời hai câu hỏi khác nhau `[Hậu · 70 giây]`

**Nội dung slide:**

| | **Lab 5** | **Lab 6** |
|---|---|---|
| Câu hỏi | *Sắp xếp code sao cho khỏi rối* | *Nói chuyện với server thế nào* |
| Dữ liệu ở đâu | SQLite — **trong máy** | MySQL — **trên server** |
| Có backend | Không | Có — Spring Boot |

**Người nói:** *"Các nhóm trước đã trình bày widget, SQLite, cách tổ chức code và Provider. Hai lab của nhóm em đi tiếp từ đó."*

> Lớp đã nghe Lab 1-4 rồi — **không nhắc lại** Provider hay SQLite là gì.

---
---

# PHẦN 5A — Vì sao phải tách tầng · Hậu · 8 phút

---

### Slide 4 — Một câu hỏi trước khi bắt đầu `[Hậu · 60 giây]`

**Nội dung slide:**

> ### Giả sử mai app phải đổi từ SQLite sang gọi API.
> ### Theo các bạn, phải sửa bao nhiêu file?

**Hình cần vẽ:** một dấu hỏi lớn. Hoặc hình app với mũi tên xuống SQLite, và một mũi tên đứt nét đi lên đám mây.

**Người nói:** hỏi thật, **chờ vài giây cho lớp suy nghĩ**. Rồi: *"Giữ câu trả lời trong đầu. Cuối phần của bạn Tuấn, chúng ta sẽ biết con số thật."*

> **Câu hỏi xuyên suốt cả Lab 5. Đừng trả lời ngay.**

---

### Slide 5 — Bản đồ ba tầng `[Hậu · 90 giây]`

**Nội dung slide**

**PRESENTATION** — vẽ màn hình, giữ trạng thái
`HomePage` · `PostProvider`

**DOMAIN** — lõi bài toán, KHÔNG phụ thuộc ai
`PostEntity` · `IPostRepository`

**DATA** — biết SQLite, biết tên cột, biết 1 / 0
`PostModel` · `PostRepositoryImpl` · `IPostDataSource` · `PostDataSourceImpl`

*CORE (không phải một tầng)* — `DatabaseHelper` · `injection.dart`

**Hình cần vẽ** — `assets/so-do-8-ba-tang.svg`, chiếm gần hết slide.
Ba khối xếp chồng; mũi tên **xanh** bên trái đi **xuống** (chiều gọi, lúc chạy);
hai mũi tên **đỏ** bên phải cùng chỉ **vào Domain** (chiều phụ thuộc, lúc biên
dịch). Khung `CORE` nét đứt nằm tách dưới cùng.

**Người nói**

Ba tầng: Presentation vẽ màn hình, Domain là lõi và không phụ thuộc ai — mở
`PostEntity` ra không có lấy một dòng `import sqflite` — Data là tầng biết chuyện
bẩn. Core không phải tầng thứ tư, chỉ là hạ tầng dùng chung.

Chỗ quan trọng nhất: **hai mũi tên chỉ ngược nhau, và đó không phải lỗi vẽ.**
Xanh là chiều gọi lúc chạy, đi từ trên xuống. Đỏ là chiều phụ thuộc lúc biên
dịch — cả tầng trên lẫn tầng dưới **đều chỉ vào Domain**, còn Domain thì không
chỉ ra ngoài bao giờ. Đó chính là lý do đổi database mà giao diện không phải sửa.
Phần còn lại của bài chỉ đang chứng minh câu này.

> Đây là slide bản đồ. Không có code — cố ý. Toàn bộ các slide sau là đi lại tấm
> bản đồ này một cách chậm rãi.

---

### Slide 6 — Flow 1: Tạo hợp đồng trước `[Hậu · 100 giây]`

**Nội dung slide:**

```dart
abstract class IPostRepository {
  Future<List<PostEntity>> getPosts();
}
```

**Hình cần vẽ:** ngay dưới đoạn code, vẽ sơ đồ nhỏ:

```
HomePage  →  PostProvider  →  IPostRepository
                                    ↑
                          InMemoryPostRepository
```

Mũi tên `↑` **tô màu khác** — chi tiết quan trọng nhất.

**Người nói:** *"Việc đầu tiên là viết ra bản hợp đồng: 'sẽ có ai đó cung cấp danh sách Post'. Ai làm, làm bằng cách nào — chưa quan tâm. Giống interface trong Java."*

*"Để ý mũi tên đi ngược lên: Provider không gọi xuống class cụ thể, mà class cụ thể tự cắm vào hợp đồng."*

---

### Slide 7 — Flow 2: Thay ruột, tầng trên không đổi `[Hậu · 100 giây]`

**Nội dung slide:**

```dart
class PostRepositoryImpl implements IPostRepository {
  Future<List<PostEntity>> getPosts() async {
    final db = await databaseHelper.getDatabase();
    return db.query('posts');        // SQLite thật
  }
}
```

**Hình cần vẽ:** sơ đồ slide 6, nhánh dưới đổi thành `PostRepositoryImpl → SQLite`. Phần trên (`HomePage`, `PostProvider`, `IPostRepository`) **tô xám, ghi "KHÔNG ĐỔI"**.

**Người nói:** *"Flow 2 vứt dữ liệu giả đi, thay bằng SQLite thật. Và `HomePage` với `PostProvider` không phải sửa một dòng nào. Đó là lợi ích đầu tiên nhìn thấy được."*

---

### Slide 8 — Flow 3: `PostModel` làm người phiên dịch `[Hậu · 130 giây]`

**Nội dung slide:**

> **SQLite không có kiểu `true` / `false`** — nó chỉ lưu số `1` và `0`

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

**Người nói:** *"Nếu để số 1 và 0 chạy khắp app thì mọi chỗ đều phải nhớ '1 nghĩa là đã like' — hạn chế của database rò rỉ ra toàn bộ chương trình. `PostModel` nhốt nó lại trong tầng data."*

**Câu chuyển:** *"Đến đây có bốn tầng tách bạch. Nhưng ai nối chúng lại với nhau? Mời bạn Tuấn."*

---
---

# PHẦN 5B — Nối các mảnh và chứng minh · Tuấn · 6 phút 30

---

### Slide 9 — Vấn đề: ai nối các mảnh? `[Tuấn · 60 giây]`

**Nội dung slide:**

```dart
// Ai viết những dòng này, và viết ở đâu?
final helper     = DatabaseHelper();
final dataSource = PostDataSourceImpl(helper);
final repository = PostRepositoryImpl(dataSource);
final provider   = PostProvider(repository);
```

**Người nói:** *"Bốn tầng tách bạch rồi, nhưng vẫn phải có ai đó ghép lại. Nếu viết đống này ngay trong màn hình thì màn hình lại biết hết mọi tầng — công tách ra thành vô nghĩa."*

---

### Slide 10 — Flow 4: GetIt `[Tuấn · 100 giây]`

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
> `LazySingleton` tạo **một lần**, `Factory` tạo **mới mỗi lần**

**Người nói:** *"GetIt không phải để đỡ gõ `new`. Nó tách **nơi quyết định dùng implementation nào** ra khỏi **nơi sử dụng nó**."*

*"Và `setDI()` chưa tạo gì cả — nó chỉ ghi công thức. Object thật ra đời khi có ai đó hỏi tới. Đó là nghĩa của chữ Lazy."*

> Câu `LazySingleton` vs `Factory` thầy hay hỏi vặn — **chuẩn bị kỹ dù không có slide riêng.**

---

### Slide 11 — Flow 5: Chuỗi hoàn chỉnh `[Tuấn · 100 giây]`

**Hình cần vẽ:** sơ đồ trung tâm của cả bài — **vẽ to, chiếm gần hết slide**:

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

**Người nói:** *"Flow 5 tách nốt phần chạy SQL ra sau một hợp đồng thứ hai. Hai mũi tên đi ngược lên này có tên riêng: **Dependency Inversion**."*

*"Flow 5 cũng bổ sung Search — thêm một dòng vào hợp đồng, mọi tầng bên dưới tự biết phải làm gì."*

---

### Slide 12 — Câu hỏi đầu buổi, giờ trả lời được `[Tuấn · 70 giây]`

**Nội dung slide:**

```dart
// adfd05_architecture/lib/ex05/core/di/injection.dart
const bool useInMemoryDataSource = false;   // ← đổi thành true
```

> ### Một dòng.

**Người nói:** *"Đầu buổi bạn Hậu hỏi: đổi nguồn dữ liệu thì phải sửa bao nhiêu file? Câu trả lời là — **một dòng, trong một file**."*

---

### Slide 13 — Bằng chứng `[Tuấn · 60 giây]`

**Nội dung slide:** hai ảnh chụp thật **đặt cạnh nhau**, cùng kích thước.

| `docs/assets/lab5-sqlite.png` | `docs/assets/lab5-inmemory.png` |
|---|---|
| `false` — dữ liệu từ **SQLite** | `true` — dữ liệu từ **RAM** |

**Hình cần vẽ:** hai ảnh song song, giữa hai ảnh là mũi tên và chữ **"đổi 1 dòng"**. Bên dưới ghi nhỏ:

> Không đổi một dòng nào: `PostRepositoryImpl` · `PostProvider` · `HomePage` · `PostEntity` · `PostModel`

**Người nói:** *"Cùng giao diện. Cùng tính năng — Read, Like, Search đều chạy. Chỉ khác nguồn dữ liệu. Để ý trái tim đỏ ở ảnh bên phải: mapping Model sang Entity vẫn nguyên vẹn qua nguồn mới."*

> **Đỉnh của cả buổi.** Nói chậm, để lớp nhìn kỹ hai ảnh.

**Câu chuyển:** *"Kiến trúc này nhóm em không chỉ dùng cho Lab 5. Lab 6 gọi API thật, và dùng lại đúng khung vừa rồi. Mời bạn Trí."*

---
---

# PHẦN 6A — Backend và đường ống dữ liệu · Trí · 5 phút 30

---

### Slide 14 — Lab 6 dùng lại kiến trúc, đổi tầng đáy `[Trí · 90 giây]`

**Hình cần vẽ:** sơ đồ slide 11, nhưng tầng đáy đổi:

```
...  →  IContactDataSource
              ↑
      ContactDataSourceImpl
              ↓
          ApiClient  →  HTTP  →  Spring Boot  →  MySQL
```

Bên cạnh, sơ đồ nhỏ của backend:

```
Controller  →  Service  →  Repository  →  JPA  →  MySQL
```

**Người nói:** *"Khung y hệt Lab 5, chỉ khác tầng cuối: thay vì SQLite trong máy thì là server thật. Backend là cấu trúc Spring Boot quen thuộc lớp mình đã học."*

*"Đề bài dùng SQL Server, thầy cho chọn tự do nên nhóm em dùng MySQL. Toàn bộ thay đổi là hai dòng — driver và connection string. Code Java không đụng tới, vì JPA đã che hết khác biệt."*

> Câu MySQL nói lướt, **không dừng lại**. Ai hỏi thì mở code cho xem.

---

### Slide 15 — 5 endpoint `[Trí · 60 giây]`

**Nội dung slide:**

| Method | Endpoint | Chức năng |
|---|---|---|
| GET | `/api/contacts` | Lấy tất cả |
| POST | `/api/contacts` | Tạo mới |
| PUT | `/api/contacts/{id}` | Cập nhật |
| DELETE | `/api/contacts/{id}` | Xoá |
| GET | `/api/contacts/search?keyword=` | Tìm theo tên |

---

### Slide 16 — Từ JSON tới Model `[Trí · 100 giây]`

**Hình cần vẽ:** chuỗi biến đổi, vẽ ngang, mỗi bước một hộp:

```
Server  →  chuỗi JSON  →  Map  →  ContactModel  →  UI
                                       ↑
                              ContactModel.fromJson()
```

Chiều ngược lại bên dưới:

```
ContactModel  →  toJson()  →  chuỗi JSON  →  gửi lên server
```

**Nội dung slide:** thêm một dòng nhỏ ở góc:

```dart
Uri.http('10.0.2.2:8082', '/api/contacts')   // 10.0.2.2 = máy host
```

**Người nói:** *"Đây là toàn bộ việc Flutter làm khi gọi API. Và `10.0.2.2` là địa chỉ đặc biệt để Android emulator trỏ về máy tính — chỗ này ai mới học cũng vấp."*

**Câu chuyển:** *"Dữ liệu đã về tới Model. Giờ làm sao đưa lên màn hình và cho người dùng thao tác? Mời bạn An."*

---

---
---

# PHẦN 6B — Ứng dụng hoàn chỉnh · An · 7 phút

---

### Slide 17 — Provider giữ trạng thái API `[An · 80 giây]`

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

### Slide 18 — Ứng dụng hoàn chỉnh `[An · 60 giây]`

**Nội dung slide:** ảnh `docs/assets/lab6-list.png` chiếm nửa slide, bên cạnh:

> Xem · Thêm · Sửa · Xoá · Tìm kiếm

**Người nói:** giới thiệu nhanh — cuối buổi sẽ demo thật.

---

### Slide 19 — Nhóm áp kiến trúc Lab 5 vào Lab 6 `[An · 100 giây]`

**Hình cần vẽ:** hai cột so sánh.

| Đề bài cho | Nhóm em làm |
|---|---|
| `models/` `pages/` | `domain/` `data/` |
| `providers/` `services/` | `presentation/` `core/` |
| **0 interface** | **2 interface** + GetIt |

**Người nói:** *"Thầy cố tình để Lab 6 đơn giản vì mỗi lab dạy một thứ. Nhưng nhóm em muốn cho thấy đã áp dụng được bài học của Lab 3 và Lab 5 sang bài toán khác."*

*"Kết quả: giờ muốn đổi Lab 6 từ REST API sang SQLite cũng chỉ tốn một dòng — y như cú lật bạn Tuấn vừa cho xem."*

---

### Slide 20 — Cải tiến: app treo spinner vĩnh viễn `[An · 130 giây]`

**Nội dung slide:**

```dart
bool loading = true;              // khởi tạo là true

if (response.statusCode == 200) {
  loading = false;                // CHỈ set false ở đây
}
// không có else, không có try/catch
```

**Hình cần vẽ:** ngay bên dưới, sơ đồ ba nhánh:

```
            gọi API
               ↓
    ┌──────────┼──────────┐
 thành công  lỗi HTTP  mất mạng
    ↓          ↓          ↓
 contacts    error      error
    └──────────┼──────────┘
               ↓
            finally
               ↓
       loading = false     ← luôn chạy
```

**Người nói:** *"Nhóm em tắt backend thử. App quay spinner mãi không dừng — vì `loading` chỉ được tắt trong nhánh thành công."*

*"Nhóm em thêm trạng thái thứ ba là `error`, và tắt `loading` trong khối `finally` — khối này chạy trong mọi trường hợp, không còn đường nào thoát ra mà spinner vẫn quay."*

---

### Slide 21 — Kết quả `[An · 70 giây]`

**Nội dung slide:** hai ảnh cạnh nhau.

| `docs/assets/lab6-error.png` | `docs/assets/lab6-retry.png` |
|---|---|
| Backend tắt → báo lỗi rõ ràng | Bấm **Thử lại** → danh sách hiện ra |

**Người nói:** *"Thay vì spinner quay mãi, app báo đúng hai nguyên nhân thật và có nút Thử lại — không cần tắt mở app."*

*"Nhóm em cũng sửa một lỗi nữa: ô search nối chuỗi thẳng vào URL, nên gõ `A&B` thì server chỉ nhận được `A`. Đã chuyển sang `Uri.http` để Dart tự encode."*

> Cải tiến 2 **nói bằng miệng**, không có slide riêng.

---

### Slide 22 — Một cái bẫy chỉ Flutter mới có `[An · 80 giây]`

**Nội dung slide:**

```dart
await context.read<ContactProvider>().addContact(contact);

if (!context.mounted) return;     // ← bắt buộc

Navigator.pop(context);
```

**Người nói:** *"Sau `await`, widget có thể đã bị huỷ — người dùng bấm back trong lúc chờ mạng. Dùng `context` lúc đó là crash."*

*"Lab 5 không gặp bẫy này, vì nó không có `await` nằm giữa thao tác người dùng và điều hướng."*

---
---

# DEMO & KẾT — 7 phút 30

---

### Slide 23 — Demo trực tiếp `[An chạy · cả nhóm trả lời · 6 phút]`

**Nội dung slide:** chỉ một chữ **DEMO** lớn, kèm checklist nhỏ:

> 1. Danh sách lấy từ MySQL thật *(mở phpMyAdmin song song)*
> 2. Thêm contact → F5 phpMyAdmin → dòng mới xuất hiện
> 3. Search · Sửa · Xoá
> 4. Tắt backend → màn báo lỗi → bật lại → **Thử lại**
> 5. Lab 5 — **cú lật một dòng** chạy lại

**Lưu ý khi demo:**

- **Bật sẵn mọi thứ trước khi lên.** Docker, backend, emulator, app đã mở.
- Mở **phpMyAdmin** tab bên cạnh — thấy dữ liệu vào database thật thì thuyết phục hơn nhiều.
- Bước 4 ấn tượng nhất: cho thấy nhóm nghĩ tới cả trường hợp hỏng.
- **Có video dự phòng.** Quá 30 giây chưa chạy được thì mở video, đừng loay hoay trên bục.

---

### Slide 24 — Tài liệu tham khảo `[Hậu · 30 giây]`

**Nội dung slide:**

> **Tài liệu chính thống**
> - Flutter — <https://docs.flutter.dev>
> - Dart — <https://dart.dev/guides>
> - Spring Boot — <https://docs.spring.io/spring-boot/index.html>
> - MySQL — <https://dev.mysql.com/doc>
>
> **Thư viện** — provider · get_it · sqflite · http — <https://pub.dev>
>
> **Mã nguồn nhóm**
> - <https://github.com/StackForge-Labs/adfd-group-assignment>

---

### Slide 25 — Cảm ơn & Hỏi đáp `[Cả nhóm · 30 giây]`

**Nội dung slide:**

> ### Cảm ơn thầy và các bạn đã lắng nghe
> **Nhóm E** — Hậu · Tuấn · Trí · An

**Lưu ý:** thầy hỏi thì **người phụ trách phần đó trả lời**. Không tranh nhau nói.

---
---

# Phụ lục

## Ảnh dùng trong slide

| File trong `docs/assets/` | Slide |
|---|---|
| `lab5-sqlite.png` | 12 — bên trái |
| `lab5-inmemory.png` | 12 — bên phải |
| `lab6-list.png` | 17 |
| `lab6-error.png` | 20 — bên trái |
| `lab6-retry.png` | 20 — bên phải |
| `lab6-form.png` `lab6-after-create.png` `lab6-search.png` | dự phòng |

## Những thứ KHÔNG có slide — người nói phải nhớ

Đây là phần v2 cắt đi so với v1. Chúng vẫn phải được nói, chỉ là không chiếu:

| Ai | Phải nói ở slide nào | Nội dung |
|---|---|---|
| Tuấn | 9 | `LazySingleton` tạo một lần, `Factory` tạo mới mỗi lần |
| Tuấn | 10 | Flow 5 có bổ sung Search |
| Trí | 13 | Đổi SQL Server → MySQL tốn đúng 2 dòng |
| An | 20 | Search hỏng với `&` `#` `+`, sửa bằng `Uri.http` |

> **Cắt slide không có nghĩa là cắt kiến thức.** Thầy vẫn có thể hỏi bất kỳ mục
> nào ở trên — xem `docs/phan-cong-task.md` để ôn câu trả lời.

### Không trình bày, nhưng phải sẵn sàng nếu thầy hỏi

Hai nội dung dưới đây nhóm quyết định **không đưa lên slide** vì là chi tiết nhỏ.
Nhưng chúng là công sức thật của nhóm, nên nếu thầy hỏi thì phải trả lời được:

| Ai | Nội dung |
|---|---|
| **Trí** | **Cải tiến 4** — entity thiếu `@Column` nên `ddl-auto=update` để Hibernate ghi đè schema, làm mất ràng buộc `not null`. `POST {}` tạo được bản ghi rỗng. Sửa bằng `@Column(length, nullable)`. |
| **Hậu** | Nhóm đã sửa **5 lỗi thật** trong code đề bài — xem bảng đầy đủ trong `README.md` mục *Cải tiến của nhóm*. |

## Nếu vẫn còn dài, cắt tiếp theo thứ tự này

| Ưu tiên | Slide |
|---|---|
| **Không được cắt** | 4 (câu hỏi mở) · 11, 12 (cú lật) · 22 (demo) |
| Cắt sau cùng | 21 (`context.mounted`) |
| Cắt trước | 14 (bảng endpoint) — Trí đọc miệng |
| Cắt trước nữa | 17 (ảnh app) — vì cuối buổi đã demo thật |

## Trước ngày trình bày

- [ ] Cả 24 slide dùng **chung một mẫu và bộ màu**
- [ ] Tổng duyệt có bấm giờ
- [ ] **Hỏi vặn chéo**: mỗi người trả lời 3 câu trong `docs/phan-cong-task.md`
- [ ] Xuất **PDF dự phòng**, để trong USB
- [ ] Quay **video demo 2-3 phút** dự phòng
- [ ] An dựng lại môi trường từ đầu trên máy mình một lần
