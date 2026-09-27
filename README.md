# 🎓 Language AI Mobile — AI English Tutor

Ứng dụng di động gia sư tiếng Anh thông minh tương tác bằng giọng nói (Voice-first AI English Tutor) xây dựng bằng **Flutter**, tuân thủ nghiêm ngặt **Clean Architecture** (Feature-first) và **BLoC/Cubit Pattern**, kết nối trực tiếp với backend **FastAPI** và mô hình ngôn ngữ **Ollama (`llama3.1:8b`)**.

---

## 📑 Mục lục

- [Tổng quan kiến trúc](#-tổng-quan-kiến-trúc)
- [Cấu trúc thư mục dự án](#-cấu-trúc-thư-mục-dự-án)
- [Hệ thống Design System & Responsive](#-hệ-thống-design-system--responsive)
- [Công nghệ & Thư viện sử dụng](#-công-nghệ--thư-viện-sử-dụng)
- [Yêu cầu môi trường (Prerequisites)](#-yêu-cầu-môi-trường-prerequisites)
- [Hướng dẫn cài đặt & Khởi chạy](#-hướng-dẫn-cài-đặt--khởi-chạy)
  - [1. Cấu hình Backend URL](#1-cấu-hình-backend-url)
  - [2. Cài đặt Dependencies](#2-cài-đặt-dependencies)
  - [3. Chạy Code Generation](#3-chạy-code-generation)
  - [4. Kiểm tra mã nguồn (Analyze & Test)](#4-kiểm-tra-mã-nguồn-analyze--test)
  - [5. Khởi chạy ứng dụng](#5-khởi-chạy-ứng-dụng)
- [Lưu ý kết nối mạng Backend (Android / iOS / Máy thật)](#-lưu-ý-kết-nối-mạng-backend)
- [Bảng lệnh thường dùng (Cheatsheet)](#-bảng-lệnh-thường-dùng-cheatsheet)

---

## 🏛 Tổng quan kiến trúc

Dự án áp dụng mô hình **Feature-first Clean Architecture** phân tách rõ ràng 3 tầng:

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│   (Pages, Widgets, BLoC/Cubit, UI States & Events)     │
└───────────────────────────┬────────────────────────────┘
                            │ depends on
┌───────────────────────────▼────────────────────────────┐
│                      Domain Layer                      │
│   (Entities, UseCases, Repository Interfaces - Pure)   │
└───────────────────────────▲────────────────────────────┘
                            │ implements
┌───────────────────────────┴────────────────────────────┐
│                       Data Layer                       │
│   (Models, Remote/Local DataSources, Repositories)     │
└────────────────────────────────────────────────────────┘
```

- **Domain Layer (Thuần Dart)**: Độc lập với Flutter SDK và thư viện bên thứ 3. Chứa nghiệp vụ cốt lõi (`UserEntity`, `LoginUseCase`, `RegisterUseCase`).
- **Data Layer**: Chịu trách nhiệm giao tiếp với FastAPI backend, map dữ liệu qua Freezed Models và lưu trữ bảo mật qua `flutter_secure_storage`.
- **Presentation Layer**: Quản lý trạng thái bằng BLoC/Cubit, điều hướng qua `GoRouter` có Auth Guard bảo vệ.

---

## 📂 Cấu trúc thư mục dự án

```
lib/
├── core/
│   ├── constants/            # API endpoints, URLs, timeouts
│   │   └── api_constants.dart
│   ├── di/                   # Dependency Injection (GetIt + Injectable)
│   │   ├── injection.dart
│   │   └── injection.config.dart
│   ├── errors/               # Typed Exceptions & Failures
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/              # Singleton Dio HTTP client + Interceptors
│   │   └── dio_client.dart
│   ├── router/               # GoRouter config with Auth Guard
│   │   └── app_router.dart
│   ├── storage/              # Encrypted token storage
│   │   └── secure_storage.dart
│   └── theme/                # Central Design System & Responsive Engine
│       ├── app_colors.dart       # Color tokens, gradients, semantic colors
│       ├── app_responsive.dart   # Scaling extensions, device detection, responsive container
│       ├── app_spacing.dart      # 8-pt grid spacing, radiuses, insets, micro gaps
│       ├── app_theme.dart        # Material 3 dark ThemeData
│       ├── app_typography.dart   # Inter text hierarchy, AI tutor domain styles
│       └── theme.dart            # Single barrel export
├── features/
│   └── auth/                 # Tính năng Xác thực (Auth Feature)
│       ├── data/
│       │   ├── datasources/  # AuthRemoteDatasource (FastAPI form-encoded & JSON)
│       │   ├── models/       # Freezed Request & Response Models
│       │   └── repositories/ # AuthRepositoryImpl (Maps exceptions -> Failures)
│       ├── domain/
│       │   ├── entities/     # UserEntity
│       │   ├── repositories/ # AuthRepository interface
│       │   └── usecases/     # LoginUseCase, RegisterUseCase
│       └── presentation/
│           ├── cubit/        # AuthCubit & AuthState
│           ├── pages/        # LoginPage, RegisterPage
│           └── widgets/      # AppButton, AuthTextField
└── main.dart                 # App Entry Point, DI Bootstrap, MaterialApp.router
```

---

## 🎨 Hệ thống Design System & Responsive

Ứng dụng được trang bị bộ Design System tập trung tại `lib/core/theme/`:

- **Responsive Engine ([app_responsive.dart](file:///e:/Language_AI/Language_AI_Mobile/lib/core/theme/app_responsive.dart))**:
  - `context.w(size)`: Tự động co giãn chiều rộng theo tỷ lệ màn hình (Base canvas: 375x812).
  - `context.h(size)`: Tự động co giãn chiều cao theo tỷ lệ màn hình.
  - `context.sp(fontSize)`: Tự động scale font chữ chống tràn và bảo đảm độ nét.
  - `context.r(radius)`: Tự động scale bo góc viền.
  - `context.isMobile`, `context.isTablet`, `context.isDesktop`: Nhận diện loại thiết bị.
  - `ResponsiveContainer(maxWidth: 460)`: Giữ form/layout cân đối, không bị kéo dãn bất thường trên Tablet / iPad.
- **Typography ([app_typography.dart](file:///e:/Language_AI/Language_AI_Mobile/lib/core/theme/app_typography.dart))**: Toàn bộ sử dụng font **Inter** thông qua `google_fonts` với các kiểu dáng: Display, Headline, Title, Body, Label và các token đặc thù: `chatUser`, `chatAi`, `correctionMistake`, `correctionFixed`, `phoneticIpa`.
- **Color Palette ([app_colors.dart](file:///e:/Language_AI/Language_AI_Mobile/lib/core/theme/app_colors.dart))**: Dark mode hiện đại với nền obsidian (`#0D0E1A`), surface card (`#13152B`), thương hiệu tím Indigo (`#6C63FF`), AI cyan accent (`#06B6D4`), cùng các màu semantic và gradient.

---

## 🛠 Công nghệ & Thư viện sử dụng

| Nhóm | Thư viện | Phiên bản | Mục đích |
|------|----------|-----------|----------|
| **Core & UI** | `flutter` | SDK | Framework nền tảng |
| | `google_fonts` | ^6.3.3 | Font chữ Inter chuẩn hóa |
| | `gap` | ^3.0.1 | Spacing giữa các widget |
| | `flutter_svg` | ^2.2.4 | Render vector SVG |
| **State Management** | `flutter_bloc` | ^9.1.1 | Quản lý trạng thái theo BLoC/Cubit |
| **Dependency Injection** | `get_it` | ^8.3.0 | Service Locator |
| | `injectable` | ^2.7.1 | Tự động sinh mã cấu hình DI |
| **Networking & HTTP** | `dio` | ^5.9.1 | REST Client, interceptors |
| | `pretty_dio_logger` | ^1.4.0 | Log request/response đẹp mắt (debug) |
| | `http` | ^1.6.0 | Hỗ trợ SSE (Server-Sent Events) streaming |
| **Storage & Security** | `flutter_secure_storage` | ^9.2.4 | Lưu JWT token mã hóa an toàn |
| **Routing** | `go_router` | ^14.8.1 | Điều hướng declarative, hỗ trợ Auth Guard |
| **Functional & Models** | `dartz` | ^0.10.1 | Functional programming (`Either<Failure, T>`) |
| | `freezed_annotation` | ^2.4.4 | Immutable state & data models |
| **Testing** | `bloc_test` | ^10.0.0 | Unit test chuyên biệt cho BLoC/Cubit |
| | `mocktail` | ^1.0.4 | Mock dependencies không cần code-gen |

---

## 📋 Yêu cầu môi trường (Prerequisites)

- **Flutter SDK**: `>= 3.24.0` (Khuyên dùng `3.38.x` hoặc mới nhất)
- **Dart SDK**: `>= 3.5.0`
- **Android Studio** (kèm Android SDK + Emulator) hoặc **Xcode** (trên macOS)
- **Backend FastAPI** đang chạy tại cổng `8000`

Kiểm tra môi trường:
```bash
flutter doctor
```

---

## 🚀 Hướng dẫn cài đặt & Khởi chạy

### 1. Cấu hình Backend URL

Mở file [`lib/core/constants/api_constants.dart`](file:///e:/Language_AI/Language_AI_Mobile/lib/core/constants/api_constants.dart):

```dart
class ApiConstants {
  ApiConstants._();

  // Android Emulator: 10.0.2.2 trỏ về localhost của máy tính host
  static const String baseUrl = 'http://10.0.2.2:8000';

  // iOS Simulator hoặc Web:
  // static const String baseUrl = 'http://localhost:8000';

  // Thiết bị thật (chạy cùng mạng Wi-Fi):
  // static const String baseUrl = 'http://192.168.1.X:8000';
  ...
}
```

### 2. Cài đặt Dependencies

Mở terminal tại thư mục gốc của dự án (`Language_AI_Mobile`):
```bash
flutter pub get
```

### 3. Chạy Code Generation

Dự án sử dụng `freezed` và `injectable` để sinh mã tự động. Chạy lệnh:
```bash
dart run build_runner build --delete-conflicting-outputs
```
*(Nếu đang trong quá trình phát triển liên tục, có thể chạy `dart run build_runner watch --delete-conflicting-outputs`)*.

### 4. Kiểm tra mã nguồn (Analyze & Test)

Đảm bảo toàn bộ dự án không có lỗi cú pháp hoặc cảnh báo linter:
```bash
flutter analyze
```

Chạy toàn bộ 16+ unit test (bao gồm Auth luồng hoàn chỉnh và Responsive Engine):
```bash
flutter test
```

### 5. Khởi chạy ứng dụng

Kiểm tra danh sách thiết bị/máy ảo đang mở:
```bash
flutter devices
```

Khởi chạy ứng dụng:
```bash
# Chạy trên thiết bị mặc định
flutter run

# Hoặc chỉ định rõ ID thiết bị (ví dụ Android emulator)
flutter run -d emulator-5554
```

---

## 🌐 Lưu ý kết nối mạng Backend

Khi ứng dụng mobile gửi request đến FastAPI backend chạy trên máy tính (`localhost:8000`):

1. **Android Emulator**:
   - `localhost` trong emulator là chính chiếc điện thoại ảo.
   - Để gọi về máy tính host chạy backend, bạn **bắt buộc** dùng IP: `http://10.0.2.2:8000` (đã được cấu hình mặc định).
2. **iOS Simulator**:
   - Dùng trực tiếp: `http://localhost:8000`.
3. **Thiết bị thật (Cắm dây USB / Kết nối Wi-Fi)**:
   - Điện thoại và máy tính phải kết nối **chung một mạng Wi-Fi**.
   - Tìm địa chỉ IP LAN của máy tính (dùng `ipconfig` trên Windows hoặc `ifconfig` trên macOS).
   - Đặt `baseUrl = 'http://192.168.x.x:8000'`.
   - Đảm bảo FastAPI khởi động với host `0.0.0.0`:
     ```bash
     uvicorn main:app --host 0.0.0.0 --port 8000 --reload
     ```
   - Cho phép cổng 8000 qua Windows Firewall nếu bị chặn kết nối từ thiết bị ngoài.

---

## ⚡ Bảng lệnh thường dùng (Cheatsheet)

| Tác vụ | Câu lệnh |
|--------|----------|
| Cài package | `flutter pub get` |
| Sinh mã code (DI + Freezed) | `dart run build_runner build --delete-conflicting-outputs` |
| Lắng nghe thay đổi sinh mã | `dart run build_runner watch --delete-conflicting-outputs` |
| Quét kiểm tra lỗi | `flutter analyze` |
| Chạy Unit/Widget Tests | `flutter test` |
| Chạy chế độ Debug | `flutter run` |
| Chạy chế độ Release | `flutter run --release` |
| Xóa cache & build lại | `flutter clean && flutter pub get` |
| Build file APK | `flutter build apk --split-per-abi` |
| Build App Bundle (CH Play) | `flutter build appbundle` |

---

*Phát triển bởi đội ngũ Language AI — Clean Architecture & Voice-First AI Experience.*
