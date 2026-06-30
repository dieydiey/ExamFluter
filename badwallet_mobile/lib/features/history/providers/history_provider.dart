import 'package:flutter/material.dart';
import '../../../core/services/wallet_service.dart';
import '../../../models/transaction.dart';

class HistoryProvider extends ChangeNotifier {
  final WalletService _walletService = WalletService();
  String? _phoneNumber;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    if (_phoneNumber == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final txList = await _walletService.getTransactions(_phoneNumber!);
      _transactions = txList;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}