import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routes/routes.dart';
import 'features/user/presentation/bloc/user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<UserCubit>()..getUsers(),
      child: MaterialApp(
        title: 'User Management App',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: Routes.home,
        routes: Routes.getRoutes(),
      ),
    );
  }
}
