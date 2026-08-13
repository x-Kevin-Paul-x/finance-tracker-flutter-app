import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:flutter_haiku/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/finance_provider.dart';
import 'screens/home_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/history_screen.dart';
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
        final isDark = themeProvider.themeMode == ThemeMode.dark ||
            (themeProvider.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
        final palette = themeProvider.palette;

        return MaterialApp(
          title: 'Haiku Treasure',
          theme: AppTheme(palette).lightTheme,
          darkTheme: AppTheme(palette).darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SafeArea(child: _pages[_index]),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _index,
                onTap: (i) => setState(() => _index = i),
                type: BottomNavigationBarType.fixed,
                backgroundColor: isDark ? palette.backgroundDark : palette.backgroundLight,
                selectedItemColor: const Color(0xFFD4AF37),
                unselectedItemColor: isDark ? Colors.white38 : Colors.black38,
                selectedLabelStyle: GoogleFonts.cinzel(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
                unselectedLabelStyle: GoogleFonts.cinzel(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    activeIcon: Icon(Icons.home_rounded, color: Color(0xFFD4AF37)),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history_rounded),
                    activeIcon: Icon(Icons.history_rounded, color: Color(0xFFD4AF37)),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart_rounded),
                    activeIcon: Icon(Icons.pie_chart_rounded, color: Color(0xFFD4AF37)),
                    label: 'Insights',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings_rounded),
                    activeIcon: Icon(Icons.settings_rounded, color: Color(0xFFD4AF37)),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
