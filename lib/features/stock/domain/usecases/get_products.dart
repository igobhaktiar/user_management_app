import '../entities/product.dart';
import '../repositories/stock_repository.dart';

class GetProducts {
  final StockRepository repository;

  GetProducts({required this.repository});

  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}
