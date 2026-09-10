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

## Checklist trước khi demo

- [ ] Docker đang chạy, container MySQL sống
- [ ] `curl http://localhost:8082/api/contacts` trả về 5 contact
- [ ] Emulator đã bật, **đã tắt chế độ máy bay**
- [ ] `adb shell ping -c1 10.0.2.2` thông
- [ ] Lab 5 chạy được cả 5 flow
- [ ] Lab 6 chạy được cả 4 flow
