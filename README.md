# flutter_firebase_firestore

A Flutter project demonstrating Firestore integration for student management.

## Features
- **Firestore Database**: Store and manage student records.
- **Firebase Storage**: Upload and retrieve student profile images.
- **Image Picker**: Select images from the gallery.
- **CRUD Operations**: Add, update, delete, and display student data in real-time.

## Prerequisites

Before running the project, ensure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- A Firebase project set up on the [Firebase Console](https://console.firebase.google.com/)

---

## 1️⃣ Install Dependencies

Run the following commands to add the required Firebase packages:

```sh
flutter pub add firebase_core cloud_firestore firebase_storage image_picker
```

---

## 2️⃣ Configure Firebase

To connect your Flutter project with Firebase:

1. **Create a Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/).
   - Click **Add Project** and follow the setup process.

2. **Enable Firestore**
   - Navigate to **Firestore Database** in Firebase Console.
   - Click **Create Database** and set the security rules accordingly.

3. **Enable Firebase Storage**
   - Go to **Storage** in Firebase Console.
   - Click **Get Started** and configure storage settings.

4. **Register Your App**
   - In Firebase Console, go to **Project Settings** > **General**.
   - Add an iOS/Android app and follow the setup instructions.

5. **Download Firebase Configuration**
   - For **Android**: Download `google-services.json` and place it inside `android/app/`.
   - For **iOS**: Download `GoogleService-Info.plist` and place it inside `ios/Runner/`.

---

## 3️⃣ Integrate Firebase with Flutter

Run the following command to configure Firebase:

```sh
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_FIREBASE_PROJECT_NAME
```

This will generate a `firebase_options.dart` file, which contains Firebase configurations.

---

## 4️⃣ Run the App

Ensure everything is set up correctly, then start the app:

```sh
flutter run
```

---

## Project Structure

```
lib/
│── main.dart                # Main entry point
│── student_list.dart        # UI to display students
│── student_dialogs.dart     # Dialogs for adding/editing/deleting students
├── firebase_options.dart    # Auto-generated Firebase config
```

---

## 🔥 Firestore Database Structure

The Firestore collection used in this project:

```
students (Collection)
 ├── student_id (Document)
 │   ├── name: "John Doe"
 │   ├── student-id: "12345"
 │   ├── major: "Computer Science"
 │   ├── year: "4"
 │   ├── photoUrl: "https://..."
 │   ├── timestamp: Server Timestamp
```

---

## 🔒 Firestore Security Rules

To secure Firestore, update your rules in **Firestore Rules**:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /students/{studentId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 🚀 Next Steps

- Add **User Authentication** (Firebase Auth).
- Improve **UI/UX** with better designs.
- Optimize **Firestore queries** for performance.

---

## 📌 Resources

- [FlutterFire Docs](https://firebase.flutter.dev/docs/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Storage](https://firebase.google.com/docs/storage)