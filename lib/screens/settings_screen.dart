import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:flutter_haiku/theme/color_palettes.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _spendingAlerts = true;
  bool _weeklySummary = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final palette = themeProvider.palette;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      body: Container(
         decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [palette.backgroundDark, palette.backgroundDark.withOpacity(0.8), palette.primary.withOpacity(0.1)]
                : [palette.backgroundLight, palette.backgroundLight, palette.primary.withOpacity(0.05)],
          ),
        ),
        child: ListView(
          children: [
            _buildSectionHeader(context, 'Appearance'),
            _buildAppearanceSection(context, themeProvider),
            _buildSectionHeader(context, 'Notifications'),
            _buildNotificationsSection(context),
            _buildSectionHeader(context, 'Data'),
            _buildDataSection(context),
            _buildSectionHeader(context, 'About'),
            _buildAboutSection(context),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Haiku Finance v1.2.0',
                style: GoogleFonts.inter(color: theme.textTheme.bodyMedium?.color, fontSize: 12),
              ),
            ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyMedium?.color,
          letterSpacing: 1.2,
          fontSize: 12
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(
      BuildContext context, ThemeProvider themeProvider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        children: [
          _buildThemeModeTile(context, themeProvider),
          const Divider(height: 1),
          _buildColorPaletteTile(context, themeProvider),
        ],
      ),
    );
  }

  Widget _buildThemeModeTile(
      BuildContext context, ThemeProvider themeProvider) {
    return ListTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: Text('Theme Mode', style: GoogleFonts.inter()),
      trailing: DropdownButton<ThemeMode>(
        value: themeProvider.themeMode,
        underline: const SizedBox(),
        items: [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text('System', style: GoogleFonts.inter()),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text('Light', style: GoogleFonts.inter()),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text('Dark', style: GoogleFonts.inter()),
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

  Widget _buildColorPaletteTile(
      BuildContext context, ThemeProvider themeProvider) {
    return ListTile(
      leading: const Icon(Icons.color_lens_outlined),
      title: Text('Color Palette', style: GoogleFonts.inter()),
      trailing: DropdownButton<Palette>(
        value: themeProvider.palette,
         underline: const SizedBox(),
        items: AppPalettes.allPalettes.map((palette) {
          return DropdownMenuItem(
            value: palette,
            child: Text(palette.name, style: GoogleFonts.inter()),
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

  Widget _buildNotificationsSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text('Spending Alerts', style: GoogleFonts.inter()),
            value: _spendingAlerts,
            onChanged: (value) {
              setState(() {
                _spendingAlerts = value;
              });
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.calendar_month_outlined),
            title: Text('Weekly Summary', style: GoogleFonts.inter()),
            value: _weeklySummary,
            onChanged: (value) {
              setState(() {
                _weeklySummary = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.ios_share),
            title: Text('Export Data', style: GoogleFonts.inter()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSnackbar(context, 'Export Data'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text('Manage Categories', style: GoogleFonts.inter()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSnackbar(context, 'Manage Categories'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text('Help & Support', style: GoogleFonts.inter()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSnackbar(context, 'Help & Support'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy Policy', style: GoogleFonts.inter()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSnackbar(context, 'Privacy Policy'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text('Terms of Service', style: GoogleFonts.inter()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSnackbar(context, 'Terms of Service'),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature is not yet implemented.', style: GoogleFonts.inter()),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
