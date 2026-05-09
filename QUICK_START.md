# 🚀 Quick Start Guide - Firebase Setup

## Your Debug Certificate Details

**SHA-1 Fingerprint:**
```
78:79:24:57:F3:C9:13:44:DF:8E:32:77:51:08:8E:08:44:80:EB:EC
```

**Package Name:**
```
com.appcrew.crudapp.crud_application
```

## 5-Minute Setup (Do This Now!)

### Step 1: Add SHA-1 to Firebase Console (2 min)
```
1. Go to console.firebase.google.com
2. Select your project
3. Click ⚙️ (Settings) → Project Settings
4. Click your Android app
5. Scroll to "SHA certificate fingerprints"
6. Click "Add fingerprint"
7. Paste: 78:79:24:57:F3:C9:13:44:DF:8E:32:77:51:08:8E:08:44:80:EB:EC
8. Click Save
```

### Step 2: Download Updated google-services.json (1 min)
```
1. Still in Project Settings
2. Click "google-services.json" download button
3. Move it to: D:\crud_application\android\app\google-services.json
4. Replace the old file
```

### Step 3: Enable Email/Password Auth (1 min)
```
1. Go to Authentication (left sidebar)
2. Click "Sign-in method" tab
3. Find "Email/Password"
4. Toggle to Enable (should turn blue)
5. Click Save
```

### Step 4: Test the App (1 min)
```bash
cd D:\crud_application
flutter clean
flutter pub get
flutter run
```

## Expected Results

### ✅ Sign Up Screen
- No reCAPTCHA errors
- Can create account with email/password
- Password must be 6+ characters
- Passwords must match

### ✅ Login Screen
- Can login with created credentials
- Session persists after app restart
- Error messages are clear if credentials wrong

### ✅ Notes Screen
- Can create, read, update, delete notes
- Search works
- All notes are user-specific

## Troubleshooting

### Error: "CONFIGURATION_NOT_FOUND"
→ You missed Step 1 or Step 2 above

### App Still Crashes
→ Run this:
```bash
flutter clean
flutter pub get
flutter run
```

### Still Not Working?
→ Verify:
- [ ] SHA-1 added to Firebase Console
- [ ] google-services.json in android/app/
- [ ] Email/Password auth enabled
- [ ] Package name matches: `com.appcrew.crudapp.crud_application`

## Next Steps

After setup works:
1. **Test all features** (create/edit/delete notes, search)
2. **Test persistence** (restart app while logged in)
3. **Build APK** when ready: `flutter build apk --release`

## Files to Know About

- `lib/main.dart` - App entry point, theme config
- `lib/services/auth_service.dart` - Firebase auth logic
- `lib/services/notes_service.dart` - Firestore CRUD
- `android/app/build.gradle` - Package name & signing config
- `android/app/google-services.json` - Firebase configuration

## Success! 🎉

When this is all working:
1. Push code to public GitHub
2. Build release APK: `flutter build apk --release`
3. Share APK + GitHub repo link with evaluators
4. Done! ✨
