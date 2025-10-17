import '../../domain/entities/product.dart';
import '../../domain/entities/stock_transaction.dart';
import '../../domain/entities/stock_summary.dart';

abstract class StockState {}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class ProductsLoaded extends StockState {
  final List<Product> products;

  ProductsLoaded(this.products);
}

class TransactionsLoaded extends StockState {
  final List<StockTransaction> transactions;

  TransactionsLoaded(this.transactions);
}

class MonthlySummaryLoaded extends StockState {
  final List<StockSummary> summaries;
  final DateTime month;

  MonthlySummaryLoaded(this.summaries, this.month);
}

class TransactionAdded extends StockState {}

class StockError extends StockState {
  final String message;

  StockError(this.message);
}
