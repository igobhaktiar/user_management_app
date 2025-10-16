import 'package:flutter/material.dart';
import '../../features/user/presentation/pages/register_user_page.dart';
import '../../features/user/presentation/pages/user_page.dart';

class Routes {
  static const String home = '/';
  static const String registerUser = '/register-user';

  static Map<String, WidgetBuilder> getRoutes() {
    return {home: (context) => const UserPage(), registerUser: (context) => const RegisterUserPage()};
  }
}
