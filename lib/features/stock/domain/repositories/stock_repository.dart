import '../entities/product.dart';
import '../entities/stock_transaction.dart';
import '../entities/stock_summary.dart';

abstract class StockRepository {
  Future<List<Product>> getProducts();
  Future<List<StockTransaction>> getTransactions({DateTime? month});
  Future<void> addTransaction(StockTransaction transaction);
  Future<Product?> getProductById(String id);
  Future<List<StockSummary>> getMonthlySummary(DateTime month);
}
