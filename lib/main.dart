// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:expense_test_app/bloc/login_cubit/login_cubit.dart';
import 'package:expense_test_app/bloc/theme_cubit/theme_cubit.dart';
import 'package:expense_test_app/bloc/transaction_bloc/transactions_bloc.dart';
import 'package:expense_test_app/config/app_bloc_observer.dart';
import 'package:expense_test_app/presentation/repositories/login_repository.dart';
import 'package:expense_test_app/presentation/repositories/transactions_repository.dart';
import 'package:expense_test_app/presentation/screens/login_screen.dart';
import 'package:expense_test_app/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationService notificationService = NotificationService();
  await notificationService.scheduleDailyReminderNotification();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  Bloc.observer = AppBlocObserver();
  runApp(MyApp(
    notificationService: notificationService,
  ));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;

  const MyApp({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TransactionsRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit(UserRepository())),
          BlocProvider(
            create: (context) => ThemeCubit(),
            child: MyApp(
              notificationService: notificationService,
            ),
          ),
          BlocProvider<TransactionsBloc>(
            create: (context) => TransactionsBloc(
              transactionsRepository: context.read<TransactionsRepository>(),
            )..add(GetTransactions()),
          ),
        ],
        child: const ExpenseTrackerApp(),
      ),
    );
  }
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, Theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: "Poppins",
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                  color: Colors.black,
                  iconTheme: IconThemeData(color: Colors.black))),
          title: 'Expense Tracker',
          home: LoginScreen(),
        );
      },
    );
  }
}
