import 'package:uuid/uuid.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String category;
  final String type; // 'income' or 'expense'
  final String? note;
  final int date; // unix timestamp (millisecondsSinceEpoch)
  final int createdAt;

  TransactionModel({
    String? id,
    required this.amount,
    required this.category,
    required this.type,
    this.note,
    required this.date,
    int? createdAt,
  })  : id = id ?? Uuid().v4(),
    // Uuid() is not const constructible — generate id when not provided
        createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'type': type,
      'note': note,
      'date': date,
      'created_at': createdAt,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> m) {
    return TransactionModel(
      id: m['id'] as String,
      amount: (m['amount'] as num).toDouble(),
      category: m['category'] as String,
      type: m['type'] as String,
      note: m['note'] as String?,
      date: m['date'] as int,
      createdAt: m['created_at'] as int,
    );
  }
}
