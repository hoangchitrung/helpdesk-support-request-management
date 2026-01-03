# <img width="41" height="41" alt="logo" src="https://github.com/user-attachments/assets/96bc1a48-c17b-48ff-91b3-6e8440cf9c7c" /> Helpdesk Support Request Management

A mobile application built with Flutter and Firebase designed to streamline technical support workflows within organizations. This project focuses on efficient request tracking, task assignment, and progress monitoring.

## 📋 Project Overview (Topic 3)
In organizations, technical support requests are frequently generated and must be carefully tracked to ensure timely resolution. A helpdesk system helps manage requests, assign tasks, and monitor work progress.

### Key Features
1. **Create Support Requests**: Users can submit tickets including content, priority level (Low, Medium, High), and automatic recording of submission time.
2. **User Management**: Maintains detailed information for both requesters and technical support staff.
3. **Task Assignment**: Administrators or managers can assign specific support requests to available staff members.
4. **Status Tracking**: Real-time monitoring of ticket status: **New** → **In Progress** → **Completed**.
5. **Progress Updates & History**: Staff can update processing progress and the system maintains a full audit log of status changes.
6. **Advanced Search**: Easily filter and search for support requests by their current status or by the original requester.

---

## 🛠 Tech Stack
- **Frontend**: Flutter (Dart SDK)
- **Backend**: Firebase Authentication (User Identity)
- **Database**: Cloud Firestore (NoSQL Real-time Database)
- **Tools**: FlutterFire CLI, Git

---

## 📂 Project Structure
The project follows a clean architecture to ensure maintainability:

- `lib/src/models/`: Data models for Requests, Users, and History logs.
- `lib/src/services/`: Logic for Firebase Auth and Firestore interactions.
- `lib/src/screens/`: UI screens (Login, Home, Create Request, Management Dashboard).
- `lib/src/widgets/`: Reusable UI components like custom cards and status badges.
- `assets/`: App icons and screenshots.

---

## 🗄 Data Model (Cloud Firestore)

### Collection: `users`
- `uid`: String (Unique identifier from Firebase Auth)
- `full_name`: String (Display name)
- `email`: String (User email)
- `role`: String (`requester`, `staff`, or `admin`)

### Collection: `requests`
- `request_id`: String (Auto-generated ID)
- `content`: String (The issue description)
- `priority`: String (`Low`, `Medium`, `High`)
- `status`: String (`New`, `In Progress`, `Completed`)
- `submission_time`: Timestamp (When the ticket was created)
- `requester_id`: String (Reference to the user who created the ticket)
- `staff_id`: String (Reference to the assigned staff member)
- `history`: List<Map> (Audit trail of status changes and notes)

---

## 🚀 Getting Started
1. **Clone the repository**:
  ```bash
  git clone https://github.com/hoangchitrung/helpdesk-support-request-management.git
  cd helpdesk-support-request-management
  ```
2. **Install dependencies**:
  ```bash
  flutter pub get
  ```
3. **Firebase Configuration**:
- Run `flutterfire configure` to link your local enviroment with your Firebase project.
- Ensure `firebase_options.dart` is generated in the `lib` folder
4. **Run the app**:
  ```bash
  fluter run
  ```
## 📱 Project Demo
1. **Register Screen**

<img width="411" height="863" alt="image" src="https://github.com/user-attachments/assets/3cfb90c8-c410-4978-ab53-9f2917795041" />

2. **Login Screen**

<img width="411" height="863" alt="image" src="https://github.com/user-attachments/assets/520f9ea4-00cf-461b-a0ad-2ace0f5248de" />

3. **User Home Screen**

<img width="411" height="863" alt="image" src="https://github.com/user-attachments/assets/da476b4b-72a6-43d9-a13d-7b7c8bdb41e5" />

4. **Add Request Screen**

<img width="411" height="863" alt="image" src="https://github.com/user-attachments/assets/8bd9dbdc-afc1-4dd0-bdfc-0b8ca3998f62" />

5. **Admin Home Screen**

<img width="411" height="863" alt="image" src="https://github.com/user-attachments/assets/859b35a9-890a-4999-a23a-7be9a7b6d45f" />

6. **Staff Manage Screen**

<img width="411" height="863" alt="image" src="https://github.com/user-attachments/assets/31ccf97a-2f20-4100-bd81-9538c9620420" />

7. **Requesters Manage Screen**

<img width="411" height="863" alt="image" src="https://github.com/user-attachments/assets/973e5a7a-1f09-4705-8ae0-58a17dc9763d" />

8. **Staff Home Screen**

<img width="411" height="863" alt="image" src="https://github.com/user-attachments/assets/adf435f7-3d44-480b-ac85-1dc406eed248" />

9. **Requests History Screen**

<img width="411" height="863" alt="image" src="https://github.com/user-attachments/assets/6938045e-e297-4078-b353-3cb77375eab6" />

