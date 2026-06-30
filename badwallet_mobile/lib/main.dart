import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/transfers/providers/transfer_provider.dart';
import 'features/bills/providers/bills_provider.dart';
import 'features/dashboard/providers/dashboard_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FlutterSecureStorage>(create: (_) => const FlutterSecureStorage()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, DashboardProvider>(
          create: (_) => DashboardProvider(),
          update: (_, auth, dashboard) => dashboard!..setPhoneNumber(auth.phoneNumber ?? ''),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TransferProvider>(
          create: (_) => TransferProvider(),
          update: (_, auth, transfer) => transfer!..setPhoneNumber(auth.phoneNumber ?? ''),
        ),
        ChangeNotifierProxyProvider<AuthProvider, BillsProvider>(
          create: (_) => BillsProvider(),
          update: (_, auth, bills) => bills!..setPhoneNumber(auth.phoneNumber ?? ''),
        ),
      ],
      child: MaterialApp(
        title: 'BadWallet',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}