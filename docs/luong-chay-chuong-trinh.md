# Luồng chạy chương trình — từ lúc bấm Run tới lúc thấy dữ liệu

Tài liệu dành cho thành viên nhóm. Trả lời câu hỏi: *"Bấm Run xong thì máy làm
gì, và dữ liệu đi đường nào để lên được màn hình?"*

Hiểu sơ đồ ở mục 2 là hiểu được phần lớn Lab 5.

---

## 1. Trước hết: thư mục trong Flutter không có ý nghĩa với máy

Điều này khác hẳn Java và làm nhiều người nhầm.

Trong Java, `package com.fpt.controller` **bắt buộc** phải nằm đúng thư mục
`com/fpt/controller/`. Dart **không có** khái niệm package theo thư mục. Dart chỉ
import theo **đường dẫn file**:

```dart
import '../../domain/entities/post_entity.dart';
```

Đổi thư mục = đổi mấy dòng chữ này. Chương trình chạy **y hệt** — không nhanh
hơn, không chậm hơn, không đổi hành vi.

> **Kết luận:** structure trong Flutter là để **người đọc code** dễ tìm và dễ
> sửa, không phải để máy chạy. Câu hỏi "structure nào chuẩn" thực chất là "sắp
> xếp sao cho người sau đọc vào hiểu nhanh nhất".

---

## 2. Lab 5 — mười bước từ `main()` tới màn hình

```
①  main()                            lib/main.dart
    │  runApp(MyApp())
    ▼
②  MyApp.build()                     ex05_flow.dart
    │  setDI()  ──────────────────►  GetIt ghi nhớ "ai tạo ra ai"
    │                                 (chưa tạo gì cả, chỉ ghi công thức)
    ▼
③  injector<PostProvider>()          GetIt lắp ráp theo công thức:
    │                                   PostProvider(
    │                                     PostRepositoryImpl(
    │                                       PostDataSourceImpl(
    │                                         DatabaseHelper() )))
    │  ..loadPosts()
    ▼
④  PostProvider.loadPosts()          "tôi cần danh sách post"
    ▼
⑤  IPostRepository.getPosts()        hợp đồng → PostRepositoryImpl làm
    ▼
⑥  IPostDataSource.getPosts()        hợp đồng → PostDataSourceImpl làm
    ▼
⑦  DatabaseHelper → SQLite           SELECT * FROM posts
    │
    ▲  trả về List<Map> — dữ liệu thô, is_like là số 1/0
⑧  Map → PostModel → PostEntity      Repository phiên dịch, 1/0 → true/false
    ▲
⑨  PostProvider giữ danh sách
    │  notifyListeners()  ─────────►  "ai đang nghe thì vẽ lại đi"
    ▼
⑩  HomePage.build() chạy lại         danh sách hiện lên màn hình
```

### Ba điều quan trọng nhất trong sơ đồ

**1. Bước ② chưa tạo gì cả.**
`setDI()` chỉ ghi *công thức* vào GetIt. Object thật chỉ được tạo ở bước ③, khi
có ai đó hỏi tới. Đó là ý nghĩa của chữ **Lazy** trong `registerLazySingleton`.

**2. Bước ⑤ và ⑥ đi qua hợp đồng.**
`PostProvider` gọi `IPostRepository` chứ không gọi thẳng `PostRepositoryImpl`.
Nó **không biết** ai đang làm việc cho mình. Đó chính là lý do đổi một dòng
trong `injection.dart` là đổi được cả nguồn dữ liệu — xem cải tiến 3 trong
`README.md`.

**3. Bước ⑨ → ⑩ là toàn bộ bí mật của Provider.**
UI không tự biết dữ liệu đã về. `notifyListeners()` là tiếng gọi, và mọi widget
đang `context.watch<PostProvider>()` sẽ tự chạy lại `build()`.

---

## 3. Hai chiều của mũi tên

Để ý sơ đồ có hai chiều mũi tên khác nhau:

| Chiều | Nghĩa |
|---|---|
| `▼` đi xuống | **Yêu cầu** — tầng trên nhờ tầng dưới làm việc |
| `▲` đi lên | **Dữ liệu trả về** — và bị biến đổi dần trên đường lên |

Dữ liệu **đổi hình dạng** trên đường đi lên:

```
SQLite      →   List<Map>        dữ liệu thô, is_like = 1
                    ↓
PostModel   →   isLike = 1       vẫn còn kiểu của database
                    ↓
PostEntity  →   isLike = true    kiểu mà app muốn dùng
                    ↓
HomePage    →   ❤️               trái tim đỏ trên màn hình
```

Đây là lý do tồn tại của `PostModel`. SQLite **không có kiểu true/false**, nó
chỉ lưu số `1` và `0`. Nếu để `PostEntity` mang số `1/0` thì cả app phải nhớ
*"1 nghĩa là đã like"* — hạn chế của database rò rỉ ra khắp nơi. `PostModel`
đứng giữa làm phiên dịch, **nhốt cái xấu xí đó lại trong tầng data**.

---

## 4. Lab 6 khác chỗ nào

Luồng gần như y hệt, chỉ khác **bước ⑦**:

| | Lab 5 | Lab 6 |
|---|---|---|
| ⑦ Nguồn dữ liệu | `DatabaseHelper` → SQLite trong máy | `http.get()` → server Spring Boot |
| ⑧ Phiên dịch | `List<Map>` → Model → Entity | JSON → `Map` → Model → Entity |
| Thời gian chờ | vài mili-giây | vài trăm mili-giây, **có thể lỗi mạng** |

Khác biệt cuối cùng quan trọng hơn vẻ ngoài của nó: gọi mạng **có thể thất bại**,
nên Lab 6 cần thêm trạng thái `error` bên cạnh `loading` và `contacts`. Đó chính
là cải tiến 1 của nhóm — xem `README.md`.

---

## 5. Vì sao phải nhớ luồng này

Khi debug, câu hỏi đầu tiên luôn là **"dữ liệu chết ở bước nào?"**

| Triệu chứng | Nghi ngờ bước |
|---|---|
| Màn hình trắng, không có gì | ① ② — app chưa chạy tới `build()` |
| Spinner quay mãi | ④ ⑦ — gọi dữ liệu không bao giờ về |
| Có dữ liệu nhưng hiện sai | ⑧ — mapping Model ↔ Entity |
| Dữ liệu về rồi mà màn hình không đổi | ⑨ — quên `notifyListeners()` |

Nhớ được bảng này là tiết kiệm rất nhiều thời gian mò mẫm.
