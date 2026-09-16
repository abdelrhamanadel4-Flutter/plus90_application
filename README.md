# +90 — Nearby Time-Limited Offers 📍

A Flutter mobile application designed to help users discover nearby offers and deals available within limited time windows.

> **Project Status:** The current application includes the core Flutter experience, authentication, account-type selection, Firebase integration, and the initial home screen foundation.

---

## ✨ Overview

**+90** is a Flutter-based mobile application built around a simple idea: making it easier for users to discover offers and deals available around them within specific time windows.

The application provides separate account types and uses Firebase services to handle authentication and cloud data management.

The current application flow includes:

**Splash → Onboarding → Authentication → Account Type → Home**

---

## 🚀 Features

- 💠 Splash screen
- 📲 Onboarding experience
- 🔐 Firebase Authentication
- 👤 User login
- 📝 User registration
- 🏷️ Account type selection
- 🏠 Home screen
- ☁️ Cloud Firestore integration
- 📦 Firebase Storage integration
- 🧭 Centralized named-route navigation
- ✨ Smooth onboarding indicators
- 🔤 Custom typography using Google Fonts
- 📱 Responsive Flutter UI

---

## 🔥 Firebase

The application uses Firebase as part of its backend infrastructure.

### Firebase Authentication

Used for handling user authentication and account access.

- User registration
- User login
- Authentication state

### Cloud Firestore

Used for storing and managing application data in the cloud.

### Firebase Storage

Used for storing and managing uploaded files and images.

---

## 🛠️ Tech Stack

### Framework & Language

- **Flutter**
- **Dart**

### Backend & Cloud Services

- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Storage**

### UI & Design

- **Material Design**
- **Google Fonts**
- **Smooth Page Indicator**
- **Cupertino Icons**

### Navigation

- Named Routes
- Centralized route management

---

## 🏗️ Project Structure

```text
lib/
├── Auth/
│   ├── Login/
│   ├── Register/
│   └── ChooseType/
│
├── Home/
│   └── HomeScreen
│
├── Splach/
│   └── Splash Screen
│
├── onBorading/
│   └── Onboarding Screens
│
└── utils/
    ├── AppRoutes.dart
    ├── Colors
    ├── Styles
    └── Shared Utilities
