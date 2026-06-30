import 'package:dio/dio.dart';
import 'api_service.dart';
import '../../models/wallet.dart';
import '../../models/transaction.dart';

class WalletService {
  final Dio _dio = ApiService().dio;

  Future<Wallet> getWalletByPhone(String phone) async {
    try {
      final response = await _dio.get('/api/wallets/$phone');
      return Wallet.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de la récupération du wallet');
    }
  }

  Future<double> getBalance(String phone) async {
    try {
      final response = await _dio.get('/api/wallets/$phone/balance');
      return (response.data as num).toDouble();
    } catch (e) {
      throw Exception('Erreur lors de la récupération du solde');
    }
  }

  Future<List<Transaction>> getTransactions(String phone) async {
    try {
      final response = await _dio.get('/api/wallets/$phone/transactions');
      final List<dynamic> data = response.data;
      return data.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des transactions');
    }
  }

  Future<void> transfer(String senderPhone, String receiverPhone, double amount) async {
    try {
      await _dio.post('/api/wallets/transfer', data: {
        'senderPhone': senderPhone,
        'receiverPhone': receiverPhone,
        'amount': amount,
      });
    } catch (e) {
      throw Exception('Erreur lors du transfert');
    }
  }

  Future<void> deposit(int walletId, double amount, String paymentMethod) async {
    try {
      await _dio.post('/api/wallets/$walletId/deposit', data: {
        'amount': amount,
        'paymentMethod': paymentMethod,
      });
    } catch (e) {
      throw Exception('Erreur lors du dépôt');
    }
  }

  Future<void> withdraw(String phone, double amount) async {
    try {
      await _dio.post('/api/wallets/withdraw', data: {
        'phoneNumber': phone,
        'amount': amount,
      });
    } catch (e) {
      throw Exception('Erreur lors du retrait');
    }
  }
}