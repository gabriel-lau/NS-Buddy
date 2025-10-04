import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart' show Jiffy;
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/presentation/viewmodels/onboarding_viewmodel.dart';
import 'package:provider/provider.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          OnboardingViewModel(context.read<UserInfoUsecases>()),
      child: _OnboardingViewContent(),
    );
  }
}

class _OnboardingViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final onboardingViewModel = context.watch<OnboardingViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        title: const Text('Welcome to NS Buddy'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: onboardingViewModel.formKey,
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
                                    onboardingViewModel.dob != null
                                        ? _formatDmy(onboardingViewModel.dob!)
                                        : 'Not set',
                                  ),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () => _pickDate(
                                    context,
                                    (date) {
                                      onboardingViewModel.dob = date;
                                    },
                                    initialDate: onboardingViewModel.dob,
                                    firstDate: DateTime(1960),
                                    lastDate: Jiffy.now()
                                        .subtract(years: 16)
                                        .dateTime,
                                  ),
                                ),

                                // Gender (temporarily disabled)
                                // ListTile(
                                //   title: const Text('Gender'),
                                //   subtitle: Text(_gender ?? 'Not set'),
                                //   trailing: const Icon(Icons.arrow_forward_ios),
                                //   onTap: () => _selectGender(
                                //     context,
                                //     _gender,
                                //     (gender) =>
                                //         setState(() => _gender = gender),
                                //   ),
                                // ),

                                // Shiong vocation
                                SwitchListTile(
                                  title: const Text('Shiong vocation'),
                                  subtitle: const Text(
                                    'Are you in Commando, NDU or Guards?',
                                  ),
                                  value: onboardingViewModel.isShiongVoc,
                                  onChanged: (v) =>
                                      onboardingViewModel.isShiongVoc = v,
                                ),

                                // Enlistment Date
                                ListTile(
                                  title: const Text('Enlistment Date'),
                                  subtitle: Text(
                                    onboardingViewModel.enlistmentDate != null
                                        ? _formatDmy(
                                            onboardingViewModel.enlistmentDate!,
                                          )
                                        : 'Not set',
                                  ),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () => _pickDate(
                                    context,
                                    (date) {
                                      onboardingViewModel.enlistmentDate = date;
                                    },
                                    initialDate:
                                        onboardingViewModel.enlistmentDate,
                                    firstDate: DateTime(1960),
                                    lastDate: Jiffy.now()
                                        .add(years: 5)
                                        .dateTime,
                                  ),
                                ),

                                // ORD Date
                                ListTile(
                                  title: const Text('ORD Date'),
                                  subtitle: Text(
                                    onboardingViewModel.ordDate != null
                                        ? _formatDmy(
                                            onboardingViewModel.ordDate!,
                                          )
                                        : 'Not set',
                                  ),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () => _pickDate(
                                    context,
                                    (date) {
                                      onboardingViewModel.ordDate = date;
                                    },
                                    initialDate: onboardingViewModel.ordDate,
                                    firstDate: DateTime(1960),
                                    lastDate: Jiffy.now()
                                        .add(years: 5)
                                        .dateTime,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Continue Button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () =>
                                onboardingViewModel.submit(context),
                            child: const Text('Continue'),
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
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    ValueChanged<DateTime?> setter, {
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setter(picked);
  }

  // Gender selection temporarily disabled for future versions

  String _formatDmy(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
