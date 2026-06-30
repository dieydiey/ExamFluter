import 'package:flutter/material.dart';
import '../../../core/services/wallet_service.dart';
import '../../../models/transaction.dart';

class DashboardProvider extends ChangeNotifier {
  final WalletService _walletService = WalletService();
  String? _phoneNumber;
  double? _balance;
  List<Transaction> _recentTransactions = [];
  bool _isLoading = false;
  String? _error;

  double? get balance => _balance;
  List<Transaction> get recentTransactions => _recentTransactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    if (_phoneNumber == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final balance = await _walletService.getBalance(_phoneNumber!);
      final transactions = await _walletService.getTransactions(_phoneNumber!);
      _balance = balance;
      _recentTransactions = transactions.take(5).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }
}