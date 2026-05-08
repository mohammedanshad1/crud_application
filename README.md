# Notes App

A secure, feature-rich Notes application built with Flutter and Firebase. Manage your notes seamlessly with offline support and real-time synchronization.

## Features

- 🔐 **User Authentication**: Sign up and log in with email and password
- 📝 **CRUD Operations**: Create, read, update, and delete notes
- 🔒 **Secure Access**: Users can only access their own notes
- 🔍 **Search Functionality**: Client-side search to find notes by title or content
- 📱 **Session Persistence**: Automatic login on app restart
- 🎨 **Clean UI**: User-friendly interface with Material Design 3

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase (Authentication + Firestore)
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: Provider
- **Localization**: intl package for date formatting

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart      # User data model
│   └── note_model.dart      # Note data model
├── services/                 # Firebase services
│   ├── auth_service.dart    # Authentication logic
│   └── notes_service.dart   # Notes CRUD logic
├── viewmodels/              # MVVM ViewModels
│   ├── auth_viewmodel.dart  # Authentication state
│   └── notes_viewmodel.dart # Notes state
└── views/                    # UI Screens
    ├── screens/
    │   ├── login_screen.dart
    │   ├── signup_screen.dart
    │   ├── notes_list_screen.dart
    │   ├── create_note_screen.dart
    │   └── edit_note_screen.dart
    └── widgets/
```

## Getting Started

### Prerequisites

- Flutter SDK (^3.7.0)
- Dart SDK
- Android emulator or physical device
- Firebase project configured

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/crud_application.git
   cd crud_application
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - The Firebase configuration is already set up in the project
   - Ensure your `google-services.json` is placed in `android/app/`
   - For iOS, ensure your `GoogleService-Info.plist` is configured

4. **Run the app**
   ```bash
   flutter run
   ```

### Building APK

To create a release APK:

```bash
flutter build apk --release
```

The APK will be generated at `build/app/outputs/flutter-app/release/app-release.apk`

## Database Schema

### Firestore Collections

#### `users` Collection
Stores user profile information.

```
users/
  {uid}/
    email: string
    displayName: string (optional)
    createdAt: timestamp
```

#### `notes` Collection
Stores all notes with user ownership.

```
notes/
  {noteId}/
    userId: string (user who owns the note)
    title: string
    content: string
    createdAt: timestamp
    updatedAt: timestamp
```

**Security**: Firestore rules ensure users can only access/modify their own notes and user documents.

## Authentication

### Implementation Details

- **Method**: Email and password authentication via Firebase Auth
- **Session Management**: Firebase Auth handles automatic session persistence
- **User State**: AuthViewModel listens to Firebase auth state changes
- **Auto-Login**: App checks authentication status on startup and routes accordingly

### User Flow

1. **Sign Up**: Create new account → Save user to Firestore → Auto-login
2. **Login**: Authenticate with Firebase → Fetch user data → Redirect to notes
3. **Logout**: Sign out → Clear session → Return to login screen
4. **Persistence**: App remembers login state across restarts

## Features Implemented

### Authentication
- ✅ Sign up with email and password
- ✅ Login with email and password
- ✅ Logout functionality
- ✅ Session persistence after app restart

### Notes Management (CRUD)
- ✅ Create new notes with title and content
- ✅ View all user's notes in a list
- ✅ Edit existing notes
- ✅ Delete notes with confirmation
- ✅ User-specific access (security)

### Additional Feature: Search Notes
- ✅ Search notes by title (client-side)
- ✅ Search notes by content (client-side)
- ✅ Real-time search results
- ✅ Clear search functionality

## Usage Guide

### Creating a Note
1. Tap the "+" button at the bottom right
2. Enter note title and content
3. Tap "Save" to create

### Editing a Note
1. Tap on a note from the list
2. Edit title or content
3. Tap "Save" to update

### Deleting a Note
1. Tap on a note card
2. Tap the menu icon (three dots)
3. Select "Delete" and confirm

### Searching Notes
1. Use the search bar at the top of the notes list
2. Type title or content keywords
3. Results update in real-time
4. Clear button to reset search

## Assumptions & Trade-offs

### Assumptions
- Users have stable internet connection for real-time sync
- Email addresses are unique identifiers
- Single device per user session (no multi-device sync)

### Trade-offs
- **Client-side Search**: Chosen for simplicity; large note collections might benefit from Firestore query optimization
- **Simple UI**: Prioritized functionality and code structure over advanced design
- **No Offline Mode**: App requires internet; future enhancement could add offline support

## Error Handling

The app handles various error scenarios:
- Invalid email/password validation
- Network connectivity issues
- Firebase authentication errors (user not found, weak password, etc.)
- Firestore operation failures

Error messages are displayed to users with clear guidance.

## Performance Considerations

- **Stream-based Updates**: Real-time note list updates using Firestore streams
- **Lazy Loading**: Notes load as users scroll
- **Efficient State Management**: Provider package minimizes rebuilds
- **Timestamp Indexing**: Firestore queries optimized with updatedAt index

## Security

- **User Isolation**: Each user's notes stored with userId reference
- **No Cross-user Access**: Firestore security rules prevent unauthorized access
- **Secure Passwords**: Firebase Auth handles password security
- **No Sensitive Data**: No API keys or credentials in app code

## Future Enhancements

- 📴 Offline support with local caching
- 🔄 Cloud sync for multiple devices
- 📎 Note attachments/images
- 🏷️ Note categories and tags
- 📱 Push notifications for reminders
- 🌙 Dark mode support

## Troubleshooting

### App crashes on startup
- Ensure Firebase is properly initialized
- Check `firebase_options.dart` configuration
- Verify `google-services.json` is in correct location

### Can't login/signup
- Check internet connection
- Verify Firebase project is active
- Check Firestore security rules allow user creation

### Notes not loading
- Ensure user is authenticated
- Check Firestore has notes for current user
- Verify security rules allow reading notes

## License

This project is provided as-is for the technical assessment.

## Contact

For questions or issues, please contact the development team.

---

**Built with ❤️ using Flutter and Firebase**
