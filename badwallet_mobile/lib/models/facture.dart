class Facture {
  final int id;
  final String reference;
  final String serviceName;
  final String walletCode;
  final double amount;
  final DateTime dueDate;
  final bool paid;
  final DateTime? paymentDate;

  Facture({
    required this.id,
    required this.reference,
    required this.serviceName,
    required this.walletCode,
    required this.amount,
    required this.dueDate,
    required this.paid,
    this.paymentDate,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      id: json['id'],
      reference: json['reference'],
      serviceName: json['serviceName'],
      walletCode: json['walletCode'],
      amount: (json['amount'] as num).toDouble(),
      dueDate: DateTime.parse(json['dueDate']),
      paid: json['paid'],
      paymentDate: json['paymentDate'] != null ? DateTime.parse(json['paymentDate']) : null,
    );
  }
}