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
                      // User Information Section
                      Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'User Information',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Date of Birth
                              ListTile(
                                title: const Text('Date of Birth'),
                                subtitle: Text(
                                  settings.dob != null
                                      ? '${settings.dob!.day}/${settings.dob!.month}/${settings.dob!.year}'
                                      : 'Not set',
                                ),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () =>
                                    _selectDate(context, settings.dob, (date) {
                                      appController.setDob(date);
                                    }),
                              ),

                              // Gender
                              ListTile(
                                title: const Text('Gender'),
                                subtitle: Text(settings.gender ?? 'Not set'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: () => _selectGender(
                                  context,
                                  settings.gender,
                                  (gender) {
                                    appController.setGender(gender);
                                  },
                                ),
                              ),

                              // Is Shiong Voc
                              SwitchListTile(
                                title: const Text('Shiong vocation'),
                                subtitle: const Text(
                                  'Are you in Commando, NDU or Guards?',
                                ),
                                value: settings.isShiongVoc,
                                onChanged: appController.setIsShiongVoc,
                              ),

                              // Has ORD
                              SwitchListTile(
                                title: const Text('Has ORD'),
                                subtitle: const Text('Have you ORDed?'),
                                value: settings.hasORD,
                                onChanged: appController.setHasORD,
                              ),

                              // ORD Date (only show if has ORD is false)
                              if (!settings.hasORD)
                                ListTile(
                                  title: const Text('ORD Date'),
                                  subtitle: Text(
                                    settings.ordDate != null
                                        ? '${settings.ordDate!.day}/${settings.ordDate!.month}/${settings.ordDate!.year}'
                                        : 'Not set',
                                  ),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () => _selectDate(
                                    context,
                                    settings.ordDate,
                                    (date) {
                                      appController.setOrdDate(date);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // App Settings Section
                      Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'App Settings',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Material 3 with Dynamic Colors',
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

                      // Color Scheme Preview
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

  Future<void> _selectDate(
    BuildContext context,
    DateTime? initialDate,
    Function(DateTime?) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  Future<void> _selectGender(
    BuildContext context,
    String? currentGender,
    Function(String?) onGenderSelected,
  ) async {
    final String? selectedGender = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Male'),
                leading: Radio<String>(
                  value: 'male',
                  groupValue: currentGender,
                  onChanged: (value) => Navigator.of(context).pop(value),
                ),
              ),
              ListTile(
                title: const Text('Female'),
                leading: Radio<String>(
                  value: 'female',
                  groupValue: currentGender,
                  onChanged: (value) => Navigator.of(context).pop(value),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedGender != null) {
      onGenderSelected(selectedGender);
    }
  }
}
