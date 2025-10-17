import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import '../models/stock_transaction_model.dart';

class StockLocalDatasource {
  List<ProductModel> _products = [];
  List<StockTransactionModel> _transactions = [];
  bool _isInitialized = false;

  // Load data from JSON files
  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      // Load products from JSON
      final productsJson = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> productsData = json.decode(productsJson);
      _products = productsData.map((json) => ProductModel.fromJson(json)).toList();

      // Load transactions from JSON
      final transactionsJson = await rootBundle.loadString('assets/data/transactions.json');
      final List<dynamic> transactionsData = json.decode(transactionsJson);
      _transactions = transactionsData.map((json) => StockTransactionModel.fromJson(json)).toList();

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<List<ProductModel>> getProducts() async {
    await _initialize();
    await Future.delayed(const Duration(milliseconds: 500));
    return _products;
  }

  Future<List<StockTransactionModel>> getTransactions({DateTime? month}) async {
    await _initialize();
    await Future.delayed(const Duration(milliseconds: 500));

    if (month != null) {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      return _transactions.where((transaction) {
        return transaction.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
            transaction.date.isBefore(endOfMonth.add(const Duration(days: 1)));
      }).toList();
    }

    return _transactions;
  }

  Future<void> addTransaction(StockTransactionModel transaction) async {
    await _initialize();
    await Future.delayed(const Duration(milliseconds: 500));
    _transactions.add(transaction);
  }

  Future<ProductModel?> getProductById(String id) async {
    await _initialize();
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getMonthlySummary(DateTime month) async {
    await _initialize();
    await Future.delayed(const Duration(milliseconds: 500));

    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    final monthTransactions = _transactions.where((transaction) {
      return transaction.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          transaction.date.isBefore(endOfMonth.add(const Duration(days: 1)));
    }).toList();

    Map<String, Map<String, dynamic>> summaryByProduct = {};

    for (var product in _products) {
      summaryByProduct[product.id] = {
        'productId': product.id,
        'productName': product.name,
        'initialStock': product.initialStock,
        'totalPurchase': 0,
        'totalSale': 0,
        'currentStock': product.initialStock,
      };
    }

    for (var transaction in monthTransactions) {
      if (summaryByProduct.containsKey(transaction.productId)) {
        if (transaction.type == 'purchase') {
          summaryByProduct[transaction.productId]!['totalPurchase'] += transaction.quantity;
          summaryByProduct[transaction.productId]!['currentStock'] += transaction.quantity;
        } else if (transaction.type == 'sale') {
          summaryByProduct[transaction.productId]!['totalSale'] += transaction.quantity;
          summaryByProduct[transaction.productId]!['currentStock'] -= transaction.quantity;
        }
      }
    }

    return {'month': month.toIso8601String(), 'summaries': summaryByProduct.values.toList()};
  }
}
