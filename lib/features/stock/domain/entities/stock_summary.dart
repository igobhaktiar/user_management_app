class StockSummary {
  final String productId;
  final String productName;
  final int initialStock;
  final int totalPurchase;
  final int totalSale;
  final int currentStock;
  final DateTime month;

  StockSummary({
    required this.productId,
    required this.productName,
    required this.initialStock,
    required this.totalPurchase,
    required this.totalSale,
    required this.currentStock,
    required this.month,
  });
}
