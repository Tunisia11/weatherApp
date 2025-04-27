import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/settings/cubit.dart';
import 'package:weather_app/cubit/settings/states.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Settings'),
                  content: const Text('Are you sure you want to reset all settings to default?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<SettingsCubit>().resetToDefaults();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Settings reset to defaults')),
                        );
                      },
                      child: const Text('RESET'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is SettingsLoaded) {
            final settings = state.settings;
            return ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: Text(_getLanguageName(settings.language)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildLanguageDialog(context, settings.language),
                    );
                  },
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text('Dark Theme'),
                  subtitle: const Text('Enable dark mode for the app'),
                  value: settings.darkTheme,
                  onChanged: (value) {
                    context.read<SettingsCubit>().toggleDarkTheme(value);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active),
                  title: const Text('Notifications'),
                  subtitle: const Text('Enable app notifications'),
                  value: settings.enableNotifications,
                  onChanged: (value) {
                    context.read<SettingsCubit>().toggleNotifications(value);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.warning_amber),
                  title: const Text('Alerts'),
                  subtitle: const Text('Enable in-app alerts'),
                  value: settings.enableAlerts,
                  onChanged: (value) {
                    context.read<SettingsCubit>().toggleAlerts(value);
                  },
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'App Version: 1.0.0',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'it':
        return 'Italian';
      case 'zh':
        return 'Chinese';
      case 'ar':
        return 'Arabic';
      default:
        return 'Unknown';
    }
  }

  Widget _buildLanguageDialog(BuildContext context, String currentLanguage) {
    final languages = {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
      'zh': 'Chinese',
      'ar': 'Arabic',
    };

    return AlertDialog(
      title: const Text('Select Language'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final languageCode = languages.keys.elementAt(index);
            final languageName = languages.values.elementAt(index);
            return RadioListTile<String>(
              title: Text(languageName),
              value: languageCode,
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsCubit>().updateLanguage(value);
                  Navigator.pop(context);
                }
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}
