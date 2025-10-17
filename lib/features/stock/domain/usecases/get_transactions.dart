import '../entities/stock_transaction.dart';
import '../repositories/stock_repository.dart';

class GetTransactions {
  final StockRepository repository;

  GetTransactions({required this.repository});

  Future<List<StockTransaction>> call({DateTime? month}) async {
    return await repository.getTransactions(month: month);
  }
}
