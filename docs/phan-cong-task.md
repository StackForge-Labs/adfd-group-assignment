# Phân công task — Lab 5 & Lab 6 (Team E)

Nhóm 4 người, mỗi lab 2 người, **mỗi người trình bày một phần riêng** (không
phải hai người nói chung một phần).

Đọc `docs/tong-quan-lab-5-6.md` **trước** khi đọc file này.

---

## Bảng phân công

| Phần | Ai làm | Nội dung | Cải tiến | Độ khó |
|---|---|---|---|:--:|
| **5A** | **Mai Trung Hậu** | Flow 1-3: hợp đồng, Repository, mapping | — | ●●●○ |
| **5B** | **Phạm Hoàng Tuấn** *(Leader)* | Flow 4-5: GetIt, Data Source, **cú lật một dòng** | 3 | ●●●● |
| **6A** | **Lê Minh Trí** | Backend + Flow 1-2: REST, JSON → Model | 4 | ●●○○ |
| **6B** | **Lâm Hoàng An** | Flow 3-4: Provider, CRUD, UI + **chạy demo** | 1, 2, 5 | ●●●○ |

### Vì sao chia như vậy

Hai lab khó theo **hai kiểu khác nhau**:

| | Lab 5 | Lab 6 |
|---|---|---|
| Khó về | **Thiết kế phần mềm** — abstraction, DI | **Kỹ thuật Flutter** — dialog, form, vòng đời |
| Chạy được không | Dễ, 1 tiến trình | Khó, **3 tiến trình phải sống cùng lúc** |
| Demo được giá trị không | **Không** — 5 flow trông y hệt nhau | Có, tự nó demo |
| Rủi ro hỏng trên sân khấu | Gần như 0 | **Cao** |

Kiến thức Lab 5 mang sang Java hay C# vẫn đúng — nó là thiết kế phần mềm nói
chung. Kiến thức Lab 6 chỉ Flutter mới có.

Câu hỏi khó nhất thầy có thể hỏi đều nằm ở Lab 5, và trả lời hời hợt là **lộ
ngay**. Vì vậy hai người vững nhất nhận Lab 5.

**Lưu ý về 6B:** nhìn bảng thì 6B chỉ ●●●○, nhưng đây là phần có **nhiều code
Flutter thực hành nhất** — tầng UI của Lab 6 là 643 dòng so với 146 dòng của
Lab 5, gấp 4,4 lần. Và 6B gánh toàn bộ rủi ro demo.

---

## 5A · "Vì sao phải tách tầng" — Flow 1, 2, 3

**Phạm vi:** Flow 1 → Flow 3

**File phải đọc** (trong `adfd05_architecture/lib/ex05/`):
- `domain/entities/post_entity.dart`
- `domain/repositories/i_post_repository.dart`
- `data/models/post_model.dart`
- `data/repositories/post_repository_impl.dart`
- `core/database/database_helper.dart`

**Khái niệm phải giải thích được:**
- Hợp đồng — `abstract class` trong Dart, tương đương interface trong Java
- Repository làm thật, đọc SQLite qua `DatabaseHelper`
- Mapping `PostModel ↔ PostEntity`

**Mạch nói:**
1. Flow 1 — dựng hợp đồng trước, dữ liệu còn giả
2. Flow 2 — thay ruột bằng SQLite, tầng trên **không đổi một dòng**
3. Flow 3 — vì sao cần `PostModel` đứng giữa

**Ba câu phải trả lời trôi chảy:**
- *"`IPostRepository` chỉ khai báo mà không làm gì, vậy nó để làm gì?"*
- *"`PostModel` với `PostEntity` giống nhau gần hết, sao không gộp làm một?"*
- *"Flow 2 thay in-memory bằng SQLite, những file nào phải sửa?"*

> **Học thuộc ý này cho câu 2:** SQLite **không có kiểu `true/false`**, nó lưu
> số `1` và `0`. Nếu để `PostEntity` mang số `1/0` thì cả app phải nhớ *"1 nghĩa
> là đã like"* — hạn chế của database rò rỉ ra khắp nơi. `PostModel` nhốt cái
> đó lại trong tầng data.

**Câu chuyển sang 5B:**
> *"Đến đây chúng ta có 4 tầng tách bạch. Nhưng ai là người nối chúng lại với
> nhau? Mời bạn **Tuấn**."*

---

## 5B · "Nối các mảnh và chứng minh" — Flow 4, 5 + cải tiến 3 ⭐

**Phần khó nhất trong cả bốn. Giao cho người vững nhất.**

**Phạm vi:** Flow 4 → Flow 5 + cải tiến 3

**File phải đọc:**
- `core/di/injection.dart`
- `data/data_sources/i_post_data_source.dart`
- `data/data_sources/post_data_source_impl.dart`
- `data/data_sources/in_memory_post_data_source.dart`
- `ex05_flow.dart`

**Khái niệm phải giải thích được:**
- GetIt — đăng ký và lấy dependency
- `IPostDataSource` — hợp đồng thứ hai
- **Dependency Inversion** — vì sao mũi tên phụ thuộc lại hướng lên

**Mạch nói:**
1. Flow 4 — gom chỗ nối dependency về một file
2. Flow 5 — tách nốt phần chạy SQL ra sau hợp đồng
3. **Cú lật** — đổi một dòng, đổi cả nguồn dữ liệu

**Điểm nhấn của cả buổi — làm live trên máy:**

```dart
// adfd05_architecture/lib/ex05/core/di/injection.dart
const bool useInMemoryDataSource = false;   // → đổi thành true
```

Chạy lại. App y hệt: Read, Like/Dislike, Search đều hoạt động. Dữ liệu đến từ
RAM thay vì SQLite. **Không file nào khác phải sửa** — không Repository, không
Provider, không UI.

**Ba câu phải trả lời trôi chảy:**
- *"GetIt giải quyết vấn đề gì mà tự `new` object không giải quyết được?"*
- *"`registerLazySingleton` khác `registerFactory` chỗ nào?"*
- *"Chứng minh đi — vì sao đổi Data Source mà Provider không phải sửa?"*

> **Chuẩn bị sẵn cho câu 1:** không phải để "đỡ phải gõ `new`". Mà để **nơi
> quyết định dùng implementation nào** tách khỏi **nơi sử dụng nó**.
> `PostProvider` chỉ khai báo *"tôi cần một `IPostRepository`"* — ai đưa vào là
> chuyện của `injection.dart`.

> **Cho câu 2:** `LazySingleton` tạo **một lần duy nhất**, lần đầu có người hỏi
> tới, rồi dùng lại mãi. `Factory` tạo **mới mỗi lần** được hỏi.

**Câu chuyển sang Lab 6:**
> *"Kiến trúc này nhóm em không chỉ dùng cho Lab 5. Lab 6 gọi API thật từ
> server, và dùng lại đúng khung vừa rồi. Mời bạn **Trí**."*

---

## 6A · "Đường ống dữ liệu" — Backend + Flow 1, 2 + cải tiến 4

**Phạm vi:** toàn bộ backend + Flow 1 (HTTP GET) + Flow 2 (JSON ↔ Model)

**File phải đọc:**
- `adfd06_rest_api/adfd06_backend/src/` (toàn bộ)
- `db/init.sql`
- `adfd06_rest_api/adfd06_frontend/lib/ex01/`, `ex02/`

**Khái niệm phải giải thích được:**
- 5 endpoint REST và chức năng từng cái
- Chuỗi `HTTP → JSON → Map → ContactModel`
- Vì sao đổi SQL Server → MySQL chỉ tốn 2 dòng
- Cải tiến 4 — ràng buộc schema

**Mở đầu Lab 6 bằng một câu bắc cầu (~30 giây):**
> *"Kiến trúc các bạn vừa nghe ở Lab 5, nhóm em áp dụng nguyên vào Lab 6. Chi
> tiết bạn **An** sẽ nói ở phần sau. Phần em là dữ liệu đi từ database lên tới
> Model."*

**Cải tiến 4 là điểm ăn tiền của phần này:**

```
POST /api/contacts  {}
→ trước khi sửa: 200 OK, tạo bản ghi toàn null
→ sau khi sửa:   bị từ chối

POST /api/contacts  {"name":"Test","phone":"<200 ký tự>"}
→ trước khi sửa: 200 OK, lưu đủ 200 ký tự (đề bài giới hạn 20)
→ sau khi sửa:   bị từ chối
```

Nguyên nhân: entity `Contact` thiếu `@Column`, cộng với
`spring.jpa.hibernate.ddl-auto=update` khiến Hibernate lấy mặc định của nó
(`varchar(255)`, cho phép null) và **ghi đè lên schema** đã tạo từ script DDL.

> ⚠️ **Cái này KHÔNG nằm trong vùng "cả nhóm đã biết Spring Boot".** Biết
> Controller / Service / Repository không tự động biết hành vi này của
> Hibernate. Phải hiểu thật, vì đây là câu dễ bị hỏi vặn.

**Ba câu phải trả lời trôi chảy:**
- *"Đổi từ SQL Server sang MySQL phải sửa những gì?"*
- *"`fromJson` biến JSON thành Model bằng cách nào?"*
- *"Vì sao thiếu `@Column` lại làm mất ràng buộc `not null`?"*

**Câu chuyển sang 6B:**
> *"Dữ liệu đã về tới Model. Giờ làm sao đưa nó lên màn hình và cho người dùng
> thao tác? Mời bạn **An**."*

---

## 6B · "Ứng dụng hoàn chỉnh" — Flow 3, 4 + cải tiến 1, 2, 5 + demo

**Phần cần nhiều kỹ năng Flutter thực hành nhất.**

**Phạm vi:** Flow 3 → Flow 4 + cải tiến 1, 2, 5 + **chạy demo**

**File phải đọc:**
- `adfd06_rest_api/adfd06_frontend/lib/ex04/presentation/` (643 dòng)
- `.../ex04/core/network/api_client.dart`
- `.../ex04/core/di/injection.dart`
- `docs/cau-truc-du-an.md`

**Khái niệm phải giải thích được:**
- `StatefulWidget` và vòng đời `initState` / `dispose`
- `TextEditingController` — tạo ở đâu, huỷ ở đâu, **vì sao phải huỷ**
- `showDialog` + `Navigator.pop` trả giá trị về
- **`context.mounted` sau `await`**
- Ba trạng thái: loading / error / data

**Kịch bản demo — theo đúng thứ tự:**

1. Danh sách hiện ra từ MySQL thật
   *(mở phpMyAdmin ở `localhost:8080` song song để đối chiếu)*
2. Thêm contact → F5 phpMyAdmin → **dòng mới xuất hiện trong database**
3. Search → sửa → xoá
4. **Tắt backend** → mở lại app → màn báo lỗi thay vì spinner quay mãi →
   bật backend → bấm **Thử lại** → danh sách hiện ra

> Bước 4 chính là cải tiến 1, và gây ấn tượng mạnh nhất — nó cho thấy nhóm nghĩ
> tới cả trường hợp hỏng, không chỉ đường đi đẹp.

**Ba câu phải trả lời trôi chảy:**
- *"`context.mounted` để làm gì, bỏ đi thì sao?"*
- *"Vì sao `ContactProvider` không gọi thẳng `ApiService`?"*
- *"Vì sao không nối chuỗi `'?keyword=' + keyword`?"*

> **Câu 1 là câu đặc trưng Flutter nhất trong cả buổi:** sau `await`, widget
> **có thể đã bị huỷ** (người dùng bấm back trong lúc chờ mạng). Dùng `context`
> lúc đó là crash. Lab 5 không có `await` nằm giữa thao tác người dùng và điều
> hướng nên không bao giờ gặp.

> **Câu 3:** dấu cách và tiếng Việt có dấu thì `Uri.parse` tự encode nên không
> sao. Nhưng `A&B` bị cắt thành `A`, `C#1` bị cắt thành `C`, `a+b` thành `a b`.
> Riêng `&` còn chèn thêm query param — là lỗ hổng query injection.

---

## Thứ tự trình bày — bắt buộc

```
5A  →  5B  →  6A  →  6B
```

**Không đảo được.** Lab 6 dùng lại kiến trúc của Lab 5, nên nếu nói Lab 6 trước
thì cặp Lab 6 phải tự giải thích Clean Architecture — đúng thứ họ không chuẩn bị.

Hệ quả: rủi ro demo của Lab 6 **không gỡ được bằng thứ tự**, phải gỡ hoàn toàn
bằng chuẩn bị.

---

## Chuẩn bị trước ngày demo

**Cả nhóm:**
- [ ] Ai cũng đọc `docs/tong-quan-lab-5-6.md` trước, rồi mới đọc phần của mình
- [ ] Trí và An đọc thêm `docs/cau-truc-du-an.md` — vì thầy hỏi ai đang đứng
      trên bục, không hỏi người ngồi dưới
- [ ] Tổng duyệt một lần có **hỏi vặn chéo**: mỗi người trả lời 3 câu trong
      phần của mình ở trên. Ai lắp bắp là biết chỗ nào chưa hiểu, còn kịp sửa.

**Riêng An (6B) — quan trọng nhất:**
- [ ] Tự dựng môi trường từ đầu **trên máy của chính mình**, không phải chỉ xem
      người khác dựng (làm theo mục *Cài đặt môi trường* trong `README.md`)
- [ ] Quay sẵn **video demo 2-3 phút** làm phương án dự phòng
- [ ] Chạy hết checklist cuối `README.md` ngay trước giờ trình bày
- [ ] **Bật sẵn mọi thứ trước khi lên** — Docker, backend, emulator, app đã mở.
      Không khởi động bất cứ thứ gì trên sân khấu.

---

## Nếu thiếu thời gian, cắt theo thứ tự này

Cắt từ dưới lên, giữ lại phần trên cùng:

| Ưu tiên | Nội dung |
|---|---|
| **Không được cắt** | Cú lật một dòng (5B) — điểm nhấn của cả buổi |
| **Không được cắt** | Demo CRUD của Lab 6 (6B) |
| Giữ nếu còn thời gian | Cải tiến 1 — tắt backend, màn báo lỗi |
| Cắt được | Flow 2 của Lab 6 (JSON Preview) |
| Cắt được | Cải tiến 2 và 4 — nói gọn một câu là đủ |

---

## Slide thuyết trình

Slide là **sản phẩm chung của cả nhóm**, nhưng có người chịu trách nhiệm chính
để tránh cảnh "ai cũng làm một tí rồi không ai chốt".

| Vai trò | Ai | Việc cụ thể |
|---|---|---|
| **Làm chính** | **Mai Trung Hậu** · **Lâm Hoàng An** | Dựng bố cục, viết nội dung, làm hình và sơ đồ |
| **Góp ý & duyệt** | **Phạm Hoàng Tuấn** · **Lê Minh Trí** | Đọc bản nháp, chỉ ra chỗ sai/thiếu/khó hiểu, chốt bản cuối |

Hai người làm chính dựng bản nháp trước, hai người còn lại góp ý theo vòng, lặp
tới khi cả nhóm đồng ý. **Người trình bày phần nào phải duyệt slide phần đó** —
không ai đứng nói trên slide mình chưa từng đọc.

### Công cụ dự kiến

**Claude · Canva · NotebookLM · Gemini** — hoặc công cụ khác nếu thấy hợp hơn.

Gợi ý phân vai công cụ:

| Công cụ | Hợp để làm gì |
|---|---|
| **Claude** | Viết nội dung từng slide, sinh sơ đồ kiến trúc, rút gọn phần giải thích dài |
| **Canva** | Dựng hình, thống nhất màu và bố cục |
| **NotebookLM** | Nạp 4 file trong `docs/` vào rồi hỏi đáp — tiện cho người muốn nắm nhanh phần của mình |
| **Gemini** | Đối chiếu, tìm góc nhìn khác cho phần giải thích khó |

### Nguyên tắc nội dung slide

- **Sơ đồ thắng chữ.** Chuỗi phụ thuộc, luồng dữ liệu, `HTTP → JSON → Model` —
  vẽ ra thay vì viết thành đoạn văn.
- **Mỗi slide một ý.** Slide nhồi 5 gạch đầu dòng là không ai đọc kịp.
- **Code trên slide phải ngắn.** Chỉ chiếu đoạn thật sự đang nói tới, tối đa
  khoảng 10 dòng. Muốn xem đầy đủ thì mở editor.
- **Nguồn nội dung lấy từ `docs/`** — bốn file đó đã có sẵn sơ đồ, bảng so sánh
  và số liệu. Đừng viết lại từ đầu, và đừng để slide nói khác tài liệu.
- Bốn phần trình bày phải **dùng chung một bộ màu và một mẫu slide**, nếu không
  sẽ lộ ra là bốn người làm rời rạc.

### Mốc thời gian gợi ý

| Việc | Ai |
|---|---|
| 1. Chốt dàn ý slide cho cả 4 phần | Cả nhóm |
| 2. Dựng bản nháp | Hậu · An |
| 3. Vòng góp ý thứ nhất | Tuấn · Trí |
| 4. Chỉnh sửa | Hậu · An |
| 5. Tổng duyệt có **hỏi vặn chéo** | Cả nhóm |
| 6. Chốt bản cuối + xuất PDF dự phòng | Hậu · An |

> **Bước 6 đừng bỏ:** luôn xuất một bản PDF để trong USB hoặc gửi lên Drive.
> Máy chiếu ở trường hay giở chứng với file lạ, và Canva thì cần mạng.

### Một lưu ý về khối lượng công việc

Nhìn tổng thể, **An đang gánh nặng nhất**: phần 6B là phần nhiều code Flutter
nhất, kiêm luôn chạy demo, cộng thêm làm slide chính. Trong khi **Trí** giữ phần
6A nhẹ nhất và chỉ góp ý slide.

Nếu tới sát ngày thấy An quá tải, cân nhắc chuyển bớt sang Trí — hợp lý nhất là
để Trí **dựng môi trường Lab 6 cùng An** và làm người chạy demo dự phòng. Hai
người cùng dựng được môi trường thì rủi ro demo giảm hẳn, vì hỏng còn có người
thứ hai gỡ.
