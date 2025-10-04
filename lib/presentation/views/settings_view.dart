import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart' show Jiffy;
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/enums/colour_option.dart' show ColourOption;
import 'package:ns_buddy/enums/theme_option.dart' show ThemeOption;
import 'package:ns_buddy/presentation/viewmodels/settings_viewmodel.dart';
import 'package:ns_buddy/presentation/views/onboarding_view.dart'
    show OnboardingView;
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingsViewModel(
        userInfoUsecases: context.read<UserInfoUsecases>(),
        settingsUsecases: context.read<SettingsUsecases>(),
      ),
      child: _SettingsViewContent(),
    );
  }
}

class _SettingsViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsViewModel = context.watch<SettingsViewModel>();

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
                                  settingsViewModel.dob != null
                                      ? '${settingsViewModel.dob!.day}/${settingsViewModel.dob!.month}/${settingsViewModel.dob!.year}'
                                      : 'Not set',
                                ),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(
                                  context,
                                  settingsViewModel.dob,
                                  DateTime(1900),
                                  Jiffy.now().subtract(years: 16).dateTime,
                                  (date) {
                                    settingsViewModel.setDob(date);
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
                                value: settingsViewModel.isShiongVoc!,
                                onChanged: settingsViewModel.setIsShiongVoc,
                              ),

                              // Enlistment Date
                              ListTile(
                                title: const Text('Enlistment Date'),
                                subtitle: Text(
                                  settingsViewModel.enlistmentDate != null
                                      ? '${settingsViewModel.enlistmentDate!.day}/${settingsViewModel.enlistmentDate!.month}/${settingsViewModel.enlistmentDate!.year}'
                                      : 'Not set',
                                ),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(
                                  context,
                                  settingsViewModel.enlistmentDate,
                                  DateTime(1900),
                                  Jiffy.now().add(years: 5).dateTime,
                                  (date) {
                                    settingsViewModel.setEnlistmentDate(date);
                                  },
                                ),
                              ),

                              // ORD Date
                              ListTile(
                                title: const Text('ORD Date'),
                                subtitle: Text(
                                  settingsViewModel.ordDate != null
                                      ? '${settingsViewModel.ordDate!.day}/${settingsViewModel.ordDate!.month}/${settingsViewModel.ordDate!.year}'
                                      : 'Not set',
                                ),
                                trailing: const Icon(Icons.calendar_today),
                                onTap: () => _selectDate(
                                  context,
                                  settingsViewModel.ordDate,
                                  DateTime(1900),
                                  Jiffy.now().add(years: 5).dateTime,
                                  (date) {
                                    settingsViewModel.setOrdDate(date);
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
                              const Text(
                                'Theme',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SegmentedButton<ThemeOption>(
                                segments: const [
                                  ButtonSegment<ThemeOption>(
                                    value: ThemeOption.system,
                                    label: Text('System'),
                                    icon: Icon(Icons.brightness_auto),
                                  ),
                                  ButtonSegment<ThemeOption>(
                                    value: ThemeOption.light,
                                    label: Text('Light'),
                                    icon: Icon(Icons.light_mode),
                                  ),
                                  ButtonSegment<ThemeOption>(
                                    value: ThemeOption.dark,
                                    label: Text('Dark'),
                                    icon: Icon(Icons.dark_mode),
                                  ),
                                ],
                                selected: {settingsViewModel.theme},
                                onSelectionChanged:
                                    (Set<ThemeOption> selection) {
                                      settingsViewModel.setTheme(
                                        selection.first,
                                      );
                                    },
                              ),

                              const SizedBox(height: 16.0),
                              const Text(
                                'Primary Color',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SegmentedButton<ColourOption>(
                                segments: const [
                                  ButtonSegment<ColourOption>(
                                    value: ColourOption.system,
                                    label: Text('System'),
                                    icon: Icon(Icons.auto_awesome),
                                  ),
                                  ButtonSegment<ColourOption>(
                                    value: ColourOption.red,
                                    label: Text('Red'),
                                    icon: Icon(Icons.circle, color: Colors.red),
                                  ),
                                  ButtonSegment<ColourOption>(
                                    value: ColourOption.green,
                                    label: Text('Green'),
                                    icon: Icon(
                                      Icons.circle,
                                      color: Colors.green,
                                    ),
                                  ),
                                  ButtonSegment<ColourOption>(
                                    value: ColourOption.blue,
                                    label: Text('Blue'),
                                    icon: Icon(
                                      Icons.circle,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  ButtonSegment<ColourOption>(
                                    value: ColourOption.deepPurple,
                                    label: Text('Purple'),
                                    icon: Icon(
                                      Icons.circle,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ],
                                selected: {settingsViewModel.primaryColour},
                                onSelectionChanged:
                                    (Set<ColourOption> selection) {
                                      settingsViewModel.setPrimaryColour(
                                        selection.first,
                                      );
                                    },
                              ),
                              const SizedBox(height: 16),
                              // Reset Settings
                              TextButton(
                                onPressed: () {
                                  settingsViewModel.resetSettings();
                                  // Transition to onboarding flow
                                  Navigator.of(
                                    context,
                                  ).popUntil((route) => route.isFirst);
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
