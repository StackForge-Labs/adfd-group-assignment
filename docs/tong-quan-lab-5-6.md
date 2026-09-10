# Tổng quan Lab 5 & Lab 6 — đọc cái này trước

Tài liệu dành cho thành viên nhóm. Mục tiêu: hiểu **bức tranh lớn** trước khi
chui vào code. Đọc hết mất khoảng 15 phút.

Chưa cần biết Flutter cũng đọc được. Nếu bạn đã học Spring Boot thì phần Lab 5
sẽ rất nhanh vào.

---

## 1. Hai lab trả lời hai câu hỏi khác nhau

| | **Lab 5 — Architecture** | **Lab 6 — REST API** |
|---|---|---|
| Câu hỏi | *Sắp xếp code sao cho khỏi rối* | *Nói chuyện với server thế nào* |
| Dữ liệu nằm ở đâu | SQLite — **trong máy điện thoại** | MySQL — **trên server** |
| Có backend không | Không | Có (Spring Boot) |
| Số Flow | 5 | 4 |
| Cái khó thật sự | Hiểu **vì sao** phải tách tầng | Làm **3 thứ chạy cùng lúc** |

**Điểm mấu chốt để nhớ:** Lab 5 khó ở chỗ *tư duy*, Lab 6 khó ở chỗ *vận hành*.

Lab 5 chạy 5 Flow lên màn hình **trông y hệt nhau** — toàn bộ giá trị nằm trong
cách code được nối với nhau, không nhìn thấy được bằng mắt.

Lab 6 cần **MySQL + Spring Boot + Flutter** sống cùng lúc. Chỉ cần một trong ba
chết là demo hỏng.

---

## 2. Lab 5 — chính là Spring Boot, nhưng ở phía app

Đây là chìa khoá để hiểu nhanh. Lab 5 **không phải kiến thức mới** nếu bạn từng
làm Spring Boot — nó là cùng một ý tưởng, đặt ở phía client.

| Spring Boot (đã biết) | Lab 5 (Flutter) | Nhiệm vụ |
|---|---|---|
| `@RestController` | `HomePage` | Nhận tương tác người dùng |
| `@Service` | `PostProvider` | Giữ trạng thái, điều phối |
| `ContactRepository` (interface) | `IPostRepository` | **Hợp đồng** — chỉ khai báo |
| Spring tự sinh implementation | `PostRepositoryImpl` | Làm thật |
| JPA chạy SQL | `PostDataSourceImpl` | Chạy SQL lên SQLite |
| `@Entity Contact` | `PostEntity` / `PostModel` | Dữ liệu |
| `@Autowired` | **GetIt** (`injection.dart`) | Nối các mảnh lại |

**Khác biệt lớn nhất:** Spring Boot nối dependency hộ bạn bằng `@Autowired`.
Flutter **không có** cơ chế đó — nên Lab 5 dạy tự nối bằng tay qua **GetIt**.

### Tại sao phải tách nhiều tầng đến vậy

Một câu: **để tầng trên không cần biết tầng dưới làm bằng gì.**

```
HomePage  →  PostProvider  →  IPostRepository      ← chỉ là hợp đồng
                                    ↑
                            PostRepositoryImpl     ← ai làm cũng được
                                    ↓
                             IPostDataSource       ← lại một hợp đồng nữa
                                    ↑
                           PostDataSourceImpl  →  DatabaseHelper  →  SQLite
```

Hai mũi tên hướng **lên** (`↑`) là toàn bộ tinh thần của lab. Tầng trên chỉ biết
hợp đồng; phần làm thật được cắm vào từ ngoài. Thuật ngữ gọi là
**Dependency Inversion**.

Bằng chứng cụ thể: xem **cải tiến 3** của nhóm trong `README.md`. Đổi **một
dòng** là dữ liệu chuyển từ SQLite sang RAM, mà `HomePage`, `PostProvider`,
`PostRepositoryImpl` không sửa dòng nào.

### 5 Flow = thêm từng tầng một

| Flow | Thêm gì | Nói cho dễ hiểu |
|---|---|---|
| 1 | `IPostRepository` | Tạo hợp đồng trước, dữ liệu còn giả |
| 2 | `PostRepositoryImpl` + SQLite | Thay dữ liệu giả bằng database thật |
| 3 | `PostModel` ↔ `PostEntity` | SQLite lưu `1/0`, app muốn `true/false` → cần phiên dịch |
| 4 | **GetIt** | Gom chỗ nối dependency về một file |
| 5 | `IPostDataSource` | Tách nốt phần chạy SQL ra sau một hợp đồng |

**Flow 3 là chỗ khó hiểu nhất.** Giải thích cho dễ: SQLite **không có kiểu
true/false**, nó chỉ lưu số `1` và `0`. Nếu để `PostEntity` mang số `1/0` thì cả
app phải nhớ *"1 nghĩa là đã like"* — hạn chế của database rò rỉ ra khắp nơi.
Nên có `PostModel` đứng giữa làm phiên dịch, **nhốt cái xấu xí đó lại trong tầng
data**.

---

## 3. Lab 6 — full-stack, nửa backend đã quen

### Nửa A — Backend Spring Boot

Nếu bạn từng làm Spring Boot thì phần này không có gì mới: `Contact` entity,
`ContactRepository extends JpaRepository`, `ContactService`, `ContactController`
với 5 endpoint.

| Method | Endpoint | Chức năng |
|---|---|---|
| GET | `/api/contacts` | Lấy toàn bộ |
| POST | `/api/contacts` | Tạo mới |
| PUT | `/api/contacts/{id}` | Cập nhật |
| DELETE | `/api/contacts/{id}` | Xoá |
| GET | `/api/contacts/search?keyword=` | Tìm theo tên |

> **Nhóm đổi SQL Server → MySQL** (thầy cho phép chọn tự do). Code Java **không
> đổi một dòng nào** — chỉ đổi JDBC driver trong `pom.xml` và connection string
> trong `application.properties`. JPA che hết khác biệt giữa hai hệ CSDL.

### Nửa B — Flutter gọi API

Phần cần học. Bản chất là một **chuỗi biến đổi dữ liệu**:

```
Server trả JSON  →  chuỗi text  →  Map  →  ContactModel  →  hiện lên UI
                                              ↑
                                    ContactModel.fromJson()
```

Chiều ngược lại khi tạo hoặc sửa:

```
ContactModel  →  toJson()  →  Map  →  chuỗi JSON  →  gửi lên server
```

### 4 Flow

| Flow | Thêm gì |
|---|---|
| 1 | Gọi `GET`, hiện danh sách |
| 2 | Thêm `toJson()` + màn hình xem JSON — **chỉ để nhìn thấy chiều ngược lại** |
| 3 | Đưa dữ liệu vào `Provider` + thêm `POST` tạo mới |
| 4 | Đủ CRUD + Search |

Flow 2 nhìn có vẻ thừa nhưng đừng bỏ qua khi thuyết trình — nó tồn tại chỉ để
làm cho khúc `Model → JSON` **hiện lên màn hình được**, tức là biến một khái
niệm trừu tượng thành thứ nhìn thấy.
