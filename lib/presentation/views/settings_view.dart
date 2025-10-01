import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart' show Jiffy;
import 'package:ns_buddy/enums/colour_option.dart' show ColourOption;
import 'package:ns_buddy/enums/theme_option.dart' show ThemeOption;
import 'package:ns_buddy/presentation/viewmodels/temp_view_model.dart';
import 'package:ns_buddy/presentation/views/onboarding_view.dart'
    show OnboardingView;
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final tempViewModel = Provider.of<TempViewModel>(context);
    final settings = tempViewModel.settings;
    final userInfo = tempViewModel.userInfo;

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
                                  userInfo.dob != null
                                      ? '${userInfo.dob!.day}/${userInfo.dob!.month}/${userInfo.dob!.year}'
                                      : 'Not set',
                                ),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(
                                  context,
                                  userInfo.dob,
                                  DateTime(1900),
                                  Jiffy.now().subtract(years: 16).dateTime,
                                  (date) {
                                    tempViewModel.setDob(date);
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
                                value: userInfo.isShiongVoc,
                                onChanged: tempViewModel.setIsShiongVoc,
                              ),

                              // Enlistment Date
                              ListTile(
                                title: const Text('Enlistment Date'),
                                subtitle: Text(
                                  userInfo.enlistmentDate != null
                                      ? '${userInfo.enlistmentDate!.day}/${userInfo.enlistmentDate!.month}/${userInfo.enlistmentDate!.year}'
                                      : 'Not set',
                                ),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(
                                  context,
                                  userInfo.enlistmentDate,
                                  DateTime(1900),
                                  Jiffy.now().add(years: 5).dateTime,
                                  (date) {
                                    tempViewModel.setEnlistmentDate(date);
                                  },
                                ),
                              ),

                              // ORD Date
                              ListTile(
                                title: const Text('ORD Date'),
                                subtitle: Text(
                                  userInfo.ordDate != null
                                      ? '${userInfo.ordDate!.day}/${userInfo.ordDate!.month}/${userInfo.ordDate!.year}'
                                      : 'Not set',
                                ),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(
                                  context,
                                  userInfo.ordDate,
                                  DateTime(1900),
                                  Jiffy.now().add(years: 5).dateTime,
                                  (date) {
                                    tempViewModel.setOrdDate(date);
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
                                    tempViewModel.setTheme(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ThemeOption.light,
                                groupValue: settings.theme,
                                title: const Text('Light Theme'),
                                onChanged: (value) {
                                  if (value != null) {
                                    tempViewModel.setTheme(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ThemeOption.dark,
                                groupValue: settings.theme,
                                title: const Text('Dark Theme'),
                                onChanged: (value) {
                                  if (value != null) {
                                    tempViewModel.setTheme(value);
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
                                    tempViewModel.setPrimaryColour(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ColourOption.red,
                                groupValue: settings.primaryColour,
                                title: const Text('Red'),
                                onChanged: (value) {
                                  if (value != null) {
                                    tempViewModel.setPrimaryColour(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ColourOption.green,
                                groupValue: settings.primaryColour,
                                title: const Text('Green'),
                                onChanged: (value) {
                                  if (value != null) {
                                    tempViewModel.setPrimaryColour(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ColourOption.blue,
                                groupValue: settings.primaryColour,
                                title: const Text('Blue'),
                                onChanged: (value) {
                                  if (value != null) {
                                    tempViewModel.setPrimaryColour(value);
                                  }
                                },
                              ),
                              RadioListTile(
                                value: ColourOption.deepPurple,
                                groupValue: settings.primaryColour,
                                title: const Text('Deep Purple'),
                                onChanged: (value) {
                                  if (value != null) {
                                    tempViewModel.setPrimaryColour(value);
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
                                  tempViewModel.resetSettings();
                                  // Transition to onboarding flow
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => OnboardingView(),
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
