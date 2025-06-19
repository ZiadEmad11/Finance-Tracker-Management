import 'package:flutter/material.dart';
import 'package:moneywise/models/budget_model.dart';
import 'package:moneywise/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinanceProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Budget> _budgets = [];

  List<Transaction> get transactions => _transactions;
  List<Budget> get budgets => _budgets;

  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get balance {
    return totalIncome - totalExpense;
  }

  FinanceProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsData = prefs.getStringList('transactions');
    final budgetsData = prefs.getStringList('budgets');

    if (transactionsData != null) {
      _transactions = transactionsData
          .map((json) => Transaction.fromMap(json as Map<String, dynamic>))
          .toList();
    }

    if (budgetsData != null) {
      _budgets = budgetsData
          .map((json) => Budget.fromMap(json as Map<String, dynamic>))
          .toList();
    }

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'transactions',
      _transactions.map((t) => t.toMap().toString()).toList(),
    );
    await prefs.setStringList(
      'budgets',
      _budgets.map((b) => b.toMap().toString()).toList(),
    );
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _updateBudgetsWithTransaction(transaction);
    _saveData();
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    _saveData();
    notifyListeners();
  }

  void addBudget(Budget budget) {
    _budgets.add(budget);
    _saveData();
    notifyListeners();
  }

  void deleteBudget(String id) {
    _budgets.removeWhere((b) => b.id == id);
    _saveData();
    notifyListeners();
  }

  void _updateBudgetsWithTransaction(Transaction transaction) {
    if (transaction.type == TransactionType.expense) {
      for (var budget in _budgets) {
        if (budget.category == transaction.category) {
          final updatedBudget = budget.copyWith(spent: budget.spent + transaction.amount);
          _budgets[_budgets.indexOf(budget)] = updatedBudget;
        }
      }
      _saveData();
      notifyListeners();
    }
  }

  // For demo purposes - generates sample data
  void generateSampleData() {
    final now = DateTime.now();
    final categories = ['Food', 'Transport', 'Shopping', 'Entertainment', 'Bills'];

    // Add sample transactions
    _transactions = List.generate(30, (index) {
      final isIncome = index % 5 == 0;
      final daysAgo = index;
      final amount = isIncome
          ? (1000 + index * 100).toDouble()
          : (10 + index % 20).toDouble();

      return Transaction(
        id: 'sample_$index',
        amount: amount,
        description: isIncome ? 'Salary' : 'Purchase ${index + 1}',
        date: now.subtract(Duration(days: daysAgo)),
        type: isIncome ? TransactionType.income : TransactionType.expense,
        category: isIncome ? 'Salary' : categories[index % categories.length],
      );
    });

    // Add sample budgets
    _budgets = categories.map((category) {
      return Budget(
        id: 'budget_$category',
        category: category,
        amount: 200.0,
        period: 'Monthly',
        spent: _transactions
            .where((t) => t.type == TransactionType.expense && t.category == category)
            .fold(0.0, (sum, t) => sum + t.amount),
      );
    }).toList();

    _saveData();
    notifyListeners();
  }
}