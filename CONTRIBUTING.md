# Contributing to Eratani

First off, thank you for considering contributing to Eratani! 🎉

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Guidelines](#coding-guidelines)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)

## 📜 Code of Conduct

This project and everyone participating in it is governed by respect and professionalism. Please be kind and courteous to others.

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear title and description**
- **Steps to reproduce** the behavior
- **Expected behavior**
- **Screenshots** if applicable
- **Environment details** (Flutter version, device, OS)

**Example:**

```
**Bug:** App crashes when adding transaction

**Steps to Reproduce:**
1. Open Stock Management
2. Click on any product
3. Enter quantity: 999999
4. Click Add Transaction
5. App crashes

**Expected:** Should show error message for quantity limit

**Environment:**
- Flutter: 3.35.4
- Device: Android 14, Pixel 8
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. Include:

- **Clear title**
- **Detailed description** of the enhancement
- **Why this would be useful**
- **Possible implementation** approach

### Pull Requests

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 🛠️ Development Setup

### Prerequisites

```bash
# Check Flutter installation
flutter doctor

# Required versions:
# Flutter: 3.35.4+
# Dart: 3.9.2+
```

### Setup Steps

```bash
# 1. Fork and clone
git clone https://github.com/YOUR-USERNAME/user_management_app.git
cd eratani

# 2. Install dependencies
flutter pub get

# 3. Run code generation (if needed)
flutter pub run build_runner build

# 4. Run the app
flutter run

# 5. Run tests
flutter test
```

## 📝 Coding Guidelines

### Dart Style Guide

Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide.

```bash
# Format code
flutter format .

# Analyze code
flutter analyze
```

### Project Structure

Follow the existing Clean Architecture structure:

```
lib/
├── core/              # Core utilities, routes, constants
├── features/          # Feature modules
│   └── feature_name/
│       ├── data/      # Data layer (API, models, repositories)
│       ├── domain/    # Business logic (entities, use cases)
│       └── presentation/  # UI layer (pages, widgets, state)
```

### Code Style

```dart
// ✅ Good
class UserRepository {
  final UserRemoteDataSource remoteDataSource;

  const UserRepository({required this.remoteDataSource});

  Future<List<User>> getUsers() async {
    try {
      return await remoteDataSource.fetchUsers();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}

// ❌ Bad
class userrepo {
  var dataSource;
  userrepo(this.dataSource);
  getUsers() => dataSource.fetch();
}
```

### Widget Guidelines

```dart
// ✅ Use const constructors where possible
const Text('Hello')

// ✅ Extract complex widgets
Widget _buildUserCard(User user) { ... }

// ✅ Use meaningful names
final TextEditingController nameController;

// ❌ Avoid
var controller;
Widget w() { ... }
```

### State Management

Use **flutter_bloc (Cubit)** for state management:

```dart
// State class
abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

// Cubit class
class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super(UserInitial());

  Future<void> loadUsers() async {
    emit(UserLoading());
    try {
      final users = await repository.getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
```

## 📦 Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting)
- **refactor**: Code refactoring
- **test**: Adding tests
- **chore**: Maintenance tasks

### Examples

```bash
feat(stock): add monthly summary page

- Add monthly summary calculations
- Display total purchases and sales
- Show current stock for all products

Closes #123
```

```bash
fix(heartbeat): resolve animation controller dispose issue

The animation controller was being disposed multiple times
when adjusting BPM quickly. Added flag to track disposal state.

Fixes #456
```

## 🔄 Pull Request Process

### Before Submitting

1. **Update documentation** if needed
2. **Add tests** for new features
3. **Run all tests** and ensure they pass
4. **Format code**: `flutter format .`
5. **Analyze code**: `flutter analyze`
6. **Update README.md** if adding features

### PR Template

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing

- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)

Add screenshots here

## Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests pass locally
```

### Review Process

1. **Automated checks** must pass (if configured)
2. **Code review** by maintainer
3. **Requested changes** must be addressed
4. **Approval** required before merge

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/user/user_cubit_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Tests

```dart
// Unit test example
void main() {
  group('UserCubit', () {
    late UserCubit cubit;
    late MockUserRepository repository;

    setUp(() {
      repository = MockUserRepository();
      cubit = UserCubit(repository: repository);
    });

    test('initial state is UserInitial', () {
      expect(cubit.state, isA<UserInitial>());
    });

    blocTest<UserCubit, UserState>(
      'emits [UserLoading, UserLoaded] when loadUsers succeeds',
      build: () {
        when(() => repository.getUsers())
            .thenAnswer((_) async => [mockUser]);
        return cubit;
      },
      act: (cubit) => cubit.loadUsers(),
      expect: () => [
        isA<UserLoading>(),
        isA<UserLoaded>(),
      ],
    );
  });
}
```

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Clean Architecture in Flutter](https://github.com/ResoCoder/flutter-tdd-clean-architecture-course)
- [BLoC Pattern](https://bloclibrary.dev/)

## ❓ Questions?

Feel free to open an issue for any questions or clarifications needed.

---

Thank you for contributing! 🙌
