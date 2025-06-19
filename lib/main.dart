import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneywise/app_theme.dart';
import 'package:moneywise/screens/home_screen.dart';
import 'package:moneywise/screens/onboarding_screen.dart';
import 'package:moneywise/providers/finance_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if user has completed onboarding
  final prefs = await SharedPreferences.getInstance();
  final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => FinanceProvider(),
        child: MoneyWiseApp(hasCompletedOnboarding: hasCompletedOnboarding),
      ),
    );
  });
}

class MoneyWiseApp extends StatelessWidget {
  final bool hasCompletedOnboarding;

  const MoneyWiseApp({Key? key, required this.hasCompletedOnboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
      ],
      home: hasCompletedOnboarding ? HomeScreen() : OnboardingScreen(),
    );
  }
}