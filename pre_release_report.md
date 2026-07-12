# 🔍 Pre-Release Code Review — Athkar (Nur Tasbeeh)
> **Reviewer:** Antigravity AI | **Date:** 2026-07-11 | **Target:** Google Play

---

## 📊 Overall Assessment

| Category | Status | Score |
|---|---|---|
| Code Quality | ⚠️ Needs Fixes | 7/10 |
| Bugs & Crashes | 🔴 Critical Issues | 5/10 |
| Architecture | ✅ Good | 8/10 |
| UI/UX | ✅ Good | 8/10 |
| Play Store Readiness | ⚠️ Not Ready | 6/10 |

---

## 🔴 CRITICAL — Must Fix Before Publishing

### 1. Reminders do NOT actually work
**File:** [`settings_controller.dart`](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/settings/controller/settings_controller.dart) · [`settings_storage.dart`](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/core/service/settings_storage.dart)

The entire reminders section (Settings → Daily Reminder) **stores times but never schedules any actual notification**. Users can toggle it on/off and set times — but nothing ever fires. This is a broken feature being shipped to users.

**What's missing:**
- A local notifications package (`flutter_local_notifications` or `awesome_notifications`)
- Scheduling logic in `settings_controller.dart` when `toggleReminder()` / `updateMorningTime()` / `updateEveningTime()` are called
- Android permission in `AndroidManifest.xml`: `SCHEDULE_EXACT_ALARM` (Android 12+), `POST_NOTIFICATIONS` (Android 13+)

**Recommendation:** Either implement real notifications, or **remove the Reminders section from the UI** before shipping. Shipping a fake/broken feature is worse than not having it.

---

### 2. `backupData()` is FAKE — it shows a spinner and does nothing
**File:** [`settings_controller.dart` L61–108](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/settings/controller/settings_controller.dart#L61-L108)

```dart
Future<void> backupData() async {
  // ... shows a spinner ...
  await Future.delayed(const Duration(milliseconds: 1500)); // FAKE DELAY
  Get.back();
  Get.snackbar('Backup Successful', ...); // LIES TO THE USER
}
```

This **deceives the user** — it shows "Backup Successful" while doing absolutely nothing to their data. This will cause negative reviews and possible Play Store policy issues.

**Recommendation:** Implement real backup (export to file, Google Drive, etc.) or **rename/remove this button**. At minimum, call it "Export to JSON" and use the real `exportHistory()` function.

---

### 3. Empty file `gesture_ful_tap_zone.dart`
**File:** [`gesture_ful_tap_zone.dart`](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/home/ui/gesture_ful_tap_zone.dart)

This file is completely **empty** (0 bytes). The `GesturefulTapZone` class is defined inside `home_screen.dart` — but this empty file exists and is imported by nothing. It's dead weight and causes confusion.

**Fix:** Delete this file.

---

### 4. `removeAthkar()` has a bug — wrong index after filtering
**File:** [`dhikr_library_screen.dart` L166–167](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/library/ui/dhikr_library_screen.dart#L166-L167)

```dart
final globalIndex = tasbeehController.athkarList.indexOf(item);
```

`indexOf()` uses **object equality** (`==`). Since `Model` has no `==` override, this does a reference check. When the list is reactive and rebuilt after edits, references may no longer match — causing `indexOf()` to return `-1`, then `removeAthkar(-1)` silently fails (the index check catches it) but the wrong item could be matched if there are duplicate-value objects.

**Fix:** Override `==` and `hashCode` in `Model`, or use index-based tracking instead of `indexOf()`.

---

## 🟠 HIGH PRIORITY — Fix Before Publishing

### 5. Notifications permission missing from `AndroidManifest.xml`
**File:** [`AndroidManifest.xml`](file:///Users/axon/Desktop/my_flutter_project/athkar/android/app/src/main/AndroidManifest.xml)

Even if you keep the reminders UI and plan to implement them later, the manifest is missing:
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```
These are needed for any notification functionality.

---

### 6. `shared_preferences` AND `get_storage` both imported — duplicate storage
**File:** [`pubspec.yaml`](file:///Users/axon/Desktop/my_flutter_project/athkar/pubspec.yaml#L44)

You have **both** `shared_preferences: ^2.2.2` AND `get_storage: ^2.1.1`. The code only uses `GetStorage`. The `shared_preferences` package is dead weight adding ~80KB to your APK.

**Fix:** Remove `shared_preferences` from `pubspec.yaml`.

---

### 7. `video_player` package included but never used
**File:** [`pubspec.yaml`](file:///Users/axon/Desktop/my_flutter_project/athkar/pubspec.yaml#L45)

`video_player: ^2.8.2` is listed but no video player feature exists anywhere in the code. This adds unnecessary APK size (~1MB+) and requires additional permissions.

**Fix:** Remove `video_player` from `pubspec.yaml`.

---

### 8. `numberpicker` package included but never used
**File:** [`pubspec.yaml`](file:///Users/axon/Desktop/my_flutter_project/athkar/pubspec.yaml#L39)

`numberpicker: ^2.1.2` is imported in pubspec but grep shows it is **never used** in any `.dart` file.

**Fix:** Remove `numberpicker` from `pubspec.yaml`.

---

### 9. `animated_flip_counter` package included but never used
**File:** [`pubspec.yaml`](file:///Users/axon/Desktop/my_flutter_project/athkar/pubspec.yaml#L40)

Same issue — imported but unused.

**Fix:** Remove `animated_flip_counter` from `pubspec.yaml`.

---

### 10. Settings — `_buildAppearanceGroup()` is dead code (commented out)
**File:** [`settings_screen.dart` L50–51](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/settings/ui/settings_screen.dart#L50-L51)

The theme switcher (Dark/Light/System/Language) is **commented out of the UI** but the entire `_buildAppearanceGroup()` method (51 lines) still exists. The static analyzer already flags this:
```
warning • The declaration '_buildAppearanceGroup' isn't referenced • unused_element
```

**Fix:** Either uncomment it in the UI (recommended — it's a great feature) or delete the method.

---

### 11. Version is `1.0.0+1` — too low for initial Play Store release
**File:** [`pubspec.yaml` L19](file:///Users/axon/Desktop/my_flutter_project/athkar/pubspec.yaml#L19)

This is fine for a first upload, but the `versionCode` (build number) **must increment with every upload**. Make sure you understand: `1.0.0+1` → version name is `1.0.0`, version code is `1`. If you ever try to upload without incrementing `+1`, Play Store will reject it.

---

## 🟡 MEDIUM PRIORITY — Should Fix

### 12. `SettingsController.onInit()` loads settings twice
**File:** [`settings_controller.dart` L10–17](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/settings/controller/settings_controller.dart#L10-L17)

```dart
final settings = SettingsStorage.load().obs; // Load #1 at field init
@override
void onInit() {
  super.onInit();
  settings.value = SettingsStorage.load(); // Load #2 redundant
}
```

The field initializer already loads from storage. `onInit()` loads again. This is harmless but wasteful. Remove the `onInit()` override entirely or just call `super.onInit()`.

---

### 13. Hardcoded colors in controllers — breaks theming
**Files:** [`tasbeeh_controller.dart` L203–226](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/home/controller/tasbeeh_controller.dart#L203-L226), [`settings_controller.dart` L62–163](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/settings/controller/settings_controller.dart#L62-L163)

Multiple dialogs use raw hex colors like `Color(0xFF191F31)` instead of `AppTheme` constants. This breaks light mode — dialogs will be dark even when the app is in light mode.

```dart
AlertDialog(
  backgroundColor: const Color(0xFF191F31), // ❌ hardcoded dark color
```

**Fix:** Use `AppTheme.surfaceContainer` or read from `Theme.of(context)`.

---

### 14. `NurAppBar` — `onStreakTap` parameter is unused
**File:** [`nur_app_bar.dart` L8](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/core/widgets/nur_app_bar.dart#L8)

The `onStreakTap` parameter is accepted but never wired to any gesture in the widget body. The streak row is just a `Row` with no tap handler. This was likely left over from a refactor.

---

### 15. Weekly bar chart — `todayIndex` is wrong for Sunday
**File:** [`statistics_controller.dart` L75–78](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/statistics/controller/statistics_controller.dart#L75-L78)

```dart
int get todayIndex {
  final weekday = DateTime.now().weekday; // Mon=1, Sun=7
  return weekday - 1; // Sunday → index 6
}
```

The `dayLabels` array is `['M','T','W','T','F','S','S']` (Monday first). But the chart data is built from `now.subtract(Duration(days: 6-i))` starting from 6 days ago. These two systems are independent — "today's index" in the label array won't match "today's bar" in the chart data unless the week always starts on Monday. On weeks where today doesn't align perfectly, the highlight will be on the wrong bar.

---

### 16. `libray_controller.dart` — `LibraryController` is `Get.put()` inside `build()`
**File:** [`dhikr_library_screen.dart` L17](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/library/ui/dhikr_library_screen.dart#L17)

```dart
final LibraryController libraryController = Get.put(LibraryController());
```

Calling `Get.put()` inside `build()` means every time the widget rebuilds, it tries to put a new controller. GetX handles duplicates, but the correct pattern is `Get.put()` in `main.dart` or use `Get.find()` if already registered. This can also cause state resets.

---

### 17. Font families declared in `app_theme.dart` but not loaded in `pubspec.yaml`
**File:** [`app_theme.dart` L82–84](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/core/constants/app_theme.dart#L82-L84)

```dart
static const String fontAmiri = 'Amiri';
static const String fontNotoNaskhArabic = 'Noto Naskh Arabic';
```

These fonts are referenced heavily across the app (Arabic text display) but are NOT declared in `pubspec.yaml` under `fonts:`. Flutter will silently fall back to the system default Arabic font, which may look different on various Android devices (especially low-end ones).

**Recommended:** Either add the font files to `assets/` and declare in pubspec, or use `google_fonts` package (which is already included) to load them dynamically:
```dart
GoogleFonts.amiri(...)
GoogleFonts.notoNaskhArabic(...)
```

---

### 18. `TweenAnimationBuilder` missing `begin` value
**File:** [`home_screen.dart` L290–294](file:///Users/axon/Desktop/my_flutter_project/athkar/lib/fauther/home/ui/home_screen.dart#L290-L294)

```dart
TweenAnimationBuilder<double>(
  tween: Tween(
    end: fraction.clamp(0.0, 1.0), // ❌ no `begin` specified
  ),
```

Without `begin`, the tween starts from wherever it was, which causes a jump on first render. Should be `Tween(begin: 0.0, end: fraction)`.

---

## 🔵 LOW PRIORITY — Polish

### 19. Typo in variable name throughout codebase
**Files:** Multiple

`bubleEffectEnabled` → should be `bubbleEffectEnabled`. This appears in `settings_storage.dart`, `settings_controller.dart`, and `settings_screen.dart`. Low priority but looks unprofessional in any future debug logs.

### 20. Folder name typo: `/lib/fauther/` → should be `/lib/features/`
**File:** All files under `lib/fauther/`

This is the main feature folder but it's named `fauther` (likely meant `feature`). Not a runtime issue but affects code readability.

### 21. Commented-out code throughout — clean up before release
Multiple files contain extensive blocks of commented-out code (especially `home_screen.dart`, `nur_app_bar.dart`). This is dead code that should be removed before release.

### 22. App title inconsistency
- `pubspec.yaml` name: `athkar`
- `AndroidManifest.xml` label: `Nur Tasbeeh`
- `AppStrings.appTitle`: `Athkar`
- App ID: `com.iziadehap.athkar`

Pick one consistent name and brand. The user sees "Nur Tasbeeh" as the app name on their Android device.

### 23. Missing `privacy_policy` / `terms_of_service` link
Google Play requires a **privacy policy URL** for any app. There is no privacy policy in the app or mentioned anywhere. You need to publish one and add it to the Play Store listing.

### 24. `.DS_Store` files tracked in the project
**Affected:** `/lib/.DS_Store`, `/lib/fauther/.DS_Store`, etc.

macOS `.DS_Store` files are scattered throughout the project and should be in `.gitignore`. They don't affect the build but make the repo messy.

---

## ✅ What's Working Well

- **Clean architecture** — MVC with GetX is consistent and well-structured
- **Persistent storage** — GetStorage is properly initialized in `main()` and used correctly
- **Reactive state** — `Obx()` / `obs` used correctly throughout
- **Confetti completion** — Properly implemented with `ever()` worker and disposed correctly in `dispose()`
- **Animated navigation bar** — Smooth sliding indicator with `AnimatedPositioned`
- **Statistics calculation** — Streak logic in `_calculateStreak()` is correct
- **Model serialization** — `fromJson/toJson/copyWith` are all correct
- **Themed UI** — Consistent design system in `AppTheme` with proper dark mode support
- **Safe area handling** — `SafeArea` used on all screens
- **Page controller disposal** — `pageController.dispose()` in `onClose()` is correct
- **flutter_native_splash** — Configured correctly
- **No analyzer errors** — Only 1 minor warning

---

## 📋 Priority Action List

```
🔴 BEFORE SHIPPING:
  [ ] Fix or remove fake backupData()
  [ ] Fix or remove broken Reminders (no actual notifications)
  [ ] Delete empty gesture_ful_tap_zone.dart
  [ ] Remove unused packages: shared_preferences, video_player, numberpicker, animated_flip_counter

🟠 HIGHLY RECOMMENDED:
  [ ] Add Amiri + Noto Naskh Arabic fonts (or switch to GoogleFonts)
  [ ] Fix hardcoded colors in dialogs for light mode support
  [ ] Remove or wire up the commented _buildAppearanceGroup (theme switcher is valuable)
  [ ] Fix double-load in SettingsController.onInit()
  [ ] Move Get.put(LibraryController()) out of build() method

🟡 SHOULD DO:
  [ ] Override == and hashCode in Model class
  [ ] Add begin: 0.0 to TweenAnimationBuilder
  [ ] Fix NurAppBar onStreakTap wiring
  [ ] Fix todayIndex alignment in statistics weekly chart

🔵 NICE TO HAVE:
  [ ] Fix typos: bubleEffectEnabled → bubbleEffectEnabled
  [ ] Clean up all commented-out code
  [ ] Add .DS_Store to .gitignore
  [ ] Publish a privacy policy
```
