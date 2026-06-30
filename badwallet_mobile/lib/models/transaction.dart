class Transaction {
  final int id;
  final String type;
  final double amount;
  final double fees;
  final String description;
  final DateTime date;
  final String? receiverPhone;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.fees,
    required this.description,
    required this.date,
    this.receiverPhone,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      fees: (json['fees'] as num).toDouble(),
      description: json['description'] ?? '',
      date: DateTime.parse(json['date']),
      receiverPhone: json['receiverPhone'],
    );
  }
}