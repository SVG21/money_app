enum TransactionType { payment, topup }

class Transaction {
  final TransactionType type;
  final String name;
  final double amount;
  final DateTime date;

  Transaction({
    required this.type,
    required this.name,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: TransactionType.values
          .firstWhere((e) => e.toString() == 'TransactionType.${json['type']}'),
      name: json['name'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }
}
