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

  // Convert a Transaction to a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'type':
          type.toString().split('.').last, // Store as String (e.g., "payment")
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  // Convert a JSON Map to a Transaction object
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
