import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';

class SettingsView extends StatelessWidget {
  final AppController appController;

  const SettingsView({super.key, required this.appController});

  @override
  Widget build(BuildContext context) {
    final settings = appController.settings;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Material 3 with Dynamic Colors',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'This app now supports Material 3 design and dynamic colors on supported platforms.',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              SwitchListTile(
                                title: const Text('Dynamic Colors'),
                                subtitle: Text(
                                  settings.useDynamicColors
                                      ? 'Using system accent colors'
                                      : 'Using static colors',
                                ),
                                value: settings.useDynamicColors,
                                onChanged: appController.setDynamicColors,
                              ),
                              SwitchListTile(
                                title: const Text('Dark Mode'),
                                subtitle: Text(
                                  settings.isDarkMode
                                      ? 'Using dark theme'
                                      : 'Using light theme',
                                ),
                                value: settings.isDarkMode,
                                onChanged: (value) =>
                                    appController.toggleThemeMode(),
                                secondary: Icon(
                                  settings.isDarkMode
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Color Scheme Preview',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildColorPreview(
                                  context,
                                  'Primary',
                                  Theme.of(context).colorScheme.primary,
                                ),
                                _buildColorPreview(
                                  context,
                                  'Secondary',
                                  Theme.of(context).colorScheme.secondary,
                                ),
                                _buildColorPreview(
                                  context,
                                  'Tertiary',
                                  Theme.of(context).colorScheme.tertiary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildColorPreview(BuildContext context, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
