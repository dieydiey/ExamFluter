class Wallet {
  final int id;
  final String phoneNumber;
  final String email;
  final double balance;
  final String code;
  final String currency;

  Wallet({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.balance,
    required this.code,
    required this.currency,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      balance: (json['balance'] as num).toDouble(),
      code: json['code'],
      currency: json['currency'] ?? 'XOF',
    );
  }
}