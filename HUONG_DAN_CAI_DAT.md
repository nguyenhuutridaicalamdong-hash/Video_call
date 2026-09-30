# 📄 BÁO CÁO TÀI LIỆU HƯỚNG DẪN CÀI ĐẶT DỰ ÁN VCALL
### (Installation & Deployment Guide - Git & Documentation)

---

## MỤC LỤC
1. [GIỚI THIỆU DỰ ÁN VÀ CẤU TRÚC THƯ MỤC](#1-giới-thiệu-dự-án-và-cấu-trúc-thư-mục)
2. [YÊU CẦU PHẦN CỨNG & PHẦN MỀM](#2-yêu-cầu-phần-cứng--phần-mềm)
3. [HƯỚNG DẪN CÀI ĐẶT MÔI TRƯỜNG PHÁT TRIỂN](#3-hướng-dẫn-cài-đặt-môi-trường-phát-triển)
4. [HƯỚNG DẪN THAO TÁC VỚI GIT (CLONE, PULL, COMMIT, PUSH)](#4-hướng-dẫn-thao-tác-với-git)
5. [CẤU HÌNH VÀ TÍCH HỢP FIREBASE BACKEND](#5-cấu-hình-và-tích-hợp-firebase-backend)
6. [HƯỚNG DẪN BIÊN DỊCH VÀ CHẠY ỨNG DỤNG](#6-hướng-dẫn-biên-dịch-và-chạy-ứng-dụng)
7. [KỊCH BẢN KIỂM THỬ CÁC TÍNH NĂNG CHÍNH](#7-kịch-bản-kiểm-thử-các-tính-năng-chính)
8. [CÁC LỖI THƯỜNG GẶP VÀ CÁCH KHẮC PHỤC (TROUBLESHOOTING)](#8-các-lỗi-thường-gặp-và-cách-khắc-phục)

---

## 1. GIỚI THIỆU DỰ ÁN VÀ CẤU TRÚC THƯ MỤC

### 1.1. Thông tin chung
- **Tên dự án:** VCall - Video Call Mobile Application
- **Công nghệ chính:** Flutter (Dart), Firebase Authentication, Cloud Firestore
- **Địa chỉ kho lưu trữ (GitHub):**  
  `https://github.com/nguyenhuutridaicalamdong-hash/Video_call.git`

### 1.2. Cấu trúc thư mục mã nguồn
```text
video_call_demo/
├── android/                        # Cấu hình dự án cho nền tảng Android
│   ├── app/
│   │   ├── build.gradle.kts       # Cấu hình build Gradle của ứng dụng
│   │   └── google-services.json   # Cấu hình kết nối Backend Firebase Android
│   ├── gradle.properties          # Tinh chỉnh JVM & tắt cache lock (kotlin.incremental=false)
│   └── settings.gradle.kts        # Quản lý plugin Gradle và Google Services
├── lib/                            # Toàn bộ mã nguồn Dart của ứng dụng
│   ├── core/                      # Các thành phần cốt lõi dùng chung
│   │   ├── routes/app_routes.dart # Quản lý định tuyến 10 màn hình
│   │   └── theme/app_colors.dart  # Bảng màu sắc, chủ đề giao diện hiện đại
│   ├── data/                      # Dữ liệu tĩnh (Mock Data cho demo cuộc gọi)
│   ├── models/                    # Lớp mô hình dữ liệu (Contact, CallHistory, User)
│   ├── screens/                   # Giao diện các màn hình chức năng
│   │   ├── auth/                  # Màn hình Đăng nhập (Login) & Đăng ký (Register)
│   │   ├── call/                  # Màn hình Cuộc gọi đến, Gọi video, Kết thúc gọi
│   │   ├── calls/                 # Lịch sử cuộc gọi
│   │   ├── contacts/              # Danh bạ người dùng
│   │   ├── home/                  # Màn hình Trang chủ
│   │   ├── profile/               # Trang cá nhân và Đăng xuất
│   │   ├── splash/                # Màn hình khởi động
│   │   └── main_wrapper.dart      # Thanh điều hướng BottomNavigationBar
│   ├── services/
│   │   └── auth_service.dart      # Xử lý logic Firebase Auth & Firestore Users
│   └── main.dart                  # Điểm khởi chạy chính của ứng dụng Flutter
├── pubspec.yaml                   # Khai báo các thư viện phụ thuộc (Dependencies)
└── README.md                      # Tài liệu tổng quan dự án
```

---

## 2. YÊU CẦU PHẦN CỨNG & PHẦN MỀM

### 2.1. Yêu cầu phần cứng
- **CPU:** Tối thiểu Intel Core i3 / AMD Ryzen 3 trở lên (Khuyến nghị i5/Ryzen 5 trở lên).
- **RAM:** Tối thiểu 8 GB RAM (Khuyến nghị 16 GB để chạy đồng thời Android Studio và máy ảo mượt mà).
- **Ổ cứng:** Còn trống tối thiểu 10 GB dung lượng (nên dùng ổ SSD).
- **Điện thoại Android:** Android phiên bản 8.0 trở lên kèm cáp kết nối máy tính.

### 2.2. Yêu cầu phần mềm
- **Hệ điều hành:** Windows 10/11 64-bit, macOS hoặc Linux.
- **Git:** Phiên bản 2.30 trở lên.
- **Flutter SDK:** Phiên bản từ 3.13.0 trở lên (khuyên dùng Flutter 3.19.x - 3.24.x).
- **Java Development Kit (JDK):** JDK 17 (đã tích hợp sẵn trong Android Studio).
- **Trình soạn thảo mã nguồn:** Visual Studio Code hoặc Android Studio.

---

## 3. HƯỚNG DẪN CÀI ĐẶT MÔI TRƯỜNG PHÁT TRIỂN

### Bước 3.1: Cài đặt Git
1. Tải bộ cài Git tại trang chủ: [https://git-scm.com/download/win](https://git-scm.com/download/win).
2. Tiến hành cài đặt với các tùy chọn mặc định.
3. Kiểm tra cài đặt thành công bằng cách mở CMD / PowerShell gõ:
   ```bash
   git --version
   ```

### Bước 3.2: Cài đặt Flutter SDK
1. Tải bản nén Flutter SDK từ trang chủ [flutter.dev](https://docs.flutter.dev/get-started/install/windows).
2. Giải nén vào thư mục ngắn, ví dụ: `C:\src\flutter`.
3. Thêm đường dẫn `C:\src\flutter\bin` vào biến môi trường hệ thống (**Path** trong System Environment Variables).
4. Mở PowerShell gõ kiểm tra:
   ```bash
   flutter --version
   flutter doctor
   ```

### Bước 3.3: Cài đặt VS Code và Extensions
1. Cài đặt VS Code từ: [https://code.visualstudio.com/](https://code.visualstudio.com/).
2. Mở tab **Extensions** (`Ctrl + Shift + X`), tìm và cài đặt:
   - **Flutter** (bởi Flutter Team)
   - **Dart** (bởi Dart Code)

---

## 4. HƯỚNG DẪN THAO TÁC VỚI GIT

### 4.1. Lấy mã nguồn dự án về máy (Clone)
Mở Terminal tại thư mục bạn muốn lưu bài làm (ví dụ ổ `D:\`):
```bash
git clone https://github.com/nguyenhuutridaicalamdong-hash/Video_call.git
cd Video_call
```

### 4.2. Cập nhật mã nguồn mới nhất từ nhóm (Pull)
Mỗi khi thành viên khác trong nhóm đẩy code mới lên:
```bash
git pull origin main
flutter pub get
```

### 4.3. Đẩy code của mình lên GitHub (Add, Commit, Push)
Khi bạn vừa hoàn thiện tính năng hoặc sửa lỗi:
```bash
# 1. Xem các file vừa sửa đổi
git status

# 2. Thêm file vào vùng commit
git add .

# 3. Tạo commit kèm mô tả rõ ràng
git commit -m "feat: mo ta tinh nang vua hoan thanh"

# 4. Day code len nhanh chinh
git push origin main
```

---

## 5. CẤU HÌNH VÀ TÍCH HỢP FIREBASE BACKEND

Dự án sử dụng cơ sở hạ tầng đám mây của **Google Firebase**:
- **Authentication:** Quản lý tài khoản đăng ký bằng Email & Mật khẩu.
- **Cloud Firestore:** Lưu trữ dữ liệu hồ sơ User tại đường dẫn `/users/{uid}` gồm các trường:
  - `uid`: Mã định danh người dùng.
  - `name`: Tên đầy đủ người dùng.
  - `email`: Địa chỉ hòm thư điện tử.
  - `createdAt`: Thời gian tạo tài khoản trên máy chủ (`FieldValue.serverTimestamp()`).
  - `isOnline`: Trạng thái hoạt động (`true` khi đăng nhập, `false` khi đăng xuất).
  - `avatarUrl`: Đường dẫn ảnh đại diện.

> **Ghi chú quan trọng:** File cấu hình `android/app/google-services.json` đã được đính kèm sẵn trong kho lưu trữ Git. Bạn không cần tải lại file này.

---

## 6. HƯỚNG DẪN BIÊN DỊCH VÀ CHẠY ỨNG DỤNG

### Bước 6.1: Cài đặt thư viện phụ thuộc
Trong thư mục dự án, chạy:
```bash
flutter pub get
```

### Bước 6.2: Dọn dẹp cache tránh lỗi xung đột Gradle
```bash
flutter clean
flutter pub get
```

### Bước 6.3: Lựa chọn thiết bị chạy

#### Cách 1: Chạy trực tiếp trên Điện thoại thật Android (Khuyên dùng)
1. Trên điện thoại: Vào **Cài đặt** > **Thông tin thiết bị** > Nhấn **7 lần vào Số bản dựng** (Build Number).
2. Vào **Cài đặt bổ sung** > **Tùy chọn nhà phát triển** > Bật **Gỡ lỗi qua USB (USB Debugging)**.
   *(Riêng hãng Xiaomi/Redmi: Bật thêm "Cài đặt qua USB").*
3. Cắm dây cáp kết nối điện thoại với máy tính, trên điện thoại bấm chọn **Cho phép gỡ lỗi từ máy tính này**.
4. Mở VS Code, click vào góc dưới cùng bên phải chọn tên điện thoại của bạn, sau đó nhấn **F5** hoặc chạy lệnh:
   ```bash
   flutter run
   ```

#### Cách 2: Chạy trên Máy ảo Android (Android Emulator)
1. Bật máy ảo trong Android Studio (Ví dụ: `Pixel 7`).
2. Trong VS Code chọn thiết bị máy ảo.
3. Nhấn **F5** để khởi chạy ứng dụng.

---

## 7. KỊCH BẢN KIỂM THỬ CÁC TÍNH NĂNG CHÍNH

| STT | Chức năng kiểm thử | Các bước thực hiện | Kết quả mong đợi |
| :---: | :--- | :--- | :--- |
| **1** | Mở ứng dụng (Splash) | Khởi động app từ biểu tượng màn hình. | Hiện logo VCall chuyển động trong 2.5s, tự động chuyển đến màn hình Login nếu chưa đăng nhập. |
| **2** | Đăng ký tài khoản | Nhập Tên, Email, Mật khẩu, Xác nhận mật khẩu tại Register Screen. Bấm "Create Account". | Đăng ký thành công lên Firebase Auth, tạo tài khoản trong Firestore và chuyển thẳng vào Trang chủ. |
| **3** | Đăng nhập tài khoản | Nhập Email & Mật khẩu vừa tạo tại Login Screen. Bấm "Login". | Đăng nhập thành công, hiển thị đúng tên người dùng trên thanh tiêu đề Trang chủ. |
| **4** | Đăng nhập sai | Nhập sai mật khẩu hoặc email chưa đăng ký. | Firebase chặn lại, hiển thị thông báo lỗi `SnackBar` ở góc dưới màn hình. |
| **5** | Xem hồ sơ (Profile) | Chuyển sang tab Profile trên thanh điều hướng dưới. | Hiển thị chính xác Tên và Email của tài khoản đã đăng nhập; có huy hiệu Online xanh. |
| **6** | Mô phỏng cuộc gọi | Tại Trang chủ, nhấn nút chuông "Demo Incoming Call". | Hiển thị màn hình cuộc gọi đến với hiệu ứng mờ nền, tên người gọi và nút nhận/từ chối. |
| **7** | Cuộc gọi video | Nhấn nút Xanh nhận cuộc gọi. | Chuyển vào màn hình Video Call với thời gian đếm giây thực tế, ô xem trước camera thu nhỏ (PIP) và thanh công cụ Mic/Cam. |
| **8** | Đăng xuất (Logout) | Tại Profile, bấm nút Logout đỏ > Xác nhận "Logout". | Đăng xuất khỏi Firebase, cập nhật trạng thái offline và điều hướng trở lại màn hình Đăng nhập. |

---

## 8. CÁC LỖI THƯỜNG GẶP VÀ CÁCH KHẮC PHỤC

### 8.1. Lỗi khóa cache Gradle (`Incremental Cache Lock`):
- **Hiện tượng:** `Execution failed for task ':firebase_core:compileDebugKotlin'` hoặc `Could not close incremental caches`.
- **Nguyên nhân:** Tiến trình Java Daemon chạy ngầm trên Windows khóa file cache tạm thời.
- **Xử lý:** Mở PowerShell và chạy:
  ```powershell
  Stop-Process -Name java -Force
  flutter clean
  flutter pub get
  ```

### 8.2. Máy tính không nhận điện thoại:
- **Xử lý:** Rút cáp cắm lại cổng USB khác, kiểm tra lại cáp sạc (phải là cáp truyền dữ liệu), đảm bảo đã bật "Gỡ lỗi qua USB" và cấp quyền cho máy tính.

### 8.3. Chạy trên trình duyệt Chrome bị lỗi Firebase:
- **Xử lý:** Thư viện Firebase trong dự án đang được cấu hình tối ưu cho Android (`google-services.json`). Hãy chuyển thiết bị đích sang **Điện thoại Android** hoặc **Máy ảo Pixel** để chạy.

---
*Tài liệu được lập và kiểm thử hoàn chỉnh cho dự án VCall.*
