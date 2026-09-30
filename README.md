# 📱 VCall - Ứng Dụng Gọi Video Trực Tuyến (Flutter & Firebase)

> **Đồ án / Bài tập lớn:** Xây dựng ứng dụng di động gọi video trực tuyến hiện đại với Flutter và Firebase Backend.  
> **Link Repository:** [https://github.com/nguyenhuutridaicalamdong-hash/Video_call.git](https://github.com/nguyenhuutridaicalamdong-hash/Video_call.git)

---

## 📖 1. Giới thiệu tổng quan

**VCall** là ứng dụng di động hỗ trợ thực hiện cuộc gọi video chất lượng cao, giao diện hiện đại (Modern Clean UI) lấy cảm hứng từ các ứng dụng hàng đầu (FaceTime, Google Meet, WhatsApp). Ứng dụng đã được tích hợp Backend Firebase cho hệ thống xác thực tài khoản và đồng bộ dữ liệu người dùng.

### 🌟 Các tính năng chính (10 Màn hình):
1. **Màn hình Khởi động (Splash Screen):** Hiệu ứng logo chuyển động mượt mà, tự động điều hướng thông minh dựa trên trạng thái đăng nhập Firebase (`FirebaseAuth`).
2. **Màn hình Đăng nhập (Login Screen):** Đăng nhập an toàn qua Firebase Auth với kiểm tra hợp lệ email/mật khẩu, xử lý ngoại lệ và hiển thị thông báo lỗi trực quan (`SnackBar`).
3. **Màn hình Đăng ký (Register Screen):** Tạo tài khoản mới, tự động khởi tạo hồ sơ người dùng trong Firestore collection `users`.
4. **Màn hình Trang chủ (Home Screen):** Lời chào cá nhân hóa theo tài khoản đăng nhập (`Xin chào, {Tên} 👋`), danh sách liên hệ đang online, banner gọi nhanh và nút mô phỏng cuộc gọi đến (Demo Incoming Call).
5. **Màn hình Danh bạ (Contacts Screen):** Quản lý danh bạ với tìm kiếm thời gian thực, hiển thị trạng thái online/offline, avatar động và phím gọi nhanh.
6. **Màn hình Cuộc gọi đến (Incoming Call Screen):** Nền làm mờ (Glassmorphism effect), chuông rung, avatar phóng to cùng nút Nhấc máy (Xanh) và Từ chối (Đỏ).
7. **Màn hình Cuộc gọi Video (Video Call Screen):** Luồng video chính toàn màn hình, cửa sổ thu nhỏ Picture-in-Picture (PIP) camera trước, bộ đếm thời gian gọi trực tiếp cùng bộ điều khiển trực quan (Bật/tắt Mic, Cam, Loa ngoài, Đổi camera, Kết thúc).
8. **Màn hình Kết thúc cuộc gọi (Call Ended Screen):** Thống kê chi tiết thời lượng cuộc gọi, tùy chọn "Gọi lại" hoặc "Về trang chủ".
9. **Màn hình Nhật ký cuộc gọi (Call History Screen):** Lịch sử cuộc gọi đến/đi/nhỡ kèm mốc thời gian, thời lượng và nút gọi lại trực tiếp.
10. **Màn hình Trang cá nhân (Profile Screen):** Hiển thị Avatar, Tên, Email thật từ Firebase Firestore, huy hiệu online, các cài đặt tùy chỉnh và chức năng **Đăng xuất (Logout)** Firebase an toàn.

---

## 🛠️ 2. Công nghệ & Thư viện sử dụng

- **Ngôn ngữ:** Dart (>= 3.0.0)
- **Framework:** Flutter SDK (>= 3.13.0)
- **Kiến trúc:** Clean Architecture & Feature-First Directory Structure
- **Backend & Cơ sở dữ liệu:**
  - `firebase_core: ^4.15.0`: Khởi tạo dịch vụ Firebase
  - `firebase_auth: ^6.7.0`: Xác thực người dùng (Đăng ký, Đăng nhập, Đăng xuất, Đổi mật khẩu)
  - `cloud_firestore: ^6.10.0`: Cơ sở dữ liệu NoSQL thời gian thực lưu trữ thông tin User
  - `firebase_storage: ^13.6.0`: Lưu trữ hình ảnh và tệp tin
  - `firebase_messaging: ^16.7.0`: Hỗ trợ thông báo đẩy (Push Notification)
- **Quản lý mã nguồn:** Git & GitHub

---

## 💻 3. Yêu cầu môi trường cài đặt (Prerequisites)

Trước khi cài đặt dự án, máy tính cần được cài đặt sẵn:
1. **Git:** [Tải Git tại đây](https://git-scm.com/downloads) (Phiên bản >= 2.30)
2. **Flutter SDK:** [Tải Flutter SDK](https://docs.flutter.dev/get-started/install) (Phiên bản khuyến nghị: Flutter 3.16.x - 3.24.x trở lên)
3. **Mã nguồn IDE:** Visual Studio Code (khuyên dùng) hoặc Android Studio.
   - Cài tiện ích mở rộng trên VS Code: **Flutter**, **Dart**.
4. **Android SDK & Java JDK:** Đi kèm Android Studio (Java 17 khuyến nghị).
5. **Thiết bị chạy:**
   - Điện thoại thật Android (Android 8.0 trở lên) kết nối cáp USB, HOẶC
   - Máy ảo Android Studio (Android Emulator - Pixel / API 30+).

---

## 🚀 4. Hướng dẫn cài đặt & Chạy ứng dụng từ Git

### Bước 1: Clone (Tải mã nguồn) từ GitHub về máy
Mở **Terminal / PowerShell / Git Bash** trên máy tính và chạy:

```bash
# Clone dự án về máy tính
git clone https://github.com/nguyenhuutridaicalamdong-hash/Video_call.git

# Di chuyển vào thư mục dự án
cd Video_call
```

---

### Bước 2: Tải các gói thư viện (Dependencies)
```bash
flutter pub get
```

---

### Bước 3: Kiểm tra cấu hình Firebase
- File cấu hình Firebase Android [`android/app/google-services.json`](file:///d:/video_call_demo/android/app/google-services.json) **đã được tích hợp sẵn** trong repository.
- Bạn không cần cấu hình lại Firebase trừ khi muốn đổi sang project Firebase riêng.

---

### Bước 4: Dọn dẹp cache trước khi biên dịch (Khuyến nghị)
Để đảm bảo không bị lỗi khóa cache Gradle (`Incremental Cache Lock`):
```bash
flutter clean
flutter pub get
```

---

### Bước 5: Chạy ứng dụng

#### 👉 Cách A: Chạy trên Điện thoại thật (Khuyên dùng - Mượt & Nhanh nhất)
1. Trên điện thoại: Bật **Cài đặt** > **Thông tin điện thoại** > Chạm 7 lần vào **Số bản dựng** (Build Number) để bật chế độ nhà phát triển.
2. Vào **Tùy chọn nhà phát triển** > Gạt bật **Gỡ lỗi qua USB (USB Debugging)** *(với máy Xiaomi/Redmi bật thêm Cài đặt qua USB)*.
3. Cắm cáp USB nối điện thoại với máy tính > Chọn **Luôn cho phép gỡ lỗi từ máy tính này**.
4. Chạy lệnh:
   ```bash
   flutter run
   ```
   *(Hoặc chọn tên điện thoại ở góc dưới bên phải VS Code rồi bấm **F5**).*

#### 👉 Cách B: Chạy trên Máy ảo Android (Android Emulator)
1. Mở máy ảo Android Studio (ví dụ: `Pixel 7`).
2. Chờ máy ảo khởi động lên màn hình chính.
3. Nhấn **F5** trên VS Code hoặc gõ:
   ```bash
   flutter run
   ```

---

## 🔄 5. Hướng dẫn làm việc với Git cho thành viên nhóm

### Kéo code mới nhất về máy (Pull):
```bash
git pull origin main
flutter pub get
```

### Đẩy code mới lên GitHub (Commit & Push):
```bash
# 1. Kiểm tra các file đã thay đổi
git status

# 2. Thêm tất cả thay đổi vào vùng chuẩn bị
git add .

# 3. Ghi lại nội dung commit
git commit -m "feat: mo ta noi dung ban vua cap nhat"

# 4. Day len nhanh chinh
git push origin main
```

---

## ❓ 6. Khắc phục sự cố thường gặp (Troubleshooting)

| Lỗi gặp phải | Nguyên nhân | Cách khắc phục |
| :--- | :--- | :--- |
| `Gradle task assembleDebug failed` / `Could not close incremental caches` | Tiến trình Java/Gradle ngầm trên Windows khóa file cache. | Mở Terminal chạy: `Stop-Process -Name java -Force` sau đó chạy `flutter clean` và `flutter pub get`. |
| `No connected devices found` | Máy tính chưa nhận diện được điện thoại qua USB. | Kiểm tra lại dây cáp, đảm bảo đã bật "Gỡ lỗi qua USB", và cho phép xác thực trên màn hình điện thoại. |
| `FirebaseOptions cannot be null when creating the default app` | Chạy trên trình duyệt Web (Chrome) khi chưa có file cấu hình Web Firebase. | Chọn chạy trên thiết bị **Android (Điện thoại hoặc Máy ảo Pixel)**. |
| Màn hình vẫn hiện thông tin demo cũ | App đang chạy bản build cũ từ bộ nhớ tạm của điện thoại. | Bấm **Logout** trên màn hình Profile, hoặc gỡ cài đặt app trên điện thoại rồi chạy lại `flutter run`. |

---

## 👥 7. Thông tin nhóm phát triển
- **Đề tài:** Ứng dụng VCall - Video Call Mobile Application
- **Hệ điều hành thử nghiệm:** Windows 11, Android 13/14
- **Repository:** `Video_call`
