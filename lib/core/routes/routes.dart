import 'package:flutter/material.dart';
import '../../features/user/presentation/pages/register_user_page.dart';
import '../../features/user/presentation/pages/user_page.dart';
import '../../features/stock/presentation/pages/stock_list_page.dart';
import '../../features/stock/presentation/pages/add_transaction_page.dart';
import '../../features/stock/presentation/pages/monthly_summary_page.dart';
import '../../features/heartbeat/presentation/pages/heartbeat_page.dart';

class Routes {
  static const String home = '/';
  static const String registerUser = '/register-user';
  static const String stockList = '/stock-list';
  static const String addTransaction = '/add-transaction';
  static const String monthlySummary = '/monthly-summary';
  static const String heartbeat = '/heartbeat';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const UserPage(),
      registerUser: (context) => const RegisterUserPage(),
      stockList: (context) => const StockListPage(),
      monthlySummary: (context) => const MonthlySummaryPage(),
      heartbeat: (context) => const HeartbeatPage(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == addTransaction) {
      final product = settings.arguments;
      return MaterialPageRoute(builder: (context) => AddTransactionPage(product: product));
    }
    return null;
  }
}
