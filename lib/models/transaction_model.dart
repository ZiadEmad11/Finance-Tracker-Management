import 'package:flutter/foundation.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionType type;
  final String category;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
    required this.category,
  });

  Transaction copyWith({
    String? id,
    double? amount,
    String? description,
    DateTime? date,
    TransactionType? type,
    String? category,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'type': type.index,
      'category': category,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      type: TransactionType.values[map['type']],
      category: map['category'],
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, description: $description, date: $date, type: $type, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.id == id &&
        other.amount == amount &&
        other.description == description &&
        other.date == date &&
        other.type == type &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    amount.hashCode ^
    description.hashCode ^
    date.hashCode ^
    type.hashCode ^
    category.hashCode;
  }
}