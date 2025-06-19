import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moneywise/app_theme.dart';
import 'package:moneywise/models/transaction_model.dart';
import 'package:moneywise/providers/finance_provider.dart';
import 'package:moneywise/widgets/analytics_tabs.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeFrame = "This Month";
  final List<String> _timeFrameOptions = [
    "This Week",
    "This Month",
    "This Year",
    "All Time"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Analytics"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              AnalyticsTabs(tabController: _tabController),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSpendingTab(),
          _buildIncomeTab(),
          _buildComparisonTab(),
        ],
      ),
    );
  }

  Widget _buildSpendingTab() {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final transactions = _filterTransactions(provider.transactions, TransactionType.expense);
        final categorySpending = _calculateCategorySpending(transactions);

        if (transactions.isEmpty) {
          return const Center(
            child: Text("No expense data available"),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: _buildPieChartSections(categorySpending),
                    centerSpaceRadius: 60,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...categorySpending.entries.map((entry) =>
                  _buildCategorySpendingItem(entry.key, entry.value)
              ).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIncomeTab() {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final transactions = _filterTransactions(provider.transactions, TransactionType.income);
        final categoryIncome = _calculateCategorySpending(transactions);

        if (transactions.isEmpty) {
          return const Center(
            child: Text("No income data available"),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    barGroups: _buildBarChartGroups(categoryIncome),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final category = categoryIncome.keys.elementAt(value.toInt());
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                category.split(' ').map((e) => e[0]).join(),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...categoryIncome.entries.map((entry) =>
                  _buildCategorySpendingItem(entry.key, entry.value)
              ).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComparisonTab() {
    return Consumer<FinanceProvider>(
      builder: (context, provider, child) {
        final income = _filterTransactions(provider.transactions, TransactionType.income);
        final expenses = _filterTransactions(provider.transactions, TransactionType.expense);

        if (income.isEmpty && expenses.isEmpty) {
          return const Center(
            child: Text("No data available"),
          );
        }

        final monthlyComparison = _calculateMonthlyComparison(income, expenses);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: monthlyComparison['income']!.map((e) =>
                            FlSpot(e['month']!.toDouble(), e['amount']!)
                        ).toList(),
                        color: Colors.green,
                        isCurved: true,
                      ),
                      LineChartBarData(
                        spots: monthlyComparison['expense']!.map((e) =>
                            FlSpot(e['month']!.toDouble(), e['amount']!)
                        ).toList(),
                        color: Colors.red,
                        isCurved: true,
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final month = value.toInt();
                            return Text(DateFormat.MMM().format(DateTime(2023, month)));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildComparisonMetric(
                    "Total Income",
                    monthlyComparison['income']!.fold(0.0, (sum, item) => sum + item['amount']!),
                    Colors.green,
                  ),
                  _buildComparisonMetric(
                    "Total Expense",
                    monthlyComparison['expense']!.fold(0.0, (sum, item) => sum + item['amount']!),
                    Colors.red,
                  ),
                  _buildComparisonMetric(
                    "Net Balance",
                    monthlyComparison['income']!.fold(0.0, (sum, item) => sum + item['amount']!) -
                        monthlyComparison['expense']!.fold(0.0, (sum, item) => sum + item['amount']!),
                    AppTheme.darkTheme.primaryColor,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComparisonMetric(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  List<Transaction> _filterTransactions(List<Transaction> transactions, TransactionType type) {
    final now = DateTime.now();
    List<Transaction> filtered = transactions.where((t) => t.type == type).toList();

    if (_selectedTimeFrame == "This Week") {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      filtered = filtered.where((t) => t.date.isAfter(startOfWeek)).toList();
    } else if (_selectedTimeFrame == "This Month") {
      filtered = filtered.where((t) =>
      t.date.year == now.year && t.date.month == now.month
      ).toList();
    } else if (_selectedTimeFrame == "This Year") {
      filtered = filtered.where((t) => t.date.year == now.year).toList();
    }

    return filtered;
  }

  Map<String, double> _calculateCategorySpending(List<Transaction> transactions) {
    final Map<String, double> categorySpending = {};

    for (var transaction in transactions) {
      if (categorySpending.containsKey(transaction.category)) {
        categorySpending[transaction.category] =
            categorySpending[transaction.category]! + transaction.amount;
      } else {
        categorySpending[transaction.category] = transaction.amount;
      }
    }

    return categorySpending;
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, double> categorySpending) {
    final List<Color> colors = [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
      Colors.tealAccent,
      Colors.yellowAccent,
      Colors.pinkAccent,
    ];

    double total = categorySpending.values.fold(0, (sum, amount) => sum + amount);

    return categorySpending.entries.map((entry) {
      final index = categorySpending.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value,
        title: "${(entry.value / total * 100).toStringAsFixed(1)}%",
        radius: 20,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();
  }

  List<BarChartGroupData> _buildBarChartGroups(Map<String, double> categoryIncome) {
    return categoryIncome.entries.map((entry) {
      final index = categoryIncome.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.greenAccent,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Map<String, List<Map<String, double>>> _calculateMonthlyComparison(
      List<Transaction> income,
      List<Transaction> expenses
      ) {
    final Map<String, List<Map<String, double>>> result = {
      'income': [],
      'expense': [],
    };

    for (int month = 1; month <= 12; month++) {
      final monthIncome = income.where((t) => t.date.month == month).fold(0.0, (sum, t) => sum + t.amount);
      final monthExpense = expenses.where((t) => t.date.month == month).fold(0.0, (sum, t) => sum + t.amount);

      result['income']!.add({'month': month.toDouble(), 'amount': monthIncome});
      result['expense']!.add({'month': month.toDouble(), 'amount': monthExpense});
    }

    return result;
  }

  Widget _buildCategorySpendingItem(String category, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.tealAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(category),
              color: AppTheme.darkTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: amount / 1000, // Assuming max is 1000 for demo
                  backgroundColor: Colors.grey[800],
                  color: AppTheme.darkTheme.primaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            "\$${amount.toStringAsFixed(2)}",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.fastfood_rounded;
      case 'Transport':
        return Icons.directions_car_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Entertainment':
        return Icons.movie_rounded;
      case 'Bills':
        return Icons.receipt_rounded;
      case 'Salary':
        return Icons.work_rounded;
      case 'Investment':
        return Icons.trending_up_rounded;
      case 'Gift':
        return Icons.card_giftcard_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}