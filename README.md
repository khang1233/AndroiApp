<div align="center">
  <img src="https://img.icons8.com/?size=512&id=vml94JzT6f13&format=png" width="120" alt="Vibe Trip Logo">
  
  <h1>🛫 Vibe Trip</h1>
  
  <p>
    <strong>Ứng dụng Trợ lý Du lịch Thông minh Ứng dụng AI Gemini</strong>
  </p>
  
  <p>
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
    <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase">
    <img src="https://img.shields.io/badge/Google_Gemini-8E75B2?style=for-the-badge&logo=googlebard&logoColor=white" alt="Gemini">
  </p>
</div>

<hr>

## 🌟 Giới thiệu

**Vibe Trip** không chỉ là một ứng dụng du lịch truyền thống. Bằng cách kết hợp Mô hình Ngôn ngữ Lớn **Google Gemini AI**, ứng dụng cho phép phân tích *tâm trạng, sở thích địa hình, giới hạn kinh phí và thời gian* của người dùng để ngay lập tức đề xuất một lịch trình ăn chơi "đo ni đóng giày" mang đậm chất riêng — đi kèm với phân tích tài chính thông minh xuống từng ngàn đồng!

Dự án được xây dựng hoàn toàn từ con số không trên nền tảng **Flutter**, mang lại một trải nghiệm hoạt ảnh (UI/UX) cực mượt mà ở tần số 60FPS, vượt trội hơn hẳn các công nghệ render tĩnh cũ.

## ✨ Tính năng Nổi bật

- 🤖 **Trí tuệ nhân tạo (Gemini Pro):** Render và sắp xếp một tour du lịch cá nhân hóa từng giờ, kể chuyện theo phong cách Gen-Z.
- 🔐 **Authentication Mạnh mẽ:** Tự hào sở hữu quy trình đăng nhập khép kín qua Google, GitHub, và Hệ thống thành viên Email/Mật khẩu (Powered by Firebase Authentication).
- 🧬 **Bảo mật Sinh Trắc Học (Local Auth):** Hỗ trợ lưu trữ phiên đăng nhập vô thời hạn, bảo vệ app an toàn tuyệt đối bằng FaceID / TouchID của hệ điều hành.
- 💸 **Dynamic Budget Planner:** Tính toán thời gian thực tổng thanh toán cho lộ trình ăn uống, đi lại, ngủ nghỉ không lố 1 xu của người dùng.
- 🏨 **O2O Booking:** Trực tiếp đẩy thông tin thông qua URL Launcher sang các hệ thống khách sạn quốc tế như Agoda.

## 🛠️ Trải nghiệm Cài đặt

Yêu cầu máy tính có cài sẵn **Flutter SDK (>=3.0.0)** và **Android Studio / VS Code**.

**1. Clone hoặc Mở mã nguồn**
Di chuyển con trỏ Terminal vào thư mục của Project.

**2. Setup Package Flutter**
```bash
flutter clean
flutter pub get
```

**3. Khởi tạo Firebase**
Vibe Trip sử dụng luồng Authentication rất chặt chẽ, bạn cần nhúng project Firebase của riêng bạn vào bằng công cụ `flutterfire`:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
*(Đừng quên đặt file `google-services.json` vào mục `android/app`)*

**4. Khởi chạy Ứng dụng**
```bash
flutter run
```

## 📸 Kiến trúc Thư mục

- `lib/screens/`: Chứa các màn hình hiển thị trực quan (Login, Splash, Profile, Result...).
- `lib/services/`: Nơi xử lý Network request, AI Endpoint, và trạng thái Firebase.
- `lib/utils/`: Mapping thuật toán nội bộ xử lý định vị ảnh mờ tự động.

---
*Developed with ☕ and modern Flutter Architecture for Đồ Án Lập Trình Di Động.*
