# UZHAVAN360 (உழவன்360) - Complete Rural Empowerment Mobile Application

[![Flutter](https://img.shields.io/badge/Flutter-3.47.7-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.5-teal.svg)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend%20RLS-brightgreen.svg)](https://supabase.com)
[![Tests](https://img.shields.io/badge/Tests-20%2F20%20Passed-success.svg)](test/)
[![Analysis](https://img.shields.io/badge/Flutter%20Analyze-0%20Issues-brightgreen.svg)](lib/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-orange.svg)](android/)

**UZHAVAN360** is a comprehensive, senior-friendly, mobile-first native application designed specifically for rural communities in Tamil Nadu, India. It empowers agricultural workers, farmers, landowners, traders, rural youth, and Panchayat officials through unified access to employment, verified agricultural market prices, government welfare schemes, local public finance transparency, and Panchayat administrative services.

---

## 🌾 Core Capabilities & Key Principles

### 1. Absolute Mobile App Architecture (Android & iOS)
- Exclusively implemented using **Flutter & Dart** with native Android and iOS configurations.
- **No website, web landing page, or WebView wrappers**. 
- Android package configured with background permissions, text-to-speech audio streams, fine/coarse location access, and internet state detection.
- iOS `Runner` configured with Apple privacy keys for Location (`NSLocationWhenInUseUsageDescription`), Microphone (`NSMicrophoneUsageDescription`), and Speech Recognition (`NSSpeechRecognitionUsageDescription`).

### 2. Authentic Application Branding & Preserved Logo
- The official application name is **`UZHAVAN360`** throughout all interfaces, manifests, and splash screens.
- Official user-provided emblem preserved verbatim in `assets/images/uzhavan360_logo.jpg` and `uzhavan360_logo.png`, illustrating a traditional Tamil farmer alongside a modern agricultural drone over lush green paddy fields.

### 3. Tamil-First & Voice-Assisted Accessibility
- **Tamil by Default**: Boots automatically in Tamil (`ta`), with English (`en`) available at any time.
- **Text-To-Speech (TTS) Voice Guidance**: Prominent speaker buttons on every screen read instructions aloud in natural spoken Tamil for elderly farmers and users with limited digital literacy.
- **High-Contrast, Touch-Friendly UI**: 18px+ typography, minimum 52px touch targets, clean white backgrounds, and deep agricultural green (`#1B5E20`) accents.

### 4. Mandatory Separation of Trader Offer Quotes vs. Actual Transaction Prices (Requirement 20)
- **Trader Offers**: Quoted purchase prices posted by local traders with 3-tier quality grading (Grade 1, Grade 2, Grade 3) and trader shop badges.
- **Actual Completed Transactions**: Genuine sale receipts recorded from Regulated Markets (*Uzhavar Sandhai* / ஒழுங்குமுறை விற்பனைக்கூடம்) and direct farm-gate sales, displaying verified stamp icons.
- Trader quotes are never conflated with or presented as completed sale data.

### 5. Strict Panchayat Official Verification & Anti-Spam Security (Requirements 15 & 21)
- Selecting the *Panchayat Official* role does **not** grant automatic administrative privileges.
- All newly registered officials start as **Unverified (`is_official_verified = false`)**.
- Only verified officials can publish official Gram Sabha notices, broadcast urgent village alerts, or modify public fund expenditure records.
- Villagers can submit local infrastructure complaints (drinking water, streetlights, rural roads) with tracking.

### 6. Agricultural Worker Privacy & Direct Contact Consent (Requirement 27)
- Worker phone numbers are **hidden by default** until the worker explicitly taps *"Allow Contact"* / *"தொடர்பு கொள்ள அனுமதி"* for an employer's job application.
- Supports off-season dryland farming employment and local harvest crew formation.

---

## 📁 Project Structure

```text
uzhavan360/
├── android/                        # Native Android project configuration
│   └── app/src/main/
│       ├── AndroidManifest.xml     # UZHAVAN360 label, permissions (Audio, GPS, Internet)
│       └── res/values/             # Strings, styles, themes
├── ios/                            # Native iOS project configuration
│   └── Runner/
│       ├── Info.plist              # Bundle display name: UZHAVAN360, Apple permissions
│       └── AppDelegate.swift
├── assets/
│   ├── images/
│   │   ├── uzhavan360_logo.jpg     # Preserved official emblem
│   │   └── uzhavan360_logo.png
│   └── translations/
│       ├── ta.json                 # Tamil strings (default)
│       └── en.json                 # English strings
├── supabase/
│   └── migrations/
│       ├── 00001_initial_schema.sql       # PostgreSQL tables, relations, triggers
│       ├── 00002_rls_policies.sql         # Row Level Security authorization
│       └── 00003_seed_reference_data.sql   # Tamil Nadu crops, districts, schemes
├── lib/
│   ├── core/
│   │   ├── config/                 # Supabase & app configuration
│   │   ├── localization/           # Tamil & English translation delegate
│   │   ├── services/               # TTS, Location, Storage, Connectivity
│   │   └── theme/                  # Senior-friendly design tokens & colors
│   ├── data/
│   │   ├── models/                 # UserProfile, Job, CropPrice, Scheme, Panchayat
│   │   └── repositories/           # Isolated data access with offline cache fallbacks
│   ├── state/                      # ChangeNotifier providers (Auth, Profile, Jobs, etc.)
│   ├── ui/
│   │   ├── common/                 # Reusable buttons, badges, text fields, TTS controls
│   │   └── screens/
│   │       ├── splash/             # Animated branding splash
│   │       ├── language/           # Language switcher
│   │       ├── auth/               # Mobile phone OTP login
│   │       ├── onboarding/         # Profile setup, village picker, role selector
│   │       ├── dashboard/          # Tailored role dashboards (Worker, Farmer, Trader, Official)
│   │       ├── jobs/               # Agricultural jobs, posting & privacy application
│   │       ├── market/             # 3-tier crop prices & verified transactions
│   │       ├── schemes/            # Central & Tamil Nadu welfare schemes
│   │       ├── panchayat/          # Gram Sabha, village notices, public funds & complaints
│   │       ├── weather/            # Agro-meteorological advisories
│   │       ├── adviser/            # Agricultural university & KVK expert directory
│   │       └── profile/            # User profile, role switching, privacy settings
│   ├── app.dart                    # MultiProvider root & MaterialApp setup
│   └── main.dart                   # Application entry point
├── test/
│   ├── unit/                       # Auth, Crop separation, Role auth, Privacy, Location tests
│   ├── widget/                     # Button, RoleBadge, StatCard widget tests
│   └── widget_test.dart            # Smoke test
└── pubspec.yaml                    # Flutter dependencies & asset declarations
```

---

## 🛠️ Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Framework** | Flutter 3.47.7 (Dart 3.13.5) | Cross-platform native mobile application |
| **Backend & DB** | Supabase & PostgreSQL | Realtime database, authentication & storage |
| **Security** | Row Level Security (RLS) | Server-side role authorization & data isolation |
| **State Mgmt** | `provider: ^6.1.2` | Clean, predictable reactive state management |
| **Local Cache** | `shared_preferences: ^2.5.4` | Offline caching of village data and user preferences |
| **Accessibility** | `flutter_tts: ^4.2.5` | Spoken Tamil voice guidance for senior farmers |
| **Network** | `connectivity_plus: ^7.0.0` | Real-time connection detection & offline banners |

---

## ⚙️ Backend Setup (Supabase & PostgreSQL)

The project includes production-ready SQL migrations in `supabase/migrations/`:

### 1. Execute SQL Migrations
In your Supabase project dashboard, navigate to **SQL Editor** and execute the migration files in numerical order:
1. `00001_initial_schema.sql` — Creates tables (`profiles`, `crops`, `crop_price_listings`, `crop_transactions`, `jobs`, `job_applications`, `government_schemes`, `village_announcements`, `gram_sabha_meetings`, `public_fund_records`, `village_complaints`).
2. `00002_rls_policies.sql` — Configures strict RLS security (protects worker phone numbers until explicit consent is given, blocks unverified users from creating official announcements or fund records).
3. `00003_seed_reference_data.sql` — Seeds authentic Tamil Nadu agricultural data (Paddy cultivars, Turmeric, Sugarcane, Cotton, Banana, 38 administrative districts, and schemes such as Kalaignar All Village Integrated Agriculture Development Programme and PM-KISAN).

### 2. Configure Client Keys
Open `lib/core/config/supabase_config.dart` or supply environment variables:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_PUBLIC_KEY';
}
```
> [!IMPORTANT]
> Never put the Supabase `service_role` key inside the mobile client. Only the public anonymous key (`anonKey` / `publishableKey`) is permitted in mobile builds.

---

## 🧪 Testing Suite & Quality Verification

All 20 unit and widget test cases are verified and passing with 100% green output:

```powershell
flutter test
```

### Test Coverage Highlights:
- **`auth_test.dart`**: Phone number length validation, OTP verification, session storage persistence.
- **`crop_price_separation_test.dart`**: Enforces Requirement 20—ensures trader offer prices (with 3-tier quality grades) are stored and queried separately from completed transaction prices.
- **`role_and_authorization_test.dart`**: Verifies that Panchayat Official accounts default to unverified and cannot perform administrative tasks without official approval.
- **`privacy_consent_test.dart`**: Verifies that agricultural worker phone numbers remain hidden until explicit consent is granted.
- **`location_test.dart`**: Verifies Tamil Nadu district and taluk hierarchy.
- **`uzhavan_widgets_test.dart`**: Tests senior-friendly button touch-states, role badges, and stat cards.
- **`widget_test.dart`**: Full app smoke test.

### Static Analysis:
```powershell
flutter analyze
```
Result: **No issues found! (0 errors, 0 warnings, 0 infos)**.

---

## 📲 Building & Installation Guide

### Android Build (APK / AAB)

#### Prerequisites:
1. Install [Android Studio](https://developer.android.com/studio) and the Android SDK command-line tools.
2. Ensure `ANDROID_HOME` environment variable is set.
3. Accept Android licenses:
   ```powershell
   flutter doctor --android-licenses
   ```

#### Build Release APK:
```powershell
flutter build apk --release
```
The output installable file will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

#### Install onto connected Android Phone:
Enable **Developer Options** and **USB Debugging** on the Android device, then run:
```powershell
flutter run -d <device-id> --release
```

---

### iOS Build & Signing (macOS with Xcode)

As with all Flutter iOS projects, final compilation, code signing, and IPA generation require a Mac running macOS with Xcode installed:

1. Clone or copy the `uzhavan360` directory to your macOS machine.
2. Install CocoaPods dependencies:
   ```bash
   cd ios && pod install && cd ..
   ```
3. Open the iOS workspace in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
4. In Xcode:
   - Select the **Runner** target.
   - Go to **Signing & Capabilities**.
   - Select your Apple Developer Team to generate signing certificates.
   - Verify Bundle Identifier: `com.uzhavan360.app`.
5. Run on an iOS device or build an Archive:
   ```bash
   flutter build ipa --release
   ```

---

## 🛡️ License & Copyright

Developed for rural communities across Tamil Nadu. All rights reserved.
