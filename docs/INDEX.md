# 📚 Documentation Index

Welcome to the Eratani project documentation! This index will help you find the information you need.

## 📖 Main Documentation

### 🏠 [README.md](../README.md)

**Start here!** Complete project overview including:

- Features overview
- Screenshots
- Installation guide
- Tech stack
- Architecture
- Platform support

### 📋 [CHANGELOG.md](../CHANGELOG.md)

Version history and release notes:

- What's new in each version
- Bug fixes
- Breaking changes
- Upcoming features

### 🤝 [CONTRIBUTING.md](../CONTRIBUTING.md)

Guidelines for contributors:

- Code of conduct
- How to report bugs
- Development setup
- Coding standards
- Pull request process
- Testing guidelines

### 🔌 [API_DOCUMENTATION.md](../API_DOCUMENTATION.md)

Technical API reference:

- User Management API
- Stock Management data structure
- Data models
- State management
- Error handling

### 📜 [LICENSE](../LICENSE)

MIT License terms and conditions

## 📸 Screenshots Guide

### 🖼️ [HOW_TO_ADD_SCREENSHOTS.md](../screenshots/HOW_TO_ADD_SCREENSHOTS.md)

Complete guide for adding screenshots:

- How to take screenshots
- Optimization tips
- Required screenshots list
- Adding to GitHub

### 📷 [USING_YOUR_SCREENSHOTS.md](../screenshots/USING_YOUR_SCREENSHOTS.md)

Quick guide for using provided screenshots:

- Your 6 screenshots reference
- Quick setup
- File structure

## 🎯 Quick Links by Role

### 👨‍💻 For Developers

**Getting Started:**

1. Read [README.md](../README.md) - Installation & Setup
2. Check [CONTRIBUTING.md](../CONTRIBUTING.md) - Dev Guidelines
3. Review [API_DOCUMENTATION.md](../API_DOCUMENTATION.md) - Technical Details

**Key Files:**

- `lib/` - Source code
- `test/` - Unit tests
- `assets/data/` - JSON data files

### 🐛 For Bug Reporters

1. Check [CHANGELOG.md](../CHANGELOG.md) - Known issues
2. Read [CONTRIBUTING.md](../CONTRIBUTING.md) - How to report
3. Open an issue on GitHub

### 🎨 For Designers

1. See [README.md](../README.md) - Screenshots
2. Check `lib/*/presentation/pages/` - UI implementation
3. Review Material Design 3 usage

### 📚 For Documentation Writers

1. Read [CONTRIBUTING.md](../CONTRIBUTING.md) - Style guide
2. Update relevant .md files
3. Keep documentation in sync with code

## 📂 Project Structure

```
eratani/
├── 📄 README.md                    # Main documentation
├── 📄 CHANGELOG.md                 # Version history
├── 📄 CONTRIBUTING.md              # Contribution guide
├── 📄 API_DOCUMENTATION.md         # API reference
├── 📄 LICENSE                      # MIT License
├── 📄 pubspec.yaml                 # Flutter dependencies
├── 📁 lib/                         # Source code
│   ├── 📁 core/                    # Core utilities
│   └── 📁 features/                # Feature modules
│       ├── 📁 user/                # User management
│       ├── 📁 stock/               # Stock management
│       └── 📁 heartbeat/           # Heart beat monitor
├── 📁 assets/                      # Assets
│   └── 📁 data/                    # JSON data
│       ├── products.json
│       └── transactions.json
├── 📁 screenshots/                 # Screenshots
│   ├── 📄 HOW_TO_ADD_SCREENSHOTS.md
│   ├── 📄 USING_YOUR_SCREENSHOTS.md
│   └── 📄 .gitkeep
├── 📁 test/                        # Unit tests
├── 📁 android/                     # Android config
├── 📁 ios/                         # iOS config
├── 📁 web/                         # Web config
├── 📁 windows/                     # Windows config
├── 📁 macos/                       # macOS config
└── 📁 linux/                       # Linux config
```

## 🔍 Feature Documentation

### User Management

**Files:**

- `lib/features/user/` - Implementation
- Domain layer: entities, repositories
- Data layer: API integration
- Presentation: UI and state management

**Screens:**

- User List Page
- Register User Page

### Stock Management

**Files:**

- `lib/features/stock/` - Implementation
- Domain layer: business logic
- Data layer: JSON data source
- Presentation: 3 pages (list, summary, transaction)

**Data:**

- `assets/data/products.json` - 10 products
- `assets/data/transactions.json` - 25 transactions

**Screens:**

- Stock List Page
- Monthly Summary Page
- Add Transaction Page

### Heart Beat Monitor

**Files:**

- `lib/features/heartbeat/presentation/pages/heartbeat_page.dart`

**Features:**

- Animated heart icon
- BPM slider (40-200)
- Pulse wave animation
- Heart rate categories

## 🛠️ Development Docs

### Architecture

**Pattern:** Clean Architecture

- **Presentation Layer:** UI, Widgets, State Management (BLoC)
- **Domain Layer:** Entities, Use Cases, Repository Interfaces
- **Data Layer:** Models, Data Sources, Repository Implementations

### State Management

**Library:** flutter_bloc (Cubit)

- UserCubit - User state
- StockCubit - Stock state

### Dependency Injection

**Library:** get_it

- Singleton services
- Factory instances

## 📱 Platform-Specific Docs

### Android

- `android/` - Native Android code
- Min SDK: Check `build.gradle`

### iOS

- `ios/` - Native iOS code
- Min version: Check `Podfile`

### Web

- `web/` - Web-specific files
- PWA support

## 🧪 Testing Documentation

### Test Files

- `test/` - Unit tests
- Widget tests
- Integration tests

### Running Tests

```bash
flutter test                    # All tests
flutter test --coverage         # With coverage
```

## 🚀 Deployment

### Android APK

```bash
flutter build apk --release
```

### iOS IPA

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## 📞 Support & Contact

- **Issues:** [GitHub Issues](https://github.com/igobhaktiar/user_management_app/issues)
- **Discussions:** [GitHub Discussions](https://github.com/igobhaktiar/user_management_app/discussions)
- **Email:** your-email@example.com

## 🔄 Keep Documentation Updated

When making changes:

1. ✅ Update relevant .md files
2. ✅ Update CHANGELOG.md
3. ✅ Add comments in code
4. ✅ Update API_DOCUMENTATION.md if API changes
5. ✅ Add screenshots if UI changes

## 📝 Documentation Standards

- Use clear, concise language
- Include code examples
- Add emojis for better readability
- Keep formatting consistent
- Update table of contents
- Check spelling and grammar

---

**Last Updated:** October 17, 2025  
**Version:** 1.0.0  
**Maintainer:** Igo Bhaktiar

Happy coding! 🚀
