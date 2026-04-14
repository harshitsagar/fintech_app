# FinTech Mobile Application

A feature-rich, modern FinTech mobile application built with Flutter following Clean Architecture principles.

## 🚀 Overview

This project was developed as part of a Flutter developer interview assignment. It implements a complete FinTech ecosystem including authentication, a comprehensive dashboard with financial widgets, and user profile management.

## ✨ Key Features

### Module 01: Authentication Flow
- **Splash & Onboarding**: Seamless brand introduction and user guidance.
- **Email/Password Auth**: Secure login and registration with validation.
- **Password Recovery**: Complete forgot/reset password flow.

### Module 02: FinTech Dashboard
- **Financial Cards**: Account and Gold balance visualization.
- **Quick Actions**: Deposit, Portfolio, and Token management.
- **Dynamic Content**: Advertisement banners, Games (Play & Earn), YouTube educational feed, and Latest Blogs.
- **Referral System**: Integrated invite system with referral codes.

### Module 03: Profile Management
- User profile details and photo management.
- Comprehensive account settings.
- Secure logout with confirmation.

## 🛠 Tech Stack

- **Framework**: Flutter (Stable)
- **State Management**: [GetX]
- **Navigation**: [Go Router]
- **Backend**: Firebase (Authentication & Firestore)
- **UI/UX**: Responsive design using `flutter_screenutil` and `google_fonts`.

## 🏗 Architecture

The project follows **Clean Architecture** with a Feature-First folder structure to ensure scalability, maintainability, and testability:

- **Core**: Contains shared constants, themes, and navigation logic.
- **Data**: Implementation of repositories, data sources (Firebase), and models.
- **Domain**: Pure business logic, entities, and repository interfaces.
- **Presentation**: UI layer consisting of Screens, Controllers (GetX), and reusable Widgets.

### Why GetX?
For this project, **GetX** was chosen as the state management solution for the following reasons:
1. **Performance**: It is extremely lightweight and does not use `ChangeNotifier` or `Streams` for simple state, making it highly efficient.
2. **Productivity**: It reduces boilerplate code significantly compared to BLoC or Riverpod.
3. **Decoupling**: GetX allows for easy separation of business logic from the UI without needing a BuildContext in the controllers.
4. **All-in-one**: It provides a unified way to handle state, dependency injection, and simple snackbars/dialogs.

## ⚙️ Project Setup

### Prerequisites
- Flutter SDK (Latest Stable)
- Java SDK & Android Studio / VS Code
- Firebase Project setup

### Installation Steps
1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd fintech_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**:
   - Create a project on [Firebase Console](https://console.firebase.google.com/).
   - Register Android/iOS apps.
   - Download `google-services.json` and place it in `android/app/`.
   - Enable Email/Password and Phone Authentication.
   - Initialize Cloud Firestore.

4. **Run the application**:
   ```bash
   flutter run
   ```
