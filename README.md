# CoLearn — NCCT Learning Ecosystem

<p align="center">
  <img src="assets/images/logo.png" alt="CoLearn Logo" width="100"/>
</p>

<p align="center">
  A premium, minimal Flutter app delivering the complete NCCT cooperative training experience — courses, VR learning, certificates, careers, and more.
</p>

---

## ✨ Features

| Module | Description |
|---|---|
| 🏠 **Home Dashboard** | Personalized feed with stats, today's session, continue learning, VR spotlight, bulletin |
| 📚 **Courses & Programmes** | Browse, enrol, track Coursera-style module progress with YouTube lectures |
| 🥽 **360° / VR Learning** | Panoramic factory & machine training demos; WebXR "Enter VR / Cardboard" mode |
| 📝 **Quizzes & Assessments** | In-app MCQ assessments with instant results |
| 🏆 **Certificates** | Digitally signed NCCT certificates — download PDF, share, verify via QR |
| 👤 **Learner Profile** | GPA, credits, badges, skills, learning streak, attendance rate |
| 🎖️ **Skills & Badges** | Tiered badge system (Bronze → Platinum) earned by completing courses |
| 📅 **Attendance** | Geo-fenced check-in, session history, rate tracking |
| 💼 **Career & Jobs** | Government & private job board with one-tap apply, application tracking |
| 🔔 **Notifications** | Announcements, deadlines, placement alerts |

---

## 🎨 Design System

- **Aesthetic:** Minimal, premium, black-and-white (`#000000` / `#FFFFFF`)
- **Typography:** [Plus Jakarta Sans](https://fonts.google.com/specimen/Plus+Jakarta+Sans) via `google_fonts`
- **Style:** Glassmorphism accents, dark hero headers, micro-animations, responsive layout

---

## 🛠 Tech Stack

- **Framework:** Flutter 3.x (Dart)
- **State:** `StatefulWidget` + `MockDataService` (ready for API swap)
- **Navigation:** `Navigator` named routes (`app_routes.dart`)
- **Images:** `cached_network_image` (Unsplash URLs)
- **Maps / Attendance:** `google_maps_flutter` + `geolocator`
- **VR / 360°:** `webview_flutter` + WebXR / A-Frame panoramic viewer
- **Fonts:** `google_fonts`
- **Storage:** `shared_preferences`, `sqflite`

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.10
- Dart ≥ 3.0
- Android Studio / VS Code

### Run

```bash
# Install dependencies
flutter pub get

# Run on Chrome (web)
flutter run -d chrome

# Run on Android device / emulator
flutter run -d android

# Run on Windows desktop
flutter run -d windows
```

### Build

```bash
# Release APK (split by ABI — smaller size)
flutter build apk --split-per-abi --release

# Play Store App Bundle
flutter build appbundle

# Web
flutter build web
```

---

## 📁 Project Structure

```
lib/
├── config/
│   ├── app_theme.dart        # Colors, typography, radius tokens
│   ├── app_routes.dart       # Named route table
│   └── app_config.dart       # App-wide constants
├── models/
│   ├── ncct_models.dart      # Data models
│   └── mock_data_service.dart# Mock data (swap with real API)
└── screens/
    ├── home/                 # Dashboard
    ├── courses/              # Course list + detail
    ├── vr/                   # 360° / VR learning
    ├── certificates/         # Certificate gallery + verify
    ├── careers/              # Job board
    ├── profile/              # Learner profile
    ├── attendance/           # Geo check-in
    ├── quiz/                 # Assessments
    ├── notifications/        # Alerts
    └── shell/                # Bottom nav shell
```

---

## 🏛 About NCCT

The **National Centre for Cooperative Training (NCCT)** is an autonomous body under the Ministry of Cooperation, Government of India, providing training and education for the cooperative sector.

---

## 📄 License

This project is developed for NCCT internal use. All rights reserved.
