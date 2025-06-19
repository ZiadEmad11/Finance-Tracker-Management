import 'package:flutter/foundation.dart';

class Budget {
  final String id;
  final String category;
  final double amount;
  final String period;
  final double spent;

  Budget({
    required this.id,
    required this.category,
    required this.amount,
    required this.period,
    required this.spent,
  });

  double get remaining => amount - spent;
  double get progress => spent / amount;

  Budget copyWith({
    String? id,
    String? category,
    double? amount,
    String? period,
    double? spent,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      spent: spent ?? this.spent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'period': period,
      'spent': spent,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      category: map['category'],
      amount: map['amount'],
      period: map['period'],
      spent: map['spent'],
    );
  }

  @override
  String toString() {
    return 'Budget(id: $id, category: $category, amount: $amount, period: $period, spent: $spent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Budget &&
        other.id == id &&
        other.category == category &&
        other.amount == amount &&
        other.period == period &&
        other.spent == spent;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    category.hashCode ^
    amount.hashCode ^
    period.hashCode ^
    spent.hashCode;
  }
}