import 'package:flutter/material.dart';
import '../../features/auth/views/splash_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/dashboard/views/dashboard_screen.dart';
import '../../features/transfers/views/transfer_screen.dart';
import '../../features/bills/views/bills_screen.dart';
import '../../features/history/views/history_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String transfer = '/transfer';
  static const String bills = '/bills';
  static const String history = '/history';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    dashboard: (context) => const DashboardScreen(),
    transfer: (context) => const TransferScreen(),
    bills: (context) => const BillsScreen(),
    history: (context) => const HistoryScreen(),
  };
}