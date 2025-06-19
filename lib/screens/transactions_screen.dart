import 'package:flutter/material.dart';
import 'package:moneywise/app_theme.dart';
import 'package:moneywise/models/transaction_model.dart';
import 'package:moneywise/providers/finance_provider.dart';
import 'package:moneywise/widgets/transaction_item.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = "All";
  final List<String> _filterOptions = ["All", "Income", "Expense"];
  String _selectedTimeFrame = "This Month";
  final List<String> _timeFrameOptions = [
    "Today",
    "This Week",
    "This Month",
    "This Year",
    "All Time"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Transactions"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedFilter,
                    items: _filterOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedFilter = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Filter",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedTimeFrame,
                    items: _timeFrameOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedTimeFrame = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Time Frame",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<FinanceProvider>(
              builder: (context, provider, child) {
                List<Transaction> transactions = provider.transactions;

                // Apply filters
                if (_selectedFilter != "All") {
                  transactions = transactions.where((t) =>
                  _selectedFilter == "Income"
                      ? t.type == TransactionType.income
                      : t.type == TransactionType.expense
                  ).toList();
                }

                // Apply time frame filter
                final now = DateTime.now();
                if (_selectedTimeFrame == "Today") {
                  transactions = transactions.where((t) =>
                  t.date.year == now.year &&
                      t.date.month == now.month &&
                      t.date.day == now.day
                  ).toList();
                } else if (_selectedTimeFrame == "This Week") {
                  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
                  transactions = transactions.where((t) =>
                      t.date.isAfter(startOfWeek)
                  ).toList();
                } else if (_selectedTimeFrame == "This Month") {
                  transactions = transactions.where((t) =>
                  t.date.year == now.year &&
                      t.date.month == now.month
                  ).toList();
                } else if (_selectedTimeFrame == "This Year") {
                  transactions = transactions.where((t) =>
                  t.date.year == now.year
                  ).toList();
                }

                // Group by date
                final groupedTransactions = _groupTransactionsByDate(transactions);

                return ListView.builder(
                  itemCount: groupedTransactions.length,
                  itemBuilder: (context, index) {
                    final date = groupedTransactions.keys.elementAt(index);
                    final transactionsForDate = groupedTransactions[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            DateFormat.yMMMd().format(date),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                        ...transactionsForDate.map((transaction) =>
                            TransactionItem(transaction: transaction)
                        ).toList(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<DateTime, List<Transaction>> grouped = {};

    // Sort transactions by date (newest first)
    transactions.sort((a, b) => b.date.compareTo(a.date));

    for (var transaction in transactions) {
      // Create a date without time
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }

    return grouped;
  }
}