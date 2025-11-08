import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/finance_provider.dart';
import 'screens/home_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/history_screen.dart';
import 'screens/manage_categories_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = FinanceProvider();
  await provider.init();
  runApp(ChangeNotifierProvider.value(
    value: provider,
    child: const PocketFlowApp(),
  ));
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
    ManageCategoriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketFlow',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(child: _pages[_index]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Insights'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}
