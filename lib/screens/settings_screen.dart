import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_haiku/providers/theme_provider.dart';
import 'package:flutter_haiku/theme/color_palettes.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      body: ListView(
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
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyMedium?.color,
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
      leading: const Icon(Icons.brightness_6),
      title: const Text('Theme Mode'),
      trailing: DropdownButton<ThemeMode>(
        value: themeProvider.themeMode,
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text('System'),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text('Light'),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text('Dark'),
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
      leading: const Icon(Icons.color_lens),
      title: const Text('Color Palette'),
      trailing: DropdownButton<Palette>(
        value: themeProvider.palette,
        items: AppPalettes.allPalettes.map((palette) {
          return DropdownMenuItem(
            value: palette,
            child: Text(palette.name),
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
            secondary: const Icon(Icons.notifications),
            title: const Text('Spending Alerts'),
            value: _spendingAlerts,
            onChanged: (value) {
              setState(() {
                _spendingAlerts = value;
              });
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.calendar_month),
            title: const Text('Weekly Summary'),
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
            title: const Text('Export Data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSnackbar(context, 'Export Data'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Manage Categories'),
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
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSnackbar(context, 'Help & Support'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSnackbar(context, 'Privacy Policy'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
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
        content: Text('$feature is not yet implemented.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
