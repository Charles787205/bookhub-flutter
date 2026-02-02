<div align="center">
  <img src="images/bookhub.png" alt="BookHub Logo" width="120" height="120">
  
  # 📚 BookHub
  
  **Your Personal Digital Library Management System**
  
  A modern, elegant Flutter application for browsing, borrowing, and managing books with seamless integration to Google Books API.
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.3.1+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.3.1+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-Private-red)]()
</div>

---

## ✨ Features

### 🔐 **User Authentication**
- Secure user registration and login system
- Session management with Provider state management
- Persistent authentication across app sessions

### 📖 **Book Discovery**
- **Search & Browse**: Explore millions of books powered by Google Books API
- **Category Filtering**: Browse books by specific subjects and genres
- **Rich Book Details**: Access comprehensive information including titles, authors, descriptions, and cover images

### 📚 **Library Management**
- **Borrow Books**: Request books with customizable duration periods
- **Track Borrowed Books**: View all your currently borrowed books
- **Return History**: Keep track of previously returned books
- **Favorites**: Save your favorite books for quick access

### 🎨 **User Experience**
- Clean, intuitive Material Design 3 interface
- Responsive layouts for all screen sizes
- Custom widgets for seamless user interactions
- Rating system for borrowed books
- Real-time search functionality

---

## 🛠️ Technology Stack

### **Frontend**
- **Framework**: Flutter 3.3.1+
- **Language**: Dart 3.3.1+
- **State Management**: Provider 6.1.2
- **UI Design**: Material Design 3

### **APIs & Integrations**
| API/Service | Purpose | Version |
|------------|---------|---------|
| **Google Books API** | Book search, metadata, and cover images | 1.0.0 |
| **Custom PHP Backend** | User authentication, book borrowing, and database operations | Custom |
| **HTTP Client** | REST API communication | 0.13.5 |

### **Key Dependencies**
```yaml
dependencies:
  flutter: sdk
  http: ^0.13.5                    # HTTP requests
  provider: ^6.1.2                 # State management
  google_books_api: ^1.0.0        # Google Books integration
  cupertino_icons: ^1.0.6         # iOS-style icons
  flutter_launcher_icons: ^0.13.1 # App icon generation
```

---

## 📱 App Architecture

```
lib/
├── main.dart                      # App entry point
├── components/
│   └── auth_manager.dart          # Authentication state management
├── objects/
│   ├── user.dart                  # User model
│   ├── db_book.dart               # Database book model
│   ├── borrowed_books.dart        # Borrowed book model
│   ├── book_request.dart          # Book request model
│   └── categories.dart            # Category model
├── screens/
│   ├── login.dart                 # Login screen
│   ├── register.dart              # Registration screen
│   ├── home.dart                  # Home dashboard
│   ├── layout.dart                # App layout wrapper
│   ├── borrowed_books/            # Borrowed books feature
│   ├── returned_books/            # Return history feature
│   ├── categories/                # Category browsing
│   ├── favorites/                 # Favorites management
│   └── search/                    # Book search
├── scripts/
│   ├── database.dart              # Backend API connector
│   └── book_services.dart         # Google Books API service
└── widgets/
    ├── logo.dart                  # Logo widget
    ├── dashboard_button.dart      # Dashboard navigation
    ├── search.dart                # Search bar widget
    ├── borrow_alert_dialog.dart   # Borrow confirmation dialog
    └── rate_dialog.dart           # Book rating dialog
```

---

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK 3.3.1 or higher
- Dart SDK 3.3.1 or higher
- Android Studio / VS Code with Flutter extensions
- PHP backend server (for authentication and book management)

### **Installation**

1. **Clone the repository**
   ```bash
   git clone https://github.com/Charles787205/bookhub-flutter.git
   cd bookhub-flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Backend URL**
   
   Update the backend URL in [lib/scripts/database.dart](lib/scripts/database.dart):
   ```dart
   static String url = "YOUR_BACKEND_IP_OR_DOMAIN";
   ```

4. **Generate App Icons** (Optional)
   ```bash
   flutter pub run flutter_launcher_icons
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

---

## 📡 API Integration

### **Google Books API**
The app leverages the Google Books API to provide:
- **Volume Search**: Search by keyword, title, author, or ISBN
- **Subject Filtering**: Browse books by category/subject
- **Book Metadata**: Titles, authors, descriptions, publication dates
- **Cover Images**: Thumbnail and small thumbnail URLs

**Example Usage:**
```dart
final books = await GoogleBooksApi()
    .searchBooks(query, queryType: QueryType.subject);
```

### **Custom Backend API Endpoints**
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/user/login.php` | POST | User authentication |
| `/api/user/register.php` | POST | New user registration |
| `/api/request/add.php` | POST | Create book borrow request |
| `/api/request/get_request.php` | GET | Get user's book requests |
| `/api/book/get.php` | GET | Retrieve available books |

---

## 🎨 Design Philosophy

BookHub embraces a **warm, welcoming aesthetic** with:
- **Color Scheme**: Warm amber/gold tones (#F7BC6F, #F1D598)
- **Material Design 3**: Modern, cohesive component design
- **Responsive Layouts**: Optimized for phones, tablets, and desktops
- **Intuitive Navigation**: Clear user flows and interactions

---

## 📄 Project Status

**Version**: 1.0.0+1  
**Status**: Active Development  
**Platforms**: Android, iOS, Windows, macOS, Linux, Web

---

## 🤝 Contributing

This is a private project. For collaboration inquiries, please contact the repository owner.

---

## 📧 Contact

**Developer**: Charles787205  
**Repository**: [bookhub-flutter](https://github.com/Charles787205/bookhub-flutter)

---

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Google Books API Documentation](https://developers.google.com/books)
- [Provider State Management](https://pub.dev/packages/provider)
- [Material Design 3](https://m3.material.io/)

---

<div align="center">
  Made with ❤️ using Flutter
</div>
