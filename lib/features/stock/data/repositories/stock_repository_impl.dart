import '../../domain/entities/product.dart';
import '../../domain/entities/stock_transaction.dart';
import '../../domain/entities/stock_summary.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/stock_local_datasource.dart';
import '../models/stock_transaction_model.dart';

class StockRepositoryImpl implements StockRepository {
  final StockLocalDatasource localDatasource;

  StockRepositoryImpl({required this.localDatasource});

  @override
  Future<List<Product>> getProducts() async {
    return await localDatasource.getProducts();
  }

  @override
  Future<List<StockTransaction>> getTransactions({DateTime? month}) async {
    return await localDatasource.getTransactions(month: month);
  }

  @override
  Future<void> addTransaction(StockTransaction transaction) async {
    final transactionModel = StockTransactionModel(
      id: transaction.id,
      productId: transaction.productId,
      productName: transaction.productName,
      quantity: transaction.quantity,
      date: transaction.date,
      type: transaction.type,
    );
    await localDatasource.addTransaction(transactionModel);
  }

  @override
  Future<Product?> getProductById(String id) async {
    return await localDatasource.getProductById(id);
  }

  @override
  Future<List<StockSummary>> getMonthlySummary(DateTime month) async {
    final result = await localDatasource.getMonthlySummary(month);
    final summaries = (result['summaries'] as List).map((summary) {
      return StockSummary(
        productId: summary['productId'],
        productName: summary['productName'],
        initialStock: summary['initialStock'],
        totalPurchase: summary['totalPurchase'],
        totalSale: summary['totalSale'],
        currentStock: summary['currentStock'],
        month: month,
      );
    }).toList();

    return summaries;
  }
}
