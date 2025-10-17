import '../entities/stock_transaction.dart';
import '../repositories/stock_repository.dart';

class AddTransaction {
  final StockRepository repository;

  AddTransaction({required this.repository});

  Future<void> call(StockTransaction transaction) async {
    await repository.addTransaction(transaction);
  }
}
