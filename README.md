# ADFD — Lab 5 & Lab 6

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
├── docs/                           tài liệu cho thành viên nhóm
│   ├── tong-quan-lab-5-6.md        bức tranh lớn — ĐỌC CÁI NÀY TRƯỚC
│   ├── luong-chay-chuong-trinh.md  bấm Run xong máy làm gì
│   ├── cau-truc-du-an.md           cấu trúc thư mục và lý do đằng sau
│   ├── phan-cong-task.md           chia việc 4 người + kịch bản trình bày
│   └── lenh-hay-dung.md            tra cứu lệnh Flutter / Maven / Docker
├── adfd05_architecture/            Flutter — Lab 5, 5 flow
└── adfd06_rest_api/
    ├── adfd06_backend/             Spring Boot 4.1.1 + MySQL, port 8082
    └── adfd06_frontend/            Flutter — Lab 6, 4 flow
```

**Người mới vào nhóm đọc theo thứ tự này:**

1. `docs/tong-quan-lab-5-6.md` — hiểu hai lab làm gì (15 phút)
2. `docs/luong-chay-chuong-trinh.md` — hiểu dữ liệu đi đường nào
3. `docs/cau-truc-du-an.md` — hiểu vì sao thư mục sắp xếp như vậy
4. `docs/phan-cong-task.md` — phần việc của mình và câu hỏi phải trả lời được
5. Mục **Cài đặt môi trường** bên dưới — rồi chạy thử

Lúc code thì mở `docs/lenh-hay-dung.md` để tra lệnh.

> Đề bài gốc của thầy (file PDF và source mẫu) **không nằm trong repo này**.
> Hỏi trưởng nhóm để lấy.

---

## Cài đặt môi trường

### Cần những gì

| Thứ | Phiên bản đã kiểm | Lab 5 | Lab 6 |
|---|---|:--:|:--:|
| Flutter SDK | 3.47.0 stable | ✅ | ✅ |
| Dart | 3.13.0 (đi kèm Flutter) | ✅ | ✅ |
| Android Studio + emulator | API 36 | ✅ | ✅ |
| JDK | 21 trở lên (đã chạy với 25) | — | ✅ |
| Maven | 3.9+ | — | ✅ |
| Docker | bản mới | — | ✅ |

**Chỉ làm Lab 5 thì chỉ cần 3 dòng đầu.** Lab 6 mới cần đủ 6.

---

### Bước 1 — Flutter SDK

**macOS**

```bash
# cách nhanh nhất
brew install --cask flutter

# hoặc tải thủ công rồi thêm vào PATH trong ~/.zshrc:
#   export PATH="$HOME/development/flutter/bin:$PATH"
```

**Windows**

1. Tải bản zip tại <https://docs.flutter.dev/get-started/install/windows>
2. Giải nén ra `C:\src\flutter` (**tránh** thư mục có dấu cách như `Program Files`)
3. Thêm `C:\src\flutter\bin` vào biến môi trường `Path`

Kiểm tra:

```bash
flutter --version
```

---

### Bước 2 — Android Studio và máy ảo

1. Cài **Android Studio** từ <https://developer.android.com/studio>
2. Mở **Settings** → *Languages & Frameworks* → **Android SDK**
   - Tab **SDK Platforms**: tick **Android 16 (API 36)**
   - Tab **SDK Tools**: tick **Android SDK Command-line Tools (latest)**
   - Bấm **Apply**
3. Chấp nhận license:

```bash
flutter doctor --android-licenses
```
Gõ `y` cho **từng** license cho tới khi hết. Thoát giữa chừng là chưa xong.

4. Tạo máy ảo — **Device Manager** trong Android Studio → *Create Device* →
   chọn Pixel bất kỳ → chọn system image API 36 → Finish.

> **Nếu `flutter emulators --create` báo không có system image** dù bạn đã cài:
> đó là lỗi tương thích giữa Flutter và `cmdline-tools` bản mới. Tạo máy ảo
> bằng giao diện Android Studio như bước 4 là được.

---

### Bước 3 — JDK và Maven *(chỉ cần cho Lab 6)*

**macOS**
```bash
brew install openjdk@21 maven
```

**Windows**
- JDK: tải Temurin 21 tại <https://adoptium.net>
- Maven: tải tại <https://maven.apache.org/download.cgi>, giải nén rồi thêm thư
  mục `bin` vào `Path`

Kiểm tra:
```bash
java -version
mvn -version
```

---

### Bước 4 — Docker *(chỉ cần cho Lab 6)*

Cài **Docker Desktop** từ <https://www.docker.com/products/docker-desktop>.
Mở lên và để nó chạy nền.

Kiểm tra:
```bash
docker --version
```

---

### Bước 5 — Kiểm tra tổng thể

```bash
flutter doctor
```

Cần thấy `[✓]` ở **Flutter** và **Android toolchain**. Các mục khác (Xcode,
Chrome) không bắt buộc.

> ⚠️ **`flutter doctor` có thể báo nhầm về license.**
> Nếu nó hiện `✗ Android license status unknown` **dù bạn đã accept hết**, đó là
> báo động giả — `cmdline-tools` bản mới đã bỏ cờ `--licenses` mà Flutter vẫn
> gọi. Cách kiểm chứng thật là **build thử một APK**:
> ```bash
> cd adfd05_architecture && flutter build apk --debug
> ```
> Build được là license ổn, bỏ qua cảnh báo đó.

Cuối cùng, bật máy ảo và kiểm tra Flutter nhìn thấy nó:

```bash
flutter emulators                       # xem danh sách
flutter emulators --launch <tên-máy-ảo>
flutter devices                         # phải thấy thiết bị android
```

---

## Chạy Lab 5 (dễ, không cần backend)

```bash
cd adfd05_architecture
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
cd adfd06_rest_api/adfd06_backend
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
cd adfd06_rest_api/adfd06_frontend
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

Hoặc bấm thẳng trong emulator: kéo thanh trạng thái xuống → tắt biểu tượng
máy bay.

> **`adb: command not found`?** `adb` không tự nằm trong `PATH`. Đường dẫn đầy đủ:
> - macOS / Linux: `~/Library/Android/sdk/platform-tools/adb`
> - Windows: `%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe`

Kiểm tra biểu tượng ✈️ trên thanh trạng thái emulator trước khi kết luận
backend hỏng.

### 2. `10.0.2.2` chỉ đúng với Android emulator

Đó là địa chỉ đặc biệt để emulator trỏ về máy host. **Không dùng được** trên:

- điện thoại Android thật → dùng IP LAN của máy tính (`192.168.x.x`)
- iOS simulator → dùng `localhost`

Đổi ở **một chỗ duy nhất** — hằng số `_authority` trong
`adfd06_rest_api/adfd06_frontend/lib/ex04/core/network/api_client.dart`.

### 3. Tiếng Việt có dấu

Database phải là `utf8mb4` (đã set trong `db/init.sql`) và connection string
phải có `characterEncoding=UTF-8`. Thiếu một trong hai là tên tiếng Việt thành
dấu hỏi.

---

## Cải tiến của nhóm

Năm thay đổi so với code thầy cho. Bốn cái đầu **sửa lỗi thật**, cái thứ năm là
áp dụng bài học của Lab 3 và Lab 5 vào Lab 6. Xem diff cụ thể bằng
`git log --oneline`.

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

Đổi **đúng một dòng** trong `adfd05_architecture/lib/ex05/core/di/injection.dart`:

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

### 5. Lab 6 — Tổ chức lại theo kiến trúc của Lab 5

**Vấn đề:** thầy cố tình để Lab 6 đơn giản vì mỗi lab dạy một thứ. Kết quả là
`ex04/` chỉ có `models/` `pages/` `providers/` `services/` — không có hợp đồng
(interface) nào, không tách Entity/Model, `ContactProvider` gọi thẳng
`ApiService` và tự `jsonDecode`.

**Đã làm:** dựng lại `ex04/` theo đúng khung của Lab 5.

```
ContactList (UI) → ContactProvider → IContactRepository
                                            ↑
                                    ContactRepositoryImpl
                                            ↓
                                     IContactDataSource
                                            ↑
                                   ContactDataSourceImpl → ApiClient → HTTP
```

Giống hệt Lab 5, chỉ khác tầng đáy: `ApiClient` (HTTP) thay cho
`DatabaseHelper` (SQLite).

**Kết quả đo được:** muốn đổi Lab 6 từ REST API sang SQLite giờ chỉ cần viết
một `ContactDataSourceImpl` khác và sửa **một dòng** trong
`adfd06_rest_api/adfd06_frontend/lib/ex04/core/di/injection.dart`.
`ContactProvider`, `ContactRepositoryImpl` và toàn bộ UI không phải sửa gì —
đúng như cú lật ở cải tiến 3.

**Lab 5 giữ nguyên**, vì `domain/` + `data/` + `presentation/` vốn đã là Clean
Architecture. Lý do đầy đủ trong `docs/cau-truc-du-an.md`.

---

## Checklist trước khi demo

- [ ] Docker đang chạy, container MySQL sống
- [ ] `curl http://localhost:8082/api/contacts` trả về 5 contact
- [ ] Emulator đã bật, **đã tắt chế độ máy bay**
- [ ] `adb shell ping -c1 10.0.2.2` thông
- [ ] Lab 5 chạy được cả 5 flow
- [ ] Lab 6 chạy được cả 4 flow
