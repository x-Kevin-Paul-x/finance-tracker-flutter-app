import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:flutter_haiku/providers/finance_provider.dart';
import 'package:flutter_haiku/theme/color_palettes.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _spendingAlerts = true;
  bool _weeklySummary = true;
  bool _dailyReflections = true;
  double _monthlyBudgetTarget = 50000.0;
  String _selectedCurrency = '₹ INR (Indian Rupee)';

  final List<String> _currencies = [
    '₹ INR (Indian Rupee)',
    '\$ USD (US Dollar)',
    '€ EUR (Euro)',
    '£ GBP (British Pound)',
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final financeProvider = Provider.of<FinanceProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = themeProvider.palette;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 1.3,
            color: isDark ? const Color(0xFFF3E5AB) : const Color(0xFF2B1D18),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Background Wallpaper Image
          Positioned.fill(
            child: Image.asset(
              isDark ? palette.darkBgAsset : palette.lightBgAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2,
                    colors: isDark ? palette.gradientFallbackDark : palette.gradientFallbackLight,
                  ),
                ),
              ),
            ),
          ),
          // Reduced Overlay Opacity (0.42 to 0.60) so the background is seeable & beautiful!
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withOpacity(0.60),
                          Colors.black.withOpacity(0.78),
                        ]
                      : [
                          Colors.white.withOpacity(0.12),
                          Colors.white.withOpacity(0.30),
                        ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              children: [
                // 1. Royal Stewardship Profile Header Card
                _buildProfileHeaderCard(context, isDark, palette),
                const SizedBox(height: 16),

                // 2. Appearance & Theme Section
                _buildSectionHeader('APPEARANCE & THEME'),
                _buildCardContainer(
                  isDark,
                  palette,
                  children: [
                    _buildThemeModeTile(context, themeProvider, isDark),
                    _buildDivider(),
                    _buildColorPaletteTile(context, themeProvider, isDark),
                    _buildDivider(),
                    _buildCurrencyTile(context, isDark),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. Financial Stewardship & Budget Controls
                _buildSectionHeader('STEWARDSHIP & BUDGET'),
                _buildCardContainer(
                  isDark,
                  palette,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.track_changes_rounded, color: Color(0xFFD4AF37)),
                      title: Text('Monthly Budget Target', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                      subtitle: Text(
                        'Target limit: ₹ ${_monthlyBudgetTarget.toStringAsFixed(2)}',
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFFD4AF37), fontWeight: FontWeight.w700),
                      ),
                      trailing: const Icon(Icons.edit_outlined, color: Color(0xFFD4AF37), size: 20),
                      onTap: () => _showBudgetDialog(context),
                    ),
                    _buildDivider(),
                    SwitchListTile(
                      secondary: const Icon(Icons.notifications_active_outlined, color: Color(0xFFD4AF37)),
                      title: Text('Spending Threshold Alerts', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                      subtitle: Text('Notify when spending exceeds 80% budget', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54)),
                      activeColor: const Color(0xFFD4AF37),
                      value: _spendingAlerts,
                      onChanged: (val) => setState(() => _spendingAlerts = val),
                    ),
                    _buildDivider(),
                    SwitchListTile(
                      secondary: const Icon(Icons.auto_stories_outlined, color: Color(0xFFD4AF37)),
                      title: Text('Daily Wisdom Reflections', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                      subtitle: Text('Proverbs stewardship cards on home screen', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54)),
                      activeColor: const Color(0xFFD4AF37),
                      value: _dailyReflections,
                      onChanged: (val) => setState(() => _dailyReflections = val),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Data Management & Backup Section
                _buildSectionHeader('DATA & EXPORT'),
                _buildCardContainer(
                  isDark,
                  palette,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.file_download_outlined, color: Color(0xFFD4AF37)),
                      title: Text('Export Financial Data (CSV)', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                      subtitle: Text('${financeProvider.transactions.length} entries ready for export', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFD4AF37)),
                      onTap: () => _exportData(context, financeProvider),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: const Icon(Icons.cloud_sync_outlined, color: Color(0xFFD4AF37)),
                      title: Text('Local Database Sync', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                      subtitle: Text('SQLite Encrypted Local Storage', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: isDark ? Colors.white54 : Colors.black54)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF107C41).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF107C41)),
                        ),
                        child: Text(
                          'ACTIVE',
                          style: GoogleFonts.cinzel(color: const Color(0xFF107C41), fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 5. About & Support Section
                _buildSectionHeader('ABOUT & SUPPORT'),
                _buildCardContainer(
                  isDark,
                  palette,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.help_outline_rounded, color: Color(0xFFD4AF37)),
                      title: Text('Help & Stewardship Guide', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFD4AF37)),
                      onTap: () => _showSnackbar(context, 'Haiku Stewardship Guide'),
                    ),
                    _buildDivider(),
                    ListTile(
                      leading: const Icon(Icons.shield_outlined, color: Color(0xFFD4AF37)),
                      title: Text('Privacy & Security Policy', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFD4AF37)),
                      onTap: () => _showSnackbar(context, 'Privacy Policy'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Footer Edition Badge
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        width: 80,
                        color: const Color(0xFFD4AF37).withOpacity(0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'HAIKU TREASURE',
                        style: GoogleFonts.cinzel(
                          color: const Color(0xFFD4AF37),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        'Indian Art Nouveau Fine Art Edition v1.2',
                        style: GoogleFonts.plusJakartaSans(
                          color: isDark ? Colors.white54 : Colors.black54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderCard(BuildContext context, bool isDark, dynamic palette) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1411).withOpacity(0.92) : Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.45),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFB7410E)],
              ),
              border: Border.all(color: const Color(0xFFF3E5AB), width: 1.5),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Faithful Steward',
                  style: GoogleFonts.cinzel(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: isDark ? const Color(0xFFF3E5AB) : const Color(0xFF2B1D18),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Royal Fine Art Edition • ₹ INR',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)),
            ),
            child: Text(
              'PRO',
              style: GoogleFonts.cinzel(
                color: const Color(0xFFD4AF37),
                fontWeight: FontWeight.w900,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
      child: Text(
        title,
        style: GoogleFonts.cinzel(
          fontWeight: FontWeight.w800,
          color: const Color(0xFFD4AF37),
          letterSpacing: 1.4,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildCardContainer(bool isDark, dynamic palette, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1411).withOpacity(0.92) : Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildThemeModeTile(BuildContext context, ThemeProvider themeProvider, bool isDark) {
    return ListTile(
      leading: const Icon(Icons.brightness_6_outlined, color: Color(0xFFD4AF37)),
      title: Text('Theme Mode', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
      trailing: DropdownButton<ThemeMode>(
        value: themeProvider.themeMode,
        underline: const SizedBox(),
        dropdownColor: isDark ? const Color(0xFF1B1411) : Colors.white,
        items: [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text('System', style: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white : Colors.black)),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text('Light', style: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white : Colors.black)),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text('Dark', style: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white : Colors.black)),
          ),
        ],
        onChanged: (mode) {
          if (mode != null) {
            themeProvider.setThemeMode(mode);
          }
        },
      ),
    );
  }

  Widget _buildColorPaletteTile(BuildContext context, ThemeProvider themeProvider, bool isDark) {
    return ListTile(
      leading: const Icon(Icons.color_lens_outlined, color: Color(0xFFD4AF37)),
      title: Text('Artistic Palette', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
      trailing: DropdownButton<Palette>(
        value: themeProvider.palette,
        underline: const SizedBox(),
        dropdownColor: isDark ? const Color(0xFF1B1411) : Colors.white,
        items: AppPalettes.allPalettes.map((palette) {
          return DropdownMenuItem(
            value: palette,
            child: Text(palette.name, style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, color: const Color(0xFFD4AF37))),
          );
        }).toList(),
        onChanged: (palette) {
          if (palette != null) {
            themeProvider.setPalette(palette);
          }
        },
      ),
    );
  }

  Widget _buildCurrencyTile(BuildContext context, bool isDark) {
    return ListTile(
      leading: const Icon(Icons.currency_exchange_rounded, color: Color(0xFFD4AF37)),
      title: Text('Default Currency', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
      trailing: DropdownButton<String>(
        value: _selectedCurrency,
        underline: const SizedBox(),
        dropdownColor: isDark ? const Color(0xFF1B1411) : Colors.white,
        items: _currencies.map((curr) {
          return DropdownMenuItem(
            value: curr,
            child: Text(curr.split(' ')[0], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black)),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            setState(() => _selectedCurrency = val);
          }
        },
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: const Color(0xFFD4AF37).withOpacity(0.2));
  }

  void _showBudgetDialog(BuildContext context) {
    final controller = TextEditingController(text: _monthlyBudgetTarget.toString());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1B1411) : const Color(0xFFFFFDF9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFFD4AF37), width: 1.2),
        ),
        title: Text('Set Monthly Budget Target', style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, color: const Color(0xFFD4AF37))),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Budget Amount (₹)',
            labelStyle: GoogleFonts.plusJakartaSans(color: const Color(0xFFD4AF37)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD4AF37))),
          ),
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 16, color: isDark ? Colors.white : Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: GoogleFonts.cinzel(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB7410E)),
            onPressed: () {
              final newBudget = double.tryParse(controller.text);
              if (newBudget != null) {
                setState(() => _monthlyBudgetTarget = newBudget);
              }
              Navigator.pop(context);
            },
            child: Text('SAVE', style: GoogleFonts.cinzel(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  void _exportData(BuildContext context, FinanceProvider provider) {
    final count = provider.transactions.length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF107C41),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Successfully exported $count flows to CSV!',
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFB7410E),
        content: Text('$feature is active in this edition.', style: GoogleFonts.plusJakartaSans(color: Colors.white)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
