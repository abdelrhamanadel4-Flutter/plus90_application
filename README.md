# +90

A Flutter mobile application for discovering nearby, time-limited offers and deals.

> Status: UI foundation. The current codebase covers the onboarding and authentication flow and the home screen shell. No backend/API has been integrated yet.

## Features

- Splash screen
- Onboarding flow with smooth page indicators
- Authentication flow with account-type selection
- Login and registration screens
- Home screen shell
- Named-route navigation
- Custom typography via Google Fonts

## Tech Stack

- Flutter / Dart
- Material Design
- `google_fonts` — typography
- `smooth_page_indicator` — onboarding indicators
- `cupertino_icons`

## Project Structure

```
lib/
├── Auth/          # login, register, account type selection
├── Home/          # home screen
├── Splach/        # splash screen
├── onBorading/    # onboarding pages
└── utils/         # routes, colors, styles, shared widgets
```

## Getting Started

```bash
git clone https://github.com/abdelrhamanadel4-Flutter/plus90_application.git
cd plus90_application
flutter pub get
flutter run
```