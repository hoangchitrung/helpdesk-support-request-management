# 🛠️ Helpdesk Support Request Management

![App Icon]<img width="1024" height="1024" alt="image" src="https://github.com/user-attachments/assets/c0adfbf6-a91a-41c3-af31-f2e0876a597b" />
) <!-- Replace path if you store the icon elsewhere -->

Short description
A mobile Helpdesk Support Request Management app built with Flutter and Firebase. It allows users to create support requests, assign them to staff, track status and progress, and keep a history of changes.

Topic: Helpdesk Support Request Management Application  
Project: Final Term Mobile Programming Project — Flutter & Firebase

---

## Key features (mapped to project requirements)
1. Create support requests with content, priority level, and submission time.  
2. Manage requester and support staff information.  
3. Assign support requests to staff members.  
4. Track request status: New → In Progress → Completed.  
5. Update processing progress and store an audit/history of status changes.  
6. Search and filter requests by status and requester.

---

## Tech stack
- Frontend: Flutter (Dart)  
- Backend / Realtime DB: Firebase (Firestore, Authentication, optionally Cloud Functions)  
- Storage: Firebase Storage (for attachments/screenshots)  
- Optional: Firebase Cloud Messaging for push notifications

---

## Project structure (recommended / typical for Flutter + Firebase)
- lib/
  - main.dart
  - src/
    - models/ (request.dart, user.dart, staff.dart, status_change.dart)
    - services/ (auth_service.dart, firestore_service.dart, storage_service.dart)
    - screens/ (login, request_list, request_detail, create_request, assign)
    - widgets/ (request_card, status_timeline)
    - providers/ or state/ (Riverpod / Provider / Bloc files)
- assets/
  - icon.png (app icon / README icon)
  - screenshots/
- android/, ios/, web/ (platform folders)
- pubspec.yaml

---

## Firestore data model (recommended)
Collections and example document shapes:

- requests (collection)
  - id (doc id)
  - title: string
  - description: string
  - priority: "Low" | "Medium" | "High"
  - requesterId: uid
  - assigneeId: uid | null
  - status: "New" | "InProgress" | "Completed"
  - attachments: [storagePaths]
  - createdAt: timestamp
  - updatedAt: timestamp

- users (collection) — requesters and staff profiles
  - uid (doc id)
  - name
  - email
  - role: "requester" | "staff" | "admin"
  - phone
  - avatarUrl

- status_changes (subcollection under each request or a top-level collection)
  - id
  - requestId
  - fromStatus
  - toStatus
  - note
  - changedBy: uid
  - changedAt: timestamp

Notes:
- Using a subcollection like requests/{requestId}/history is convenient for per-request history.
- Indexes: create composite indexes for queries like (requesterId + status) if necessary.

---

## Firebase setup (quick)
1. Create a Firebase project in the Firebase Console.
2. Add Android and/or iOS app to the project.
   - Android: download google-services.json → place in android/app/
   - iOS: download GoogleService-Info.plist → place in ios/Runner/
3. Enable Firestore (Native mode).
4. Enable Firebase Authentication (Email/Password, or Google, etc.).
5. Enable Firebase Storage if attachments are needed.
6. (Optional) Set up Firebase Cloud Messaging for push notifications.
7. (Optional for dev) Install and run Firebase Emulators (Firestore, Auth, Storage) to test locally.

Firestore Security rules (simple example idea)
- Allow authenticated users to create requests.
- Staff and admin roles can update status/assign.
- Only request owner or staff can view or update (adapt to your policy).

---

## Run the app (Flutter)
1. Install Flutter SDK and set up platforms (Android/iOS).
2. Install dependencies:
   - flutter pub get
3. Run:
   - flutter run
4. For debug with emulators:
   - Start Firebase emulators and configure the app to use emulator host (see firebase_local_emulator docs).

Suggested pubspec dependencies
- firebase_core
- cloud_firestore
- firebase_auth
- firebase_storage
- flutter_local_notifications (optional)
- provider or flutter_riverpod (state management)
- intl (dates)

---

## UI / Screenshots / Icon
Place app icon and screenshots under `assets/`. Example assets:
- assets/icon.png (app icon shown above)
- assets/screenshots/screen-1.png
- assets/screenshots/screen-2.png

Add images to README (example):
![Screenshot 1](./assets/screenshots/screen-1.png)
![Screenshot 2](./assets/screenshots/screen-2.png)

App icon: put `icon.png` or `icon.svg` in `assets/` and reference it in README and in Flutter app launcher configurations.

---

## API / App flows (high level)
- Create Request:
  - User enters title, description, priority, optionally attachments → App writes to Firestore `requests` with status = New and createdAt timestamp.
- Assign:
  - Admin/Staff selects a request, chooses assignee → update `assigneeId` and optionally add a status_change record.
- Update Status:
  - Staff updates status or progress note → write to request doc and append a history entry in `requests/{id}/history`.
- Search / Filter:
  - Query Firestore by status or requesterId. Use indexes for performance.
