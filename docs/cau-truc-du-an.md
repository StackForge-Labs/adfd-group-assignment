# Cấu trúc dự án — và lý do đằng sau

Tài liệu này giải thích **vì sao** thư mục được sắp xếp như hiện tại, đặc biệt
là chỗ nhóm làm khác code gốc của thầy.

---

## 1. Nhắc lại: thư mục không có ý nghĩa với máy

Dart không có khái niệm package theo thư mục như Java. Import là theo **đường
dẫn file**, nên đổi thư mục chỉ là đổi mấy dòng `import`. Chương trình chạy y
hệt.

> Structure là để **người đọc code** dễ tìm, không phải để máy chạy.

Chi tiết xem `docs/luong-chay-chuong-trinh.md`.

---

## 2. Vỏ `exNN/` — giữ nguyên, và đây là lý do

Mỗi lab chứa 4-5 **phiên bản** của cùng một app để dạy tiến trình. Chuyển giữa
các phiên bản bằng cách bỏ comment một dòng `import` trong `lib/main.dart`.

```
lib/
├── main.dart          ← chọn Flow ở đây
├── ex01_flow.dart     ← mỗi file định nghĩa một class MyApp
├── ex01/              ← code riêng của Flow 1
├── ex02_flow.dart
├── ex02/
└── ...
```

Đây là **quy ước dạy học**, không phải quy ước kỹ thuật của Flutter. App thật
chỉ có một phiên bản nên không cần vỏ này. Nhóm giữ nguyên vì bỏ đi là mất luôn
khả năng demo từng bước — vốn là điểm mạnh của bộ bài này.

---

## 3. Lab 5 — giữ nguyên, vì vốn đã chuẩn

```
ex05/
├── core/
│   ├── database/          DatabaseHelper — mở SQLite
│   └── di/                GetIt — nối dependency
├── data/
│   ├── data_sources/      chạy SQL thật
│   ├── models/            PostModel — biết SQLite lưu is_like = 0/1
│   └── repositories/      PostRepositoryImpl — mapping Model ⇄ Entity
├── domain/
│   ├── entities/          PostEntity — dữ liệu thuần
│   └── repositories/      IPostRepository — hợp đồng
└── presentation/
    ├── pages/             HomePage
    └── providers/         PostProvider
```

`domain` / `data` / `presentation` **chính là Clean Architecture** — cấu trúc
được dùng rộng rãi trong Flutter thật. Không cần sửa gì.

### Vì sao KHÔNG thêm thư mục `features/`

Lab 3 dạy tổ chức theo tính năng:

```
features/
├── attendance/
├── game/
├── payroll/
└── team/
```

Cách đó sinh ra để giải quyết vấn đề **app có nhiều tính năng**. Lab 5 chỉ có
**một** tính năng là post. Thêm `features/` vào sẽ thành:

```
features/
└── post/          ← chứa toàn bộ app, không có anh em nào bên cạnh
```

Một tầng thư mục không giải quyết vấn đề gì, vì vấn đề "nhiều tính năng lẫn
lộn" không tồn tại ở đây. Nhóm chọn **không** làm cho có.

---

## 4. Lab 6 — đã tổ chức lại (đây là thay đổi lớn nhất)

### Trước

```
ex04/
├── models/        ContactModel
├── pages/         HomePage, ContactList, ContactForm
├── providers/     ContactProvider — tự parse JSON luôn
└── services/      ApiService — gọi HTTP thẳng
```

Bốn thư mục, **không có hợp đồng (interface) nào**, không tách Entity/Model,
không có DI. `ContactProvider` gọi thẳng `ApiService` và tự `jsonDecode`.

### Sau

```
ex04/
├── core/
│   ├── di/                GetIt
│   └── network/           ApiClient + ApiException
├── data/
│   ├── data_sources/      IContactDataSource + ContactDataSourceImpl
│   ├── models/            ContactModel — biết JSON, biết server trả null
│   └── repositories/      ContactRepositoryImpl — mapping Model ⇄ Entity
├── domain/
│   ├── entities/          ContactEntity — dữ liệu thuần
│   └── repositories/      IContactRepository — hợp đồng
└── presentation/
    ├── pages/             HomePage, ContactList, ContactForm
    └── providers/         ContactProvider
```

**Giống hệt khung của Lab 5.** Chỉ khác một chỗ duy nhất: tầng thấp nhất là
`ApiClient` (HTTP) thay vì `DatabaseHelper` (SQLite).

### Vì sao làm điều này

Thầy cố tình để Lab 6 đơn giản, vì mỗi lab dạy **một** thứ — Lab 6 dạy *gọi
API*, nhét thêm Repository và DI vào sẽ làm loãng bài học chính.

Nhưng ở bài thuyết trình, nhóm muốn cho thấy đã **áp dụng được** bài học của
Lab 3 và Lab 5 sang một bài toán khác, chứ không chỉ chép lại.

Kết quả cụ thể: giờ muốn đổi Lab 6 từ REST API sang SQLite thì chỉ cần viết một
`ContactDataSourceImpl` khác và sửa **một dòng** trong `injection.dart` —
`ContactProvider`, `ContactRepositoryImpl` và toàn bộ UI không phải sửa gì.
Đúng y như cú lật ở cải tiến 3 của Lab 5.

### So sánh hai lab sau khi tổ chức lại

| Tầng | Lab 5 | Lab 6 |
|---|---|---|
| UI | `HomePage` | `HomePage`, `ContactList`, `ContactForm` |
| State | `PostProvider` | `ContactProvider` |
| Hợp đồng Repository | `IPostRepository` | `IContactRepository` |
| Repository | `PostRepositoryImpl` | `ContactRepositoryImpl` |
| Hợp đồng Data Source | `IPostDataSource` | `IContactDataSource` |
| Data Source | `PostDataSourceImpl` | `ContactDataSourceImpl` |
| Tầng thấp nhất | `DatabaseHelper` → SQLite | `ApiClient` → HTTP |
| DI | `GetIt` | `GetIt` |

---

## 5. Một quy tắc nhóm tự đặt ra

**Data Source chỉ nói chuyện bằng dữ liệu thô. Repository là nơi duy nhất biết
cả Model lẫn Entity.**

Cụ thể trong Lab 6:

- `IContactDataSource` nhận và trả `Map<String, dynamic>` — đúng hình dạng JSON
- `ContactRepositoryImpl` dịch `Map` → `ContactModel` → `ContactEntity` và ngược lại
- `ContactProvider` chỉ thấy `ContactEntity`

Lab 5 của thầy có một chỗ hơi khác: `IPostDataSource.toggleLike()` nhận thẳng
`PostEntity`. Nhóm không sửa Lab 5 (vì đang khớp đề bài), nhưng ở Lab 6 thì áp
dụng quy tắc nhất quán trên — mọi việc phiên dịch gom về một chỗ, dễ tìm hơn khi
có lỗi mapping.

---

## 6. Chỗ lệch so với tài liệu thầy

| Chỗ | Tài liệu thầy | Nhóm làm | Lý do |
|---|---|---|---|
| Thư mục Lab 6 | `ex04/models`, `pages`, `providers`, `services` | `ex04/core`, `data`, `domain`, `presentation` | Áp dụng bài học Lab 3 + Lab 5 |
| Database | SQL Server | MySQL | Thầy cho phép chọn tự do |
| `artifactId` | tài liệu ghi `adfd06_backend` | `adfd06_rest_api` | Theo **code** thầy cho, vì tài liệu và code của thầy không khớp nhau |

Ba chỗ này đều là **quyết định có ý thức**, không phải làm ẩu. Khi thuyết trình
nên chủ động nói ra trước khi thầy hỏi.
