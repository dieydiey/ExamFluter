import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage;
  String? _phoneNumber;

  AuthProvider({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  String? get phoneNumber => _phoneNumber;

  Future<void> loadPhoneNumber() async {
    _phoneNumber = await _storage.read(key: 'phone_number');
    notifyListeners();
  }

  Future<void> setPhoneNumber(String phone) async {
    _phoneNumber = phone;
    await _storage.write(key: 'phone_number', value: phone);
    notifyListeners();
  }

  Future<void> clearPhoneNumber() async {
    _phoneNumber = null;
    await _storage.delete(key: 'phone_number');
    notifyListeners();
  }
}