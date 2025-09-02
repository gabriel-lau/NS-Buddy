import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart' show Jiffy;
import '../controllers/app_controller.dart';
import 'home_view.dart';

class OnboardingView extends StatefulWidget {
  final AppController appController;

  const OnboardingView({super.key, required this.appController});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  DateTime? _dob;
  // String? _gender; // temporarily disabled
  bool _isShiongVoc = false;
  DateTime? _ordDate;
  DateTime? _enlistmentDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final s = widget.appController.settings;
    _dob = s.dob;
    // _gender = s.gender;
    _isShiongVoc = s.isShiongVoc;
    _ordDate = s.ordDate;
    _enlistmentDate = s.enlistmentDate;
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final List<String> missing = [];
    if (_dob == null) missing.add('Date of Birth');
    // if (_gender == null) missing.add('Gender'); // disabled
    if (missing.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete: ${missing.join(', ')}')),
      );
      return;
    }
    final settings = widget.appController.settings;
    settings.setDob(_dob);
    // settings.setGender(_gender); // disabled
    settings.setIsShiongVoc(_isShiongVoc);
    settings.setEnlistmentDate(_enlistmentDate);
    settings.setOrdDate(_ordDate);
    settings.setHasCompletedOnboarding(true);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => HomeView(appController: widget.appController),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          key: _formKey,
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
                                    _dob != null
                                        ? _formatDmy(_dob!)
                                        : 'Not set',
                                  ),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () => _pickDate(
                                    context,
                                    (date) {
                                      setState(() => _dob = date);
                                    },
                                    initialDate: _dob,
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
                                  value: _isShiongVoc,
                                  onChanged: (v) =>
                                      setState(() => _isShiongVoc = v),
                                ),

                                // Enlistment Date
                                ListTile(
                                  title: const Text('Enlistment Date'),
                                  subtitle: Text(
                                    _enlistmentDate != null
                                        ? _formatDmy(_enlistmentDate!)
                                        : 'Not set',
                                  ),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () => _pickDate(
                                    context,
                                    (date) {
                                      setState(() => _enlistmentDate = date);
                                    },
                                    initialDate: _enlistmentDate,
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
                                    _ordDate != null
                                        ? _formatDmy(_ordDate!)
                                        : 'Not set',
                                  ),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () => _pickDate(
                                    context,
                                    (date) {
                                      setState(() => _ordDate = date);
                                    },
                                    initialDate: _ordDate,
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
                            onPressed: _submit,
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
}
