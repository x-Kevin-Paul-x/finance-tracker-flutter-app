import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pocketflow/providers/theme_provider.dart';
import 'providers/finance_provider.dart';
import 'screens/home_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/history_screen.dart';
import 'screens/manage_categories_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final financeProvider = FinanceProvider();
  await financeProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: financeProvider),
      ],
      child: const PocketFlowApp(),
    ),
  );
}

class PocketFlowApp extends StatefulWidget {
  const PocketFlowApp({super.key});

  @override
  State<PocketFlowApp> createState() => _PocketFlowAppState();
}

class _PocketFlowAppState extends State<PocketFlowApp> {
  int _index = 0;

  static const List<Widget> _pages = [
    HomeScreen(),
    HistoryScreen(),
    InsightsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'PocketFlow',
          theme: AppTheme(themeProvider.palette).lightTheme,
          darkTheme: AppTheme(themeProvider.palette).darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SafeArea(child: _pages[_index]),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.history), label: 'History'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart), label: 'Insights'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'Settings'),
              ],
            ),
          ),
        );
      },
    );
  }
}
