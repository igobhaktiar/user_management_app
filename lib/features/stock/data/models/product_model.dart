import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({required super.id, required super.name, required super.category, required super.initialStock, required super.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      initialStock: json['initialStock'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'category': category, 'initialStock': initialStock, 'price': price};
  }
}
