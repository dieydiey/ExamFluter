import 'package:dio/dio.dart';
import 'api_service.dart';
import '../../models/facture.dart';

class BillsService {
  final Dio _dio = ApiService().dio;

  Future<List<Facture>> getCurrentUnpaid(String walletCode, {String? unite}) async {
    try {
      String url = '/api/external/factures/$walletCode/current';
      if (unite != null && unite.isNotEmpty) {
        url += '?unite=$unite';
      }
      final response = await _dio.get(url);
      final List<dynamic> data = response.data;
      return data.map((json) => Facture.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des factures');
    }
  }

  Future<void> payFactures(String phone, String serviceName, List<String> references) async {
    try {
      await _dio.post('/api/wallets/pay-factures', data: {
        'phoneNumber': phone,
        'serviceName': serviceName,
        'factureReferences': references,
      });
    } catch (e) {
      throw Exception('Erreur lors du paiement des factures');
    }
  }
}