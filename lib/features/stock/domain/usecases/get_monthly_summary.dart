import '../entities/stock_summary.dart';
import '../repositories/stock_repository.dart';

class GetMonthlySummary {
  final StockRepository repository;

  GetMonthlySummary({required this.repository});

  Future<List<StockSummary>> call(DateTime month) async {
    return await repository.getMonthlySummary(month);
  }
}
