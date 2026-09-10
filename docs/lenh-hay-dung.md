# Các lệnh cần dùng cho Lab 5 & Lab 6

Chỉ gồm lệnh **thực sự dùng trong dự án này**, không liệt kê toàn bộ Flutter.
Sắp xếp theo thứ tự bạn sẽ cần tới chúng.

Mọi lệnh đều chạy ở **terminal**, đứng đúng thư mục ghi trong từng mục.

> **Hay gõ nhầm:** là `flutter pub get`, **không phải** `flutter get pub`.
> Cấu trúc luôn là `flutter <nhóm> <hành động>`.

---

## 1. Kiểm tra môi trường — làm một lần lúc đầu

```bash
flutter --version          # phiên bản Flutter và Dart
flutter doctor             # kiểm tra toàn bộ môi trường
flutter doctor -v          # bản chi tiết, dùng khi cần tìm nguyên nhân
```

Cần thấy `[✓]` ở **Flutter** và **Android toolchain**. Xcode và Chrome không bắt
buộc cho dự án này.

> ⚠️ Nếu `flutter doctor` báo `✗ Android license status unknown` **dù đã accept
> hết** — đó là báo động giả, xem `README.md` mục *Cài đặt môi trường*.

Với Lab 6 cần thêm:

```bash
java -version              # cần 21 trở lên
mvn -version               # cần 3.9+
docker --version           # Docker Desktop phải đang chạy
```

---

## 2. Máy ảo Android

```bash
flutter emulators                        # xem danh sách máy ảo đang có
flutter emulators --launch pixel_dev     # bật máy ảo tên pixel_dev
flutter devices                          # xem thiết bị Flutter đang nhận
```

`flutter devices` phải hiện dòng có chữ `android` thì mới chạy app được, ví dụ:

```
sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64 • Android 16 (API 36)
```

Cột giữa (`emulator-5554`) chính là **device id**, dùng cho `-d` ở các lệnh sau.

> **Máy ảo mới tạo mặc định bật chế độ máy bay** → app không gọi được API. Tắt:
> ```bash
> adb shell cmd connectivity airplane-mode disable
> ```

---

## 3. Chạy Lab 5

Lab 5 không cần backend, chỉ cần Flutter và máy ảo.

```bash
cd adfd05_architecture
flutter pub get                     # tải package — chạy lần đầu và mỗi khi đổi pubspec
flutter run -d emulator-5554        # chạy app
```

Đổi Flow: mở `lib/main.dart`, bỏ comment **một** dòng `import`, rồi bấm `R`
(hot restart) trong terminal đang chạy.

---

## 4. Chạy Lab 6 — ba tiến trình

Phải theo đúng thứ tự này.

### Bước 1 — MySQL

```bash
# nếu máy chưa có MySQL
docker compose up -d

# kiểm tra dữ liệu đã có chưa (phải ra 5)
docker exec -i adfd_mysql mysql -uroot -p112233 \
  -e "SELECT COUNT(*) FROM adfddb.contacts;"
```

> **Tên container tuỳ máy.** `adfd_mysql` là tên do `docker-compose.yml` đặt.
> Nếu máy bạn đã có sẵn MySQL khác thì xem tên thật bằng `docker ps`, và nạp
> schema vào cái sẵn có: `docker exec -i <tên> mysql -uroot -p<mật-khẩu> < db/init.sql`

### Bước 2 — Backend Spring Boot

```bash
cd adfd06_rest_api/adfd06_backend
mvn clean package -DskipTests                          # build ra file .jar
java -jar target/adfd06_rest_api-0.0.1-SNAPSHOT.jar    # chạy, cổng 8082
```

Terminal này **giữ nguyên**, đừng đóng. Mở terminal khác để làm việc tiếp.

Kiểm tra backend sống chưa — **luôn làm bước này trước khi đổ lỗi cho app**:

```bash
curl http://localhost:8082/api/contacts
```

### Bước 3 — Flutter

```bash
cd adfd06_rest_api/adfd06_frontend
flutter pub get
flutter run -d emulator-5554
```

---

## 5. Phím bấm khi đang `flutter run`

Terminal sẽ **không trả lại dấu nhắc** — đó là bình thường, nó đang gắn với app.

| Phím | Tác dụng |
|---|---|
| `r` | **Hot reload** — giữ nguyên state, áp dụng thay đổi trong `build()` |
| `R` | **Hot restart** — xoá sạch state, chạy lại từ `main()` |
| `v` | Mở **DevTools** trên trình duyệt |
| `q` | Thoát |

> **Sửa rồi mà không thấy đổi?** Bấm `R` trước khi nghi ngờ code. Hot reload
> không áp dụng được thay đổi ở `main()`, `initState()`, giá trị khởi tạo biến
> `State`, hay biến `static`.

---

## 6. Lệnh dùng hằng ngày khi code

```bash
flutter analyze            # tìm lỗi và cảnh báo — phải sạch trước khi commit
dart format lib/           # format code theo chuẩn Dart
dart format .              # format cả project
```

`flutter analyze` chạy **bên trong từng project**, không chạy ở gốc repo — vì
hai project Flutter ở đây độc lập với nhau, không dùng pub workspace.

---

## 7. Khi thêm package mới

```bash
flutter pub add http               # thêm package
flutter pub add provider get_it    # thêm nhiều cái một lúc
flutter pub remove http            # gỡ
flutter pub get                    # đồng bộ lại sau khi sửa tay pubspec.yaml
flutter pub outdated               # xem package nào có bản mới
```

> **Đừng tự nâng version package** trong lúc chuẩn bị thuyết trình. Demo phải
> chạy được y hệt vào ngày trình bày.

Các package dự án này đang dùng:

| Project | Package |
|---|---|
| Lab 5 | `provider` `sqflite` `path` `get_it` |
| Lab 6 | `http` `provider` `get_it` |

---

## 8. Build và cài APK

Dùng khi muốn cài app lên máy ảo mà không cần giữ terminal `flutter run`.

```bash
flutter build apk --debug                    # build bản debug
flutter install --debug -d emulator-5554     # cài lên máy ảo
```

> Cách này **không có hot reload**. Sửa code là phải build lại từ đầu. Chỉ dùng
> khi cần cài nhanh, còn lúc code thì luôn dùng `flutter run`.

---

## 9. Khi gặp sự cố

```bash
flutter clean              # xoá thư mục build và cache
flutter pub get            # rồi tải lại package
```

Dùng `flutter clean` khi: build lỗi không rõ nguyên nhân, vừa đổi tên hoặc di
chuyển thư mục project, hoặc đổi nhánh git mà app hành xử lạ.

Lệnh `adb` — không nằm sẵn trong `PATH`, đường dẫn đầy đủ:

- macOS: `~/Library/Android/sdk/platform-tools/adb`
- Windows: `%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe`

```bash
adb devices                                        # xem máy ảo có kết nối không
adb shell cmd connectivity airplane-mode disable   # tắt chế độ máy bay
adb logcat -d -t 100 | grep flutter                # xem 100 dòng log gần nhất
adb exec-out screencap -p > anh.png                # chụp màn hình máy ảo
```

`adb logcat` là chỗ **duy nhất** thấy được lỗi Dart khi app không chạy bằng
`flutter run` — ví dụ lúc demo bằng APK đã cài sẵn.

---

## 10. Test API bằng `curl` — cho Lab 6

Dùng để kiểm backend trước khi động vào Flutter.

```bash
B=http://localhost:8082/api/contacts

curl -s $B                                   # GET tất cả
curl -s -G $B/search --data-urlencode "keyword=Emily"   # search

curl -s -X POST $B -H 'Content-Type: application/json' \
  -d '{"name":"Test","email":"t@gmail.com","phone":"0900000000","address":"Q1"}'

curl -s -X PUT $B/1 -H 'Content-Type: application/json' \
  -d '{"name":"Sua","email":"s@gmail.com","phone":"0911111111","address":"Q2"}'

curl -s -X DELETE $B/1
```

> Dùng `-G` với `--data-urlencode` cho search thay vì nối chuỗi vào URL — nếu
> không thì từ khoá có `&` hoặc `#` sẽ bị cắt. Đây chính là **cải tiến 2**.

---

## Bảng tra nhanh

| Muốn làm gì | Lệnh |
|---|---|
| Kiểm tra môi trường | `flutter doctor` |
| Xem thiết bị đang có | `flutter devices` |
| Bật máy ảo | `flutter emulators --launch pixel_dev` |
| Tải package | `flutter pub get` |
| Thêm package | `flutter pub add <tên>` |
| Chạy app | `flutter run -d emulator-5554` |
| Hot reload / restart | phím `r` / `R` |
| Tìm lỗi | `flutter analyze` |
| Format code | `dart format lib/` |
| Dọn khi lỗi lạ | `flutter clean` |
| Build backend | `mvn clean package -DskipTests` |
| Chạy backend | `java -jar target/adfd06_rest_api-0.0.1-SNAPSHOT.jar` |
| Bật MySQL | `docker compose up -d` |
| Kiểm API | `curl http://localhost:8082/api/contacts` |
