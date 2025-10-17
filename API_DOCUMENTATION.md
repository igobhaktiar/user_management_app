# 🔌 API Documentation

This document describes the API endpoints and data structures used in the Eratani application.

## 📡 User Management API

### Base URL

```
https://reqres.in/api
```

### Endpoints

#### 1. Get Users

Retrieve paginated list of users.

**Request:**

```http
GET /users?page={page}
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| page | integer | No | Page number (default: 1) |

**Response: 200 OK**

```json
{
  "page": 1,
  "per_page": 6,
  "total": 12,
  "total_pages": 2,
  "data": [
    {
      "id": 1,
      "email": "george.bluth@reqres.in",
      "first_name": "George",
      "last_name": "Bluth",
      "avatar": "https://reqres.in/img/faces/1-image.jpg"
    }
  ]
}
```

#### 2. Create User

Create a new user.

**Request:**

```http
POST /users
Content-Type: application/json

{
  "name": "John Doe",
  "job": "Developer"
}
```

**Response: 201 Created**

```json
{
  "name": "John Doe",
  "job": "Developer",
  "id": "123",
  "createdAt": "2025-10-17T10:00:00.000Z"
}
```

## 📦 Stock Management (Local Storage)

Stock management uses JSON files stored in `assets/data/` for demo purposes.

### Data Sources

#### Products Data

**File:** `assets/data/products.json`

**Structure:**

```json
[
  {
    "id": "1",
    "name": "Laptop Dell XPS 15",
    "category": "Electronics",
    "initialStock": 50,
    "price": 15000000
  }
]
```

**Fields:**
| Field | Type | Description |
|-------|------|-------------|
| id | string | Unique product identifier |
| name | string | Product name |
| category | string | Product category |
| initialStock | integer | Starting stock quantity |
| price | integer | Product price in IDR |

#### Transactions Data

**File:** `assets/data/transactions.json`

**Structure:**

```json
[
  {
    "id": "uuid-here",
    "productId": "1",
    "productName": "Laptop Dell XPS 15",
    "quantity": 25,
    "date": "2025-10-01T08:00:00Z",
    "type": "purchase"
  }
]
```

**Fields:**
| Field | Type | Description |
|-------|------|-------------|
| id | string (UUID) | Unique transaction ID |
| productId | string | Reference to product ID |
| productName | string | Product name (denormalized) |
| quantity | integer | Transaction quantity |
| date | string (ISO 8601) | Transaction timestamp |
| type | enum | "purchase" or "sale" |

### Business Logic

#### Stock Calculation

```dart
Current Stock = Initial Stock + Total Purchases - Total Sales
```

**Example:**

```
Initial Stock: 50
Purchases: 25
Sales: 12
Current Stock: 50 + 25 - 12 = 63
```

#### Monthly Summary Calculation

```dart
class MonthlySummary {
  int totalInitialStock;    // Sum of all initialStock
  int totalPurchases;       // Sum of purchase transactions
  int totalSales;          // Sum of sale transactions
  int totalCurrentStock;   // Sum of all current stocks

  List<ProductSummary> products; // Per-product breakdown
}

class ProductSummary {
  String productName;
  int initialStock;
  int purchases;      // This month's purchases
  int sales;         // This month's sales
  int currentStock;  // initialStock + purchases - sales
}
```

## 🔐 Authentication

Currently, the app does not implement authentication. All API calls are public.

**Future Enhancement:**

```dart
// Planned authentication structure
class AuthToken {
  String accessToken;
  String refreshToken;
  DateTime expiresAt;
}

// API headers with auth
headers: {
  'Authorization': 'Bearer ${token.accessToken}',
  'Content-Type': 'application/json',
}
```

## 📊 Data Models

### User Model

```dart
class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }
}
```

### Product Model

```dart
class Product {
  final String id;
  final String name;
  final String category;
  final int initialStock;
  final int price;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.initialStock,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      initialStock: json['initialStock'] as int,
      price: json['price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'initialStock': initialStock,
      'price': price,
    };
  }
}
```

### Transaction Model

```dart
class StockTransaction {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final DateTime date;
  final String type; // 'purchase' or 'sale'

  const StockTransaction({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.date,
    required this.type,
  });

  factory StockTransaction.fromJson(Map<String, dynamic> json) {
    return StockTransaction(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'date': date.toIso8601String(),
      'type': type,
    };
  }
}
```

## 🔄 State Management

### User States

```dart
abstract class UserState extends Equatable {}

class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final List<User> users;
  UserLoaded(this.users);
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
}
```

### Stock States

```dart
abstract class StockState extends Equatable {}

class StockInitial extends StockState {}
class ProductsLoading extends StockState {}
class ProductsLoaded extends StockState {
  final List<Product> products;
  final Map<String, int> currentStocks;
  ProductsLoaded(this.products, this.currentStocks);
}
class MonthlySummaryLoaded extends StockState {
  final StockSummary summary;
  MonthlySummaryLoaded(this.summary);
}
class StockError extends StockState {
  final String message;
  StockError(this.message);
}
```

## 🧪 Testing

### Mock API Responses

**User List Mock:**

```dart
final mockUsers = [
  User(
    id: 1,
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
    avatar: 'https://example.com/avatar.jpg',
  ),
];
```

**Product Mock:**

```dart
final mockProduct = Product(
  id: '1',
  name: 'Test Product',
  category: 'Electronics',
  initialStock: 100,
  price: 5000000,
);
```

## 🚀 Future API Enhancements

### Planned Features

1. **Real Backend Integration**

   - Replace JSON files with REST API
   - Add authentication/authorization
   - Implement CRUD operations

2. **WebSocket for Real-time Updates**

   ```dart
   // Real-time stock updates
   ws://api.eratani.com/ws/stock
   ```

3. **Pagination**

   ```http
   GET /products?page=1&limit=20
   ```

4. **Filtering & Sorting**

   ```http
   GET /products?category=Electronics&sort=name&order=asc
   ```

5. **Search**
   ```http
   GET /products/search?q=laptop
   ```

## 📝 Error Handling

### HTTP Status Codes

| Code | Meaning      | Handling               |
| ---- | ------------ | ---------------------- |
| 200  | OK           | Success                |
| 201  | Created      | Success                |
| 400  | Bad Request  | Show error message     |
| 401  | Unauthorized | Redirect to login      |
| 404  | Not Found    | Show not found message |
| 500  | Server Error | Show retry option      |

### Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": {
      "field": "email",
      "reason": "Email format is invalid"
    }
  }
}
```

---

For questions about the API, please open an issue on GitHub.
