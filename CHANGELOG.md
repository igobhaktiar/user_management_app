# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned Features

- Export monthly summary to PDF/Excel
- Dark mode support
- User profile management
- Stock alerts for low inventory
- Transaction history filtering
- Charts and graphs for stock analytics

## [1.0.0] - 2025-10-17

### 🎉 Initial Release

#### Added - User Management

- User list display with modern card design
- Search functionality by name or email
- User registration form with validation
- Gender and status selection
- Pull to refresh functionality
- Shimmer loading effect
- Integration with ReqRes API
- State management with flutter_bloc

#### Added - Stock Management

- Product inventory tracking system
- 10 pre-configured products with categories
- Stock transaction recording (purchase/sale)
- Monthly summary calculations
- Real-time stock updates
- JSON-based data storage
- Clean Architecture implementation
  - Domain layer (entities, repositories)
  - Data layer (models, datasources, repositories)
  - Presentation layer (pages, widgets, cubits)
- Categories: Electronics, Accessories, Storage, Components

#### Added - Heart Beat Monitor

- Animated heart beat visualization
- Adjustable BPM (40-200 beats per minute)
- Double-thump animation effect
- Pulse wave animations (3 circles)
- Heart rate category display
  - Bradycardia (< 60 BPM)
  - Normal resting (60-100 BPM)
  - Light activity (101-140 BPM)
  - Vigorous activity (141-180 BPM)
  - Maximum rate (> 180 BPM)
- Start/Stop control
- Smooth animation controller
- Real-time BPM adjustment

#### Technical Implementation

- Flutter 3.35.4
- Dart 3.9.2
- Material Design 3
- BLoC pattern for state management
- Dependency injection with get_it
- HTTP client with dio
- Date formatting with intl
- UUID generation for transactions
- Responsive design for all platforms

#### UI/UX Enhancements

- Gradient app bars and backgrounds
- Custom rounded cards with shadows
- Smooth page transitions
- Icon-based navigation
- Color-coded transaction types
- Empty state handling
- Error state handling
- Loading state with shimmer

### Fixed

- Animation controller dispose issue in heart beat monitor
- Navigation state management in stock list
- BPM slider stuck issue
- Multiple dispose calls error

### Documentation

- Comprehensive README.md
- API documentation
- Architecture documentation
- Contributing guidelines
- License (MIT)
- Changelog
- Screenshot guidelines

## Version History

### Version Numbering

- **Major version** (1.x.x): Incompatible API changes
- **Minor version** (x.1.x): New features (backward compatible)
- **Patch version** (x.x.1): Bug fixes

---

[Unreleased]: https://github.com/igobhaktiar/user_management_app/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/igobhaktiar/user_management_app/releases/tag/v1.0.0
