import 'package:flutter/material.dart';
import 'package:moneywise/app_theme.dart';
import 'package:moneywise/models/transaction_model.dart';
import 'package:moneywise/widgets/transaction_item.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // In a real app, these would come from a provider
    final List<Transaction> recentTransactions = [
      Transaction(
        id: '1',
        amount: 45.67,
        description: 'Grocery shopping',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.expense,
        category: 'Food',
      ),
      Transaction(
        id: '2',
        amount: 120.00,
        description: 'Monthly subscription',
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.expense,
        category: 'Bills',
      ),
      Transaction(
        id: '3',
        amount: 2500.00,
        description: 'Freelance work',
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.income,
        category: 'Salary',
      ),
      Transaction(
        id: '4',
        amount: 15.99,
        description: 'Coffee with friends',
        date: DateTime.now().subtract(const Duration(days: 4)),
        type: TransactionType.expense,
        category: 'Food',
      ),
      Transaction(
        id: '5',
        amount: 45.00,
        description: 'Taxi ride',
        date: DateTime.now().subtract(const Duration(days: 5)),
        type: TransactionType.expense,
        category: 'Transport',
      ),
    ];

    return Card(
      color: AppTheme.darkTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Transactions",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("View All"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...recentTransactions.take(3).map((transaction) =>
                Column(
                  children: [
                    TransactionItem(transaction: transaction),
                    if (recentTransactions.indexOf(transaction) < 2)
                      const Divider(height: 16, indent: 50),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}