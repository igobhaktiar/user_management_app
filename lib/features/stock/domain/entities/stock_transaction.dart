class StockTransaction {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final DateTime date;
  final String type; // 'purchase' or 'sale'

  StockTransaction({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.date,
    required this.type,
  });
}
