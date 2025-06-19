import 'package:flutter/material.dart';
import 'package:moneywise/app_theme.dart';

class AnalyticsTabs extends StatelessWidget {
  final TabController tabController;

  const AnalyticsTabs({Key? key, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.darkTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.darkTheme.primaryColor,
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey[400],
        tabs: const [
          Tab(text: "Spending"),
          Tab(text: "Income"),
          Tab(text: "Comparison"),
        ],
      ),
    );
  }
}