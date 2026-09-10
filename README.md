# ADFD — Lab 5 & Lab 6 (Team E)

Bài tập nhóm môn Flutter. Nhóm phụ trách **Lab 5 (Architecture)** và
**Lab 6 (REST API)**.

| Lab | Nội dung | Chạy độc lập? |
|---|---|---|
| **Lab 5** | Clean Architecture: Repository / Entity ↔ Model / DI / Data Source | ✅ Chỉ cần Flutter |
| **Lab 6** | REST API: Spring Boot + MySQL + Flutter client | ❌ Cần database + backend |

> **Khác tài liệu gốc một điểm:** thầy dùng **SQL Server**, nhóm đổi sang
> **MySQL** (thầy cho phép chọn tự do). Code Java **không đổi một dòng nào** —
> chỉ đổi JDBC driver trong `pom.xml` và connection string trong
> `application.properties`. JPA che hết khác biệt giữa hai hệ quản trị CSDL.

---

## Cấu trúc

```
adfd-group-assignment/
├── docker-compose.yml              MySQL 8 + phpMyAdmin (cho máy chưa có MySQL)
├── db/init.sql                     Schema + 5 dòng dữ liệu mẫu
├── lab-5/adfd05_architecture/      Flutter — 5 flow
└── lab-6/
    ├── adfd06_backend/             Spring Boot 4.1.1 + MySQL, port 8082
    └── adfd06_frontend/            Flutter — 4 flow
```

Đề bài gốc (PDF + source thầy cho) nằm ở repo học Flutter:
`~/Documents/SelfStudy/flutter/docs/group-assignment/`

---

## Yêu cầu môi trường

| Thứ | Phiên bản đã kiểm |
|---|---|
| Flutter | 3.47.0 stable |
| Dart | 3.13.0 |
| Java | 21 trở lên (đã chạy thử với 25) |
| Maven | 3.9+ |
| Docker | để chạy MySQL |
| Android emulator | API 36, arm64 |

---

## Chạy Lab 5 (dễ, không cần backend)

```bash
cd lab-5/adfd05_architecture
flutter pub get
flutter run -d emulator-5554
```

Đổi flow: mở `lib/main.dart`, bỏ comment đúng **một** dòng import.

| Flow | Nội dung |
|---|---|
| 1 | Repository Abstraction — `IPostRepository` + in-memory |
| 2 | Repository Implementation — SQLite qua `DatabaseHelper` |
| 3 | Entity ↔ Model Mapping — `PostModel` ↔ `PostEntity` |
| 4 | Dependency Injection — GetIt |
| 5 | Data Source Abstraction — `IPostDataSource` + Search |

Chuỗi phụ thuộc ở Flow 5:

```
HomePage → PostProvider → IPostRepository
                               ↑
                       PostRepositoryImpl
                               ↓
                        IPostDataSource
                               ↑
                      PostDataSourceImpl → DatabaseHelper → SQLite
```

---

## Chạy Lab 6 (cần 3 thứ cùng sống)

### Bước 1 — MySQL

**Nếu máy chưa có MySQL:**
```bash
docker compose up -d
```

**Nếu máy đã có MySQL ở cổng 3306** (nạp schema vào cái sẵn có):
```bash
docker exec -i <tên-container> mysql -uroot -p<mật-khẩu> < db/init.sql
```

Kiểm tra:
```bash
docker exec -i <tên-container> mysql -uroot -p<mật-khẩu> \
  -e "SELECT COUNT(*) FROM adfddb.contacts;"
```
Phải ra **5**.

### Bước 2 — Backend

```bash
cd lab-6/adfd06_backend
mvn clean package -DskipTests
java -jar target/adfd06_rest_api-0.0.1-SNAPSHOT.jar
```

Backend chạy ở **http://localhost:8082**. Test nhanh:

```bash
curl http://localhost:8082/api/contacts
```

| Method | Endpoint | Chức năng |
|---|---|---|
| GET | `/api/contacts` | Lấy toàn bộ |
| POST | `/api/contacts` | Tạo mới |
| PUT | `/api/contacts/{id}` | Cập nhật |
| DELETE | `/api/contacts/{id}` | Xoá |
| GET | `/api/contacts/search?keyword=` | Tìm theo tên |

### Bước 3 — Flutter

```bash
cd lab-6/adfd06_frontend
flutter pub get
flutter run -d emulator-5554
```

Đổi flow trong `lib/main.dart`:

| Flow | Nội dung |
|---|---|
| 1 | HTTP GET → ListView |
| 2 | JSON ↔ Model — màn JSON Preview |
| 3 | Provider + API State + POST tạo mới |
| 4 | CRUD đầy đủ + Search |

---

## ⚠️ Bẫy đã gặp thật khi dựng

### 1. Emulator bật chế độ máy bay → app không gọi được API

Triệu chứng: spinner quay mãi, logcat báo
`SocketException: Network is unreachable, errno = 101`.

Emulator Android mới tạo **mặc định bật chế độ máy bay**. Tắt:

```bash
adb shell cmd connectivity airplane-mode disable
```

Kiểm tra biểu tượng ✈️ trên thanh trạng thái emulator trước khi kết luận
backend hỏng.

### 2. `10.0.2.2` chỉ đúng với Android emulator

Đó là địa chỉ đặc biệt để emulator trỏ về máy host. **Không dùng được** trên:

- điện thoại Android thật → dùng IP LAN của máy tính (`192.168.x.x`)
- iOS simulator → dùng `localhost`

Hiện đang hardcode ở 5 chỗ trong `api_service.dart`.

### 3. Tiếng Việt có dấu

Database phải là `utf8mb4` (đã set trong `db/init.sql`) và connection string
phải có `characterEncoding=UTF-8`. Thiếu một trong hai là tên tiếng Việt thành
dấu hỏi.

---

## Cải tiến của nhóm

Bốn thay đổi so với code thầy cho. Cả bốn đều **sửa lỗi thật**, không phải
thêm tính năng cho đẹp. Xem diff cụ thể bằng `git log --oneline`.

### 1. Lab 6 — App không còn treo spinner vĩnh viễn

**Lỗi gốc:** `ContactProvider.loading` khởi tạo là `true` và chỉ được set
`false` bên trong `if (statusCode == 200)`. Khi backend chết, `http.get` ném
`SocketException` mà không ai bắt → `loading` mãi là `true`.

Log thật khi chưa sửa:
```
E flutter : Unhandled Exception: ClientException with SocketException
E flutter :   ContactProvider.loadContacts (contact_provider.dart:21)
```

**Đã sửa:** thêm state thứ ba `error`, bọc mọi lời gọi API bằng `try/catch`,
và tắt `loading` trong `finally` — khối này chạy trong mọi trường hợp nên
không còn đường nào thoát ra mà spinner vẫn quay. UI có màn báo lỗi kèm nút
**Thử lại**.

**Cách demo:** tắt backend → mở app → thấy màn báo lỗi (không phải spinner) →
bật backend → bấm Thử lại → danh sách hiện ra, không cần tắt mở app.

### 2. Lab 6 — Dựng URI an toàn thay vì nối chuỗi

**Lỗi gốc:** `Uri.parse('...search?keyword=$keyword')` nhét thẳng biến vào URL.

Dấu cách và tiếng Việt có dấu thì không sao — `Uri.parse` tự encode chúng.
Nhưng các ký tự có ý nghĩa cấu trúc trong URL thì hỏng:

| Gõ vào ô search | Server nhận được |
|---|---|
| `John Smith` | `John Smith` ✅ |
| `Nguyễn Văn` | `Nguyễn Văn` ✅ |
| `A&B` | `A` ❌ cụt, và `&B` thành query param khác |
| `C#1` | `C` ❌ cụt |
| `a+b` | `a b` ❌ sai |

**Đã sửa:** dùng `Uri.http(authority, path, queryParameters)` — Dart tự encode.
Tiện thể gom địa chỉ backend về một hằng số thay vì lặp ở 5 phương thức.

### 3. Lab 5 — Chứng minh kiến trúc bằng cú lật một dòng

**Vấn đề:** cả 5 flow của Lab 5 chạy lên trông y hệt nhau, nên không thể demo
được giá trị của bốn tầng trừu tượng.

**Đã thêm:** `InMemoryPostDataSource` — implementation thứ hai của
`IPostDataSource`, lấy dữ liệu từ một `List` trong RAM.

Đổi **đúng một dòng** trong `ex05/core/di/injection.dart`:

```dart
const bool useInMemoryDataSource = false;   // → true
```

App chạy y nguyên: Read, Like/Dislike, Search đều hoạt động, chỉ khác nguồn
dữ liệu. **Không file nào khác phải sửa** — không Repository, không Provider,
không UI. Đó chính là Dependency Inversion, nhìn thấy được.

### 4. Backend — Thực thi đúng ràng buộc schema trong đề bài

**Lỗi gốc:** entity `Contact` không có `@Column` nào, chỉ khai báo trần
`private String name;`. Kết hợp với `spring.jpa.hibernate.ddl-auto=update`,
Hibernate lấy mặc định của nó — `varchar(255)`, cho phép null — và **ghi đè lên
schema** đã tạo từ script DDL.

Đo được bằng request thật, trước khi sửa:

```
POST /api/contacts  {}
→ 200 OK  {"id":10,"name":null,"email":null,"phone":null,"address":null}

POST /api/contacts  {"name":"Test","phone":"<200 ký tự>"}
→ 200 OK, lưu đủ 200 ký tự
```

Cả hai vi phạm DDL của đề bài:

```sql
name    varchar(100) not null
email   varchar(150)
phone   varchar(20)  not null
address varchar(255)
```

**Đã sửa:** khai báo ràng buộc trong entity cho khớp DDL.

```java
@Column(length = 100, nullable = false)
private String name;

@Column(length = 20, nullable = false)
private String phone;
```

Sau khi sửa, cùng hai request đó bị từ chối, còn request hợp lệ vẫn chạy bình
thường. Schema cũng không bị Hibernate ghi đè nữa vì entity đã khớp bảng.

**Lưu ý:** đây **không** phải hậu quả của việc đổi sang MySQL. Entity và
`ddl-auto=update` giữ nguyên từ code gốc, và hành vi này của Hibernate không phụ
thuộc hệ quản trị cơ sở dữ liệu.

**Còn thiếu gì:** request sai hiện trả về **HTTP 500**, trong khi đúng ra dữ liệu
đầu vào sai phải là **400 Bad Request**. Muốn đúng chuẩn REST thì cần thêm
`spring-boot-starter-validation`, gắn `@NotBlank` / `@Size` vào một DTO và bắt
`MethodArgumentNotValidException`. Chưa làm vì nằm ngoài phạm vi đề bài.

---

## Checklist trước khi demo

- [ ] Docker đang chạy, container MySQL sống
- [ ] `curl http://localhost:8082/api/contacts` trả về 5 contact
- [ ] Emulator đã bật, **đã tắt chế độ máy bay**
- [ ] `adb shell ping -c1 10.0.2.2` thông
- [ ] Lab 5 chạy được cả 5 flow
- [ ] Lab 6 chạy được cả 4 flow
