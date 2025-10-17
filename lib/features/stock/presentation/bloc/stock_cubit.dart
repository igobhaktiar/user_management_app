import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/stock_transaction.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/get_monthly_summary.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_transactions.dart';
import 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  final GetProducts getProducts;
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final GetMonthlySummary getMonthlySummary;

  StockCubit({required this.getProducts, required this.getTransactions, required this.addTransaction, required this.getMonthlySummary})
    : super(StockInitial());

  Future<void> loadProducts() async {
    try {
      emit(StockLoading());
      final products = await getProducts();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> loadTransactions({DateTime? month}) async {
    try {
      emit(StockLoading());
      final transactions = await getTransactions(month: month);
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> addNewTransaction(StockTransaction transaction) async {
    try {
      emit(StockLoading());
      await addTransaction(transaction);
      emit(TransactionAdded());
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> loadMonthlySummary(DateTime month) async {
    try {
      emit(StockLoading());
      final summaries = await getMonthlySummary(month);
      emit(MonthlySummaryLoaded(summaries, month));
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }
}
