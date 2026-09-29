# CoLearn App

A Flutter-based mobile and web application delivering the complete NCCT (National Centre for Cooperative Training) learning ecosystem. Built with a minimal, premium black-and-white design system using Plus Jakarta Sans typography.

---

## Modules

| Module | Description |
|---|---|
| Home Dashboard | Personalized feed with academic stats, today's session card, continue-learning carousel, VR spotlight banner, and bulletin board |
| Courses & Programmes | Browse and enrol in NCCT-approved courses; Coursera-style module progress tracking with YouTube lecture integration |
| 360 / VR Learning | Panoramic factory and machine training demos via WebXR; supports Google Cardboard mode on compatible mobile browsers |
| Quizzes & Assessments | In-app MCQ assessments with instant scoring and performance feedback |
| Certificates | Digitally signed NCCT certificates with PDF download, share, and QR-based verification |
| Learner Profile | GPA, credits, badges, skills, 14-day learning streak, attendance rate, and programme progress ring |
| Skills & Badges | Tiered badge system (Bronze, Silver, Gold, Platinum) earned on course completion |
| Attendance | Geo-fenced check-in with session history and attendance rate tracking |
| Career & Jobs | Government and private sector job board with one-tap apply and application status tracking |
| Notifications | Announcements, assignment deadlines, and placement cell alerts |

---

## Design System

- **Color palette:** Strict monochrome — `#000000` foreground, `#FFFFFF` background, `#F4F4F5` surface subtle
- **Typography:** Plus Jakarta Sans (via `google_fonts`) across all weights (400–800)
- **Radius tokens:** Small `8px`, Medium `12px`, Large `18px`
- **Component style:** Dark hero headers, document-style certificate cards, grid-painted canvas decorations, subtle box shadows
- **Motion:** AnimatedContainer transitions at 180ms for filter chips and state changes

---

## Tech Stack

| Layer | Library / Tool |
|---|---|
| Framework | Flutter 3.x (Dart 3) |
| Navigation | Named routes via `app_routes.dart` + `Navigator` |
| State | StatefulWidget + centralized `MockDataService` (API-ready) |
| Image loading | `cached_network_image` with Unsplash CDN URLs |
| Maps / Attendance | `google_maps_flutter` + `geolocator` |
| VR / 360 | `webview_flutter` with WebXR / A-Frame panoramic viewer |
| Fonts | `google_fonts` — Plus Jakarta Sans |
| Local storage | `shared_preferences`, `sqflite` |
| Certificates | Custom `CustomPainter` (grid, seal watermark) + PDF download |

---

## Project Structure

```
lib/
├── config/
│   ├── app_theme.dart              # Design tokens: colors, typography, radius
│   ├── app_routes.dart             # Named route table
│   └── app_config.dart             # App-wide constants
├── models/
│   ├── ncct_models.dart            # Data models (Course, Certificate, Job, Badge...)
│   └── mock_data_service.dart      # Static mock data (swap endpoint for production)
├── screens/
│   ├── home/                       # Dashboard with stats, session, VR banner
│   ├── courses/                    # Course list, detail (tabbed), video player
│   ├── vr/                         # 360 / WebXR learning screen
│   ├── certificates/               # Certificate gallery + verification
│   ├── careers/                    # Job board with expandable job cards
│   ├── profile/                    # Learner profile with streak and progress
│   ├── attendance/                 # Geo check-in and session history
│   ├── quiz/                       # MCQ assessment engine
│   ├── notifications/              # Alerts and announcements
│   └── shell/                      # Bottom navigation shell
├── widgets/
│   └── common/                     # Shared UI components
└── services/                       # API, location, camera service stubs
```

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.10
- Dart >= 3.0
- Android Studio or VS Code with Flutter extension
- Android SDK (for APK builds) or Chrome (for web)

### Setup

```bash
# Clone the repository
git clone https://github.com/Niranjan117/CoLearn-App.git
cd CoLearn-App

# Install dependencies
flutter pub get
```

### Run

```bash
# Web (Chrome)
flutter run -d chrome

# Android device or emulator
flutter run -d android

# Windows desktop
flutter run -d windows
```

### Build

```bash
# Debug APK
flutter build apk --debug

# Release APK (split by ABI - recommended for distribution)
flutter build apk --split-per-abi --release

# Play Store App Bundle
flutter build appbundle --release

# Web production build
flutter build web --release
```

Output path for APK:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Data Layer

All data is currently served via `MockDataService` (static Dart lists). Every model and service method is structured to be replaced by a REST or GraphQL API call with no changes to the UI layer.

Key models: `CourseModel`, `CertificateModel`, `JobPostingModel`, `SkillBadge`, `BulletinItem`, `NCCTUser`.

---

## About NCCT

The National Centre for Cooperative Training (NCCT) is an autonomous body under the Ministry of Cooperation, Government of India. It provides training, education, and research support to the cooperative sector across the country.

---

## License

Developed for NCCT internal use. All rights reserved.
