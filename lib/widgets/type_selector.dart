import 'package:flutter/material.dart';
import 'package:moneywise/app_theme.dart';
import 'package:moneywise/models/transaction_model.dart';

class TypeSelector extends StatelessWidget {
  final TransactionType selectedType;
  final ValueChanged<TransactionType> onTypeChanged;

  const TypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.darkTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: _buildTypeButton(
                context,
                "Income",
                TransactionType.income,
                Icons.arrow_downward_rounded,
                Colors.greenAccent[400]!,
              ),
            ),
            Expanded(
              child: _buildTypeButton(
                context,
                "Expense",
                TransactionType.expense,
                Icons.arrow_upward_rounded,
                Colors.redAccent[400]!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(
      BuildContext context,
      String label,
      TransactionType type,
      IconData icon,
      Color color,
      ) {
    final isSelected = selectedType == type;

    return OutlinedButton(
      onPressed: () => onTypeChanged(type),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? color.withOpacity(0.2)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: isSelected ? color : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}