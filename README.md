# +90 — Nearby Time-Limited Offers 📍

A Flutter mobile application for discovering offers and deals available around the user within limited time windows.

> This repository contains the Flutter application foundation for the +90 project (onboarding, authentication, and home shell). No backend/API has been integrated yet.

## ✨ Overview

**+90** is built around a simple idea: help users discover offers available around them, while giving sellers a way to present their offers. The current codebase focuses on the application foundation — the splash and onboarding flow, the authentication journey with account-type selection, and the home screen shell.

## 🚀 Features

- 💠 Splash screen
- 📲 Onboarding flow with smooth page indicators
- 🔐 Authentication entry flow
- 👤 Login and registration screens
- 🏷️ Account type selection
- 🏠 Home screen shell
- 🧭 Named-route navigation
- ✍️ Custom typography with Google Fonts

## 🛠️ Tech Stack

### Framework & Language

- Flutter
- Dart

### UI & Design

- Material Design
- `google_fonts` — custom typography
- `smooth_page_indicator` — onboarding indicators
- `cupertino_icons`

### Navigation

- Named routes defined centrally in `utils/AppRoutes.dart`

## 🏗️ Project Structure

```
lib/
├── Auth/          # login, registration, account type selection
├── Home/          # home screen
├── Splach/        # splash screen
├── onBorading/    # onboarding pages
└── utils/         # routes, colors, styles, shared widgets
```

## 📱 Application Version

Current project version: **1.0.0+1**

## 📸 Screenshots

Add screenshots here to showcase the main flows, including onboarding, authentication, account type selection, and the home screen.

## ▶️ Getting Started

```bash
git clone https://github.com/abdelrhamanadel4-Flutter/plus90_application.git
cd plus90_application
flutter pub get
flutter run
```

## 📄 Note

The current build is a UI foundation. Authentication and offers functionality are not yet wired to a real backend.