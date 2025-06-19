import 'package:flutter/material.dart';
import 'package:moneywise/app_theme.dart';
import 'package:moneywise/models/budget_model.dart';

class BudgetItem extends StatelessWidget {
  final Budget budget;
  final VoidCallback onDelete;

  const BudgetItem({
    Key? key,
    required this.budget,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = budget.progress;
    final isOverBudget = progress > 1.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.darkTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                  budget.category,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                  color: Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${budget.spent.toStringAsFixed(2)} of \$${budget.amount.toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[400],
                  ),
                ),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isOverBudget
                        ? Colors.redAccent[400]
                        : Colors.greenAccent[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress > 1.0 ? 1.0 : progress,
              minHeight: 8,
              backgroundColor: Colors.grey[800],
              color: isOverBudget
                  ? Colors.redAccent[400]
                  : AppTheme.darkTheme.primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
            if (isOverBudget)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Over budget by \$${(budget.spent - budget.amount).toStringAsFixed(2)}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.redAccent[400],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              "${budget.period} Budget",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}