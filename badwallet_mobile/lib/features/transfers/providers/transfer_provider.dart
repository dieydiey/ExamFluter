import 'package:flutter/material.dart';
import '../../../core/services/wallet_service.dart';

class TransferProvider extends ChangeNotifier {
  final WalletService _walletService = WalletService();
  String? _phoneNumber;
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _error;
  bool _success = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get success => _success;

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
  }

  Future<void> transfer() async {
    if (!formKey.currentState!.validate()) return;
    if (_phoneNumber == null) {
      _error = 'Numéro non défini';
      notifyListeners();
      return;
    }
    _isLoading = true;
    _error = null;
    _success = false;
    notifyListeners();

    try {
      final destination = destinationController.text;
      final amount = double.parse(amountController.text);
      await _walletService.transfer(_phoneNumber!, destination, amount);
      _success = true;
      destinationController.clear();
      amountController.clear();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}