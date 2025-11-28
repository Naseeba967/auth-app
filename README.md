
# Task Manager - Flutter App

A clean, well-structured Flutter Task Management application with data persistence using SharedPreferences, including a Task model, Task service for CRUD operations, Home screen with task list display, Add Task screen with form validation, reusable widgets for task items, and authentication features such as user sign-up, login, logout, and session management.

## Features
- **User Registration**: Create a new user account using email & password via firebase_auth.dart.
- **User Login**: Secure login with Firebase Authentication using email & password.
- **User Logout**: One-tap logout that redirects to login screen and clears user session. 
- **View Tasks**: Display all tasks in a beautiful card-based list
- **Add Tasks**: Add new tasks via AppBar action button with input validation
- **Complete Tasks**: Toggle task completion with checkbox (visual line-through effect)
- **Delete Tasks**: Remove tasks with delete icon button and confirmation snackbar
- **Data Persistence**: All tasks are saved locally using SharedPreferences
- **Clean UI**: Material Design 3 with custom styling, proper spacing, and pleasant fonts

## Screenshots

The app features:
- Custom AppBar with "Task Manager" title and add button
- Empty state when no tasks exist
- Task cards with checkbox, title, and delete button
- Visual feedback for completed tasks (line-through text)

## Folder Structure

```
task_manager/
├── lib/
│   ├── main.dart                      # App entry point and MaterialApp setup
│   ├── models/
│   │   └── task.dart                  # Task model with JSON serialization
│   ├── screens/
│   │   ├── splash_screen.dart         # App initial loading + auth checking
│   │   ├── login_screen.dart          # User login UI
│   │   ├── signup_screen.dart         # User registration UI
│   │   └── home_screen.dart           # Main UI with task list and actions
│   ├── services/
│   │   ├── task_service.dart          # SharedPreferences data operations
│   │   └── firebase_auth.dart         # Firebase authentication service
│   ├── widgets/
│   │   ├── custom_button.dart         # Reusable button widget
│   │   └── custom_text_field.dart     # Reusable text field widget
│   ├── utils/
│   │   └── constant.dart              # App constants (colors, strings)
├── pubspec.yaml                       # Project dependencies
└── README.md                          # Project documentation


```

## Dependencies

- `flutter`: Core Flutter framework
- `shared_preferences`: Local data persistence
- `cupertino_icons`: iOS-style icons


## Code Architecture
### Firebase Auth Service ('lib/services/firebase_auth.dart')
-Wraps Firebase Authentication features
-Methods:
Future<String?> signUp(String name, String email, String password)
Future<String?> signIn(String email, String password)
Future<String?> resetPassword(String email)
Future<void> signOut()
### Task Model (`lib/models/task.dart`)
- Defines the `Task` class with `id`, `title`, and `isCompleted` properties
- Includes JSON serialization/deserialization methods
- Static methods for encoding/decoding task lists

### Task Service (`lib/services/task_service.dart`)
- Handles all SharedPreferences operations
- Methods: `loadTasks()`, `saveTasks()`, `addTask()`, `toggleTaskCompletion()`, `deleteTask()`
- Encapsulates data persistence logic

### Home Screen (`lib/screens/home_screen.dart`)
- Main UI widget with StatefulWidget for state management
- Implements task list display using `ListView.builder`
- Dialog for adding new tasks with form validation
- Task cards with completion toggle and delete functionality

### Main Entry (`lib/main.dart`)
- App initialization and MaterialApp configuration
- Theme setup with Material Design 3
- Custom color scheme and component styling

## Features in Detail

### Input Validation
- Empty task titles are not allowed
- Visual error feedback in the add task dialog

### Visual Feedback
- Completed tasks show with line-through text style
- Completed tasks are grayed out
- Green checkbox when task is completed
- Snackbar notification when task is deleted

### Data Persistence
- Tasks are automatically saved when added, updated, or deleted
- Tasks persist across app restarts
- JSON encoding for structured data storage

## License

This project is open source and available.


---
