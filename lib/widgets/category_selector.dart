import 'package:flutter/material.dart';
import 'package:moneywise/app_theme.dart';
import 'package:moneywise/models/transaction_model.dart';

class CategorySelector extends StatelessWidget {
  final TransactionType selectedType;
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

   CategorySelector({
    Key? key,
    required this.selectedType,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = selectedType == TransactionType.income
        ? _incomeCategories
        : _expenseCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Category",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = selectedCategory == category['name'];
            return ChoiceChip(
              label: Text(category['name']!),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(category['name']!);
                }
              },
              selectedColor: AppTheme.darkTheme.primaryColor,
              backgroundColor: AppTheme.darkTheme.cardColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
              ),
              avatar: Icon(
                IconData(category['icon']!, fontFamily: 'MaterialIcons'),
                color: isSelected ? Colors.black : AppTheme.darkTheme.primaryColor,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> _incomeCategories = [
    {'name': 'Salary', 'icon': 0xe3ab},
    {'name': 'Freelance', 'icon': 0xe4bc},
    {'name': 'Investment', 'icon': 0xe1c8},
    {'name': 'Gift', 'icon': 0xe14f},
    {'name': 'Bonus', 'icon': 0xf04b3},
    {'name': 'Other', 'icon': 0xe1db},
  ];

  final List<Map<String, dynamic>> _expenseCategories = [
    {'name': 'Food', 'icon': 0xe56c},
    {'name': 'Transport', 'icon': 0xe531},
    {'name': 'Shopping', 'icon': 0xe59c},
    {'name': 'Entertainment', 'icon': 0xe63b},
    {'name': 'Bills', 'icon': 0xe0af},
    {'name': 'Health', 'icon': 0xe548},
    {'name': 'Travel', 'icon': 0xe567},
    {'name': 'Education', 'icon': 0xe80c},
    {'name': 'Other', 'icon': 0xe1db},
  ];
}