import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:flutter_haiku/theme/app_theme.dart';
import 'providers/finance_provider.dart';
import 'screens/home_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/history_screen.dart';
// 'manage_categories_screen.dart' is imported where needed; remove here to avoid unused import warning
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
      child: const HaikuFinanceApp(),
    ),
  );
}

class HaikuFinanceApp extends StatefulWidget {
  const HaikuFinanceApp({super.key});

  @override
  State<HaikuFinanceApp> createState() => _HaikuFinanceAppState();
}

class _HaikuFinanceAppState extends State<HaikuFinanceApp> {
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
          title: 'Haiku Finance',
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
