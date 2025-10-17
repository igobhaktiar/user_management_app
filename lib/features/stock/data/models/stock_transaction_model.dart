import '../../domain/entities/stock_transaction.dart';

class StockTransactionModel extends StockTransaction {
  StockTransactionModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.date,
    required super.type,
  });

  factory StockTransactionModel.fromJson(Map<String, dynamic> json) {
    return StockTransactionModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      date: DateTime.parse(json['date']),
      type: json['type'] ?? 'sale',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'productId': productId, 'productName': productName, 'quantity': quantity, 'date': date.toIso8601String(), 'type': type};
  }
}
