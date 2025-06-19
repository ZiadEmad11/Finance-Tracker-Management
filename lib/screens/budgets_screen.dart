import 'package:flutter/material.dart';
import 'package:moneywise/app_theme.dart';
import 'package:moneywise/models/budget_model.dart';
import 'package:moneywise/providers/finance_provider.dart';
import 'package:moneywise/widgets/budget_item.dart';
import 'package:provider/provider.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({Key? key}) : super(key: key);

  @override
  _BudgetsScreenState createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final List<String> _timePeriods = ["Weekly", "Monthly", "Yearly"];
  String _selectedTimePeriod = "Monthly";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Budgets"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddBudgetDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _selectedTimePeriod,
              items: _timePeriods.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedTimePeriod = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: "Time Period",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<FinanceProvider>(
              builder: (context, provider, child) {
                if (provider.budgets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 60,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No budgets yet",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tap the + button to add a budget",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.budgets.length,
                  itemBuilder: (context, index) {
                    final budget = provider.budgets[index];
                    return BudgetItem(
                      budget: budget,
                      onDelete: () => provider.deleteBudget(budget.id),
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

  void _showAddBudgetDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _categoryController = TextEditingController();
    final _amountController = TextEditingController();
    String _selectedPeriod = "Monthly";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkTheme.cardColor,
          title: const Text("Add New Budget"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    prefixText: "\$ ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedPeriod,
                  items: _timePeriods.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    _selectedPeriod = newValue!;
                  },
                  decoration: InputDecoration(
                    labelText: "Time Period",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final budget = Budget(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    category: _categoryController.text,
                    amount: double.parse(_amountController.text),
                    period: _selectedPeriod,
                    spent: 0.0, // Initialize with 0 spent
                  );

                  Provider.of<FinanceProvider>(context, listen: false)
                      .addBudget(budget);

                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}