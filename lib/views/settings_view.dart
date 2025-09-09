import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart' show Jiffy;
import 'package:ns_buddy/enums/colour_option.dart' show ColourOption;
import 'package:ns_buddy/enums/theme_option.dart' show ThemeOption;
import 'package:ns_buddy/views/onboarding_view.dart' show OnboardingView;
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
                                onTap: () => _selectDate(
                                  context,
                                  settings.dob,
                                  DateTime(1900),
                                  Jiffy.now().subtract(years: 16).dateTime,
                                  (date) {
                                    appController.setDob(date);
                                  },
                                ),
                              ),

                              // Gender (temporarily disabled)
                              // ListTile(
                              //   title: const Text('Gender'),
                              //   subtitle: Text(settings.gender ?? 'Not set'),
                              //   trailing: const Icon(Icons.arrow_forward_ios),
                              //   onTap: () => _selectGender(
                              //     context,
                              //     settings.gender,
                              //     (gender) {
                              //       appController.setGender(gender);
                              //     },
                              //   ),
                              // ),

                              // Is Shiong Voc
                              SwitchListTile(
                                title: const Text('Shiong vocation'),
                                subtitle: const Text(
                                  'Are you in Commando, NDU or Guards?',
                                ),
                                value: settings.isShiongVoc,
                                onChanged: appController.setIsShiongVoc,
                              ),

                              // Enlistment Date
                              ListTile(
                                title: const Text('Enlistment Date'),
                                subtitle: Text(
                                  settings.enlistmentDate != null
                                      ? '${settings.enlistmentDate!.day}/${settings.enlistmentDate!.month}/${settings.enlistmentDate!.year}'
                                      : 'Not set',
                                ),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(
                                  context,
                                  settings.enlistmentDate,
                                  DateTime(1900),
                                  Jiffy.now().add(years: 5).dateTime,
                                  (date) {
                                    appController.setEnlistmentDate(date);
                                  },
                                ),
                              ),

                              // ORD Date
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
                                  DateTime(1900),
                                  Jiffy.now().add(years: 5).dateTime,
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
                              // SwitchListTile(
                              //   title: const Text('Dynamic Colors'),
                              //   subtitle: Text(
                              //     settings.useDynamicColors
                              //         ? 'Using system accent colors'
                              //         : 'Using static colors',
                              //   ),
                              //   value: settings.useDynamicColors,
                              //   onChanged: appController.setDynamicColors,
                              // ),
                              // SwitchListTile(
                              //   title: const Text('Dark Mode'),
                              //   subtitle: Text(
                              //     settings.isDarkMode
                              //         ? 'Using dark theme'
                              //         : 'Using light theme',
                              //   ),
                              //   value: settings.isDarkMode,
                              //   onChanged: (value) {
                              //     appController.setDynamicColors(false);
                              //     appController.toggleThemeMode();
                              //   },
                              //   secondary: Icon(
                              //     settings.isDarkMode
                              //         ? Icons.dark_mode
                              //         : Icons.light_mode,
                              //   ),
                              // ),
                              RadioListTile(
                                value: ThemeOption.system,
                                groupValue: settings.theme,
                                title: const Text('Follow System Theme'),
                                onChanged: (value) {
                                  if (value != null) {
                                    appController.setTheme(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ThemeOption.light,
                                groupValue: settings.theme,
                                title: const Text('Light Theme'),
                                onChanged: (value) {
                                  if (value != null) {
                                    appController.setTheme(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ThemeOption.dark,
                                groupValue: settings.theme,
                                title: const Text('Dark Theme'),
                                onChanged: (value) {
                                  if (value != null) {
                                    appController.setTheme(value);
                                  }
                                },
                              ),

                              const SizedBox(height: 16.0),
                              RadioListTile(
                                value: ColourOption.system,
                                groupValue: settings.primaryColour,
                                title: const Text('System Accent Color'),
                                onChanged: (value) {
                                  if (value != null) {
                                    appController.setPrimaryColour(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ColourOption.red,
                                groupValue: settings.primaryColour,
                                title: const Text('Red'),
                                onChanged: (value) {
                                  if (value != null) {
                                    appController.setPrimaryColour(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ColourOption.green,
                                groupValue: settings.primaryColour,
                                title: const Text('Green'),
                                onChanged: (value) {
                                  if (value != null) {
                                    appController.setPrimaryColour(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ColourOption.blue,
                                groupValue: settings.primaryColour,
                                title: const Text('Blue'),
                                onChanged: (value) {
                                  if (value != null) {
                                    appController.setPrimaryColour(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ColourOption.deepPurple,
                                groupValue: settings.primaryColour,
                                title: const Text('Deep Purple'),
                                onChanged: (value) {
                                  if (value != null) {
                                    appController.setPrimaryColour(value);
                                  }
                                },
                              ),
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Primary Colour',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 24.0,
                                                height: 24.0,
                                                color: Colors.red,
                                              ),
                                              SizedBox(width: 8.0),
                                              Container(
                                                width: 24.0,
                                                height: 24.0,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 8.0),
                                              Container(
                                                width: 24.0,
                                                height: 24.0,
                                                color: Colors.blue,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'This is a custom subtitle for a more flexible layout.',
                                            style: TextStyle(
                                              fontSize: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.fontSize,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Reset Settings
                              TextButton(
                                onPressed: () {
                                  appController.resetSettings();
                                  // Transition to onboarding flow
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => OnboardingView(
                                        appController: appController,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Reset to Default'),
                              ),
                            ],
                          ),
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

  Future<void> _selectDate(
    BuildContext context,
    DateTime? initialDate,
    DateTime firstDate,
    DateTime lastDate,
    Function(DateTime?) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  // Gender selection temporarily disabled for future versions
}
