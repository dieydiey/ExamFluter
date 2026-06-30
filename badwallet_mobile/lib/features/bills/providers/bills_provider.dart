import 'package:flutter/material.dart';
import '../../../core/services/bills_service.dart';
import '../../../core/services/wallet_service.dart';
import '../../../models/facture.dart';

class BillsProvider extends ChangeNotifier {
  final BillsService _billsService = BillsService();
  final WalletService _walletService = WalletService();
  String? _phoneNumber;
  String? _walletCode;
  List<Facture> _factures = [];
  List<String> _selectedReferences = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedService;

  List<Facture> get factures => _factures;
  List<String> get selectedReferences => _selectedReferences;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedService => _selectedService;

  final List<String> services = ['ISM', 'WOYAFAL', 'RAPIDO', 'SENELEC'];

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    _fetchWalletCode();
  }

  Future<void> _fetchWalletCode() async {
    if (_phoneNumber == null) return;
    try {
      final wallet = await _walletService.getWalletByPhone(_phoneNumber!);
      _walletCode = wallet.code;
    } catch (e) {
      _error = 'Impossible de récupérer le code du wallet';
      notifyListeners();
    }
  }

  void selectService(String service) {
    _selectedService = service;
    _selectedReferences.clear();
    fetchFactures();
  }

  Future<void> fetchFactures() async {
    if (_walletCode == null || _selectedService == null) return;
    _isLoading = true;
    _error = null;
    _factures = [];
    notifyListeners();

    try {
      final factures = await _billsService.getCurrentUnpaid(_walletCode!, unite: _selectedService);
      _factures = factures;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleSelection(Facture facture) {
    if (_selectedReferences.contains(facture.reference)) {
      _selectedReferences.remove(facture.reference);
    } else {
      _selectedReferences.add(facture.reference);
    }
    notifyListeners();
  }

  Future<void> paySelected() async {
    if (_phoneNumber == null || _selectedService == null || _selectedReferences.isEmpty) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _billsService.payFactures(_phoneNumber!, _selectedService!, _selectedReferences);
      _selectedReferences.clear();
      await fetchFactures(); // refresh
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}