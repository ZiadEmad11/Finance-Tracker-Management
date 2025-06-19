import 'package:flutter/material.dart';
import 'package:moneywise/app_theme.dart';
import 'package:moneywise/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final iconColor = isIncome
        ? Colors.greenAccent[400]
        : Colors.redAccent[400];
    final amountText = '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor?.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
          color: iconColor,
        ),
      ),
      title: Text(
        transaction.description,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        '${transaction.category} • ${DateFormat.MMMd().format(transaction.date)}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[400],
        ),
      ),
      trailing: Text(
        amountText,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isIncome ? Colors.greenAccent[400] : Colors.redAccent[400],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}