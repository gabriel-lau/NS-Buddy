import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../models/app_settings.dart';
import 'settings_view.dart';

class HomeView extends StatelessWidget {
  final AppController appController;

  const HomeView({super.key, required this.appController});

  @override
  Widget build(BuildContext context) {
    final settings = appController.settings;
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              elevation: 0,
              title: const Text('NS Buddy'),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SettingsView(appController: appController),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  tooltip: 'Settings',
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.fitness_center), text: 'IPPT'),
                  Tab(icon: Icon(Icons.add_circle_outline), text: 'Counter'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _IPPTTab(settings: settings),
                _CounterTab(settings: settings),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _IPPTTab extends StatefulWidget {
  final AppSettings settings;

  const _IPPTTab({required this.settings});

  @override
  State<_IPPTTab> createState() => _IPPTTabState();
}

class _IPPTTabState extends State<_IPPTTab> {
  double _pushUpValue = 0;
  double _sitUpValue = 0;
  double _runValue = 8;

  // Local, non-persisted age state
  late int _age = 16;
  final List<int> _ageOptions = List<int>.generate(45, (i) => 16 + i); // 16..60

  // Local, non-persisted gender state (disabled for now)
  // late String _genderLocal = 'male';

  // Local, non-persisted Shiong vocation
  late bool _isShiongVocLocal = false;

  // Tracks if any parameter in the collapsible card was edited by the user
  bool _isEdited = false;

  // Score calculations
  double get _pushUpScore => (_pushUpValue / 60.0) * 40.0;
  double get _sitUpScore => (_sitUpValue / 60.0) * 40.0;
  double get _runScore {
    // Lower time is better: 8min -> best, 20min -> worst
    final normalized = (20.0 - _runValue) / (20.0 - 8.0);
    return (normalized.clamp(0.0, 1.0)) * 20.0;
  }

  double get _score =>
      (_pushUpScore + _sitUpScore + _runScore).clamp(0.0, 100.0);
  int get _scoreInt => _score.round();
  String get _award {
    if (_score < 50) return 'fail';
    if (_score < 70) return 'pass';
    if (_score < 85) return 'silver';
    return 'gold';
  }

  @override
  void initState() {
    super.initState();
    _resetParameters();
  }

  void _resetParameters() {
    setState(() {
      _age = _deriveAgeFromDob(widget.settings.dob) ?? 16;
      // _genderLocal = (widget.settings.gender == 'female') ? 'female' : 'male';
      _isShiongVocLocal = widget.settings.isShiongVoc;
      _isEdited = false;
    });
  }

  int? _deriveAgeFromDob(DateTime? dob) {
    if (dob == null) return null;
    final now = DateTime.now();
    int years = now.year - dob.year;
    final hadBirthdayThisYear =
        (now.month > dob.month) ||
        (now.month == dob.month && now.day >= dob.day);
    if (!hadBirthdayThisYear) years -= 1;
    return years.clamp(0, 120);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Collapsible card at the top
                        Card(
                          child: ExpansionTile(
                            shape: Border.all(color: Colors.transparent),
                            title: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Parameters',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  16,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Age',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                      tooltip: 'Decrease age',
                                      onPressed: () {
                                        setState(() {
                                          final minAge = _ageOptions.first;
                                          _age = (_age - 1).clamp(
                                            minAge,
                                            _ageOptions.last,
                                          );
                                          _isEdited = true;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 4),
                                    DropdownButton<int>(
                                      value: _age,
                                      items: _ageOptions
                                          .map(
                                            (a) => DropdownMenuItem<int>(
                                              value: a,
                                              child: Text('$a'),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) {
                                        if (val == null) return;
                                        setState(() {
                                          _age = val;
                                          _isEdited = true;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      tooltip: 'Increase age',
                                      onPressed: () {
                                        setState(() {
                                          final maxAge = _ageOptions.last;
                                          _age = (_age + 1).clamp(
                                            _ageOptions.first,
                                            maxAge,
                                          );
                                          _isEdited = true;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Gender selector (disabled for now)
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              //   child: Row(
                              //     children: [
                              //       Text('Gender', style: Theme.of(context).textTheme.bodyLarge),
                              //       const Spacer(),
                              //       ToggleButtons(
                              //         isSelected: [
                              //           _genderLocal == 'male',
                              //           _genderLocal == 'female',
                              //         ],
                              //         onPressed: (index) {
                              //           setState(() {
                              //             _genderLocal = index == 0 ? 'male' : 'female';
                              //             _isEdited = true;
                              //           });
                              //         },
                              //         borderRadius: BorderRadius.circular(8),
                              //         children: const [
                              //           Padding(
                              //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              //             child: Text('Male'),
                              //           ),
                              //           Padding(
                              //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              //             child: Text('Female'),
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Shiong vocation switch (local only)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Commando, NDU or Guards?',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ),
                                    Switch(
                                      value: _isShiongVocLocal,
                                      onChanged: (val) {
                                        setState(() {
                                          _isShiongVocLocal = val;
                                          _isEdited = true;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    if (_isEdited)
                                      Chip(
                                        label: const Text('Edited'),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.tertiaryContainer,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onTertiaryContainer,
                                            ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 0,
                                        ),
                                      ),
                                    const Spacer(),
                                    OutlinedButton.icon(
                                      onPressed: _resetParameters,
                                      icon: const Icon(Icons.restart_alt),
                                      label: const Text('Reset'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // IPPT Score Calculator Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calculate,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'IPPT Score Calculator',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Push-up Slider
                                Text(
                                  'Push-ups: ${_pushUpValue.toInt()}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Slider(
                                  value: _pushUpValue,
                                  min: 0,
                                  max: 60,
                                  divisions: 60,
                                  label: _pushUpValue.toInt().toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      _pushUpValue = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Sit-up Slider
                                Text(
                                  'Sit-ups: ${_sitUpValue.toInt()}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Slider(
                                  value: _sitUpValue,
                                  min: 0,
                                  max: 60,
                                  divisions: 60,
                                  label: _sitUpValue.toInt().toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      _sitUpValue = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                // 2.4km Run Slider
                                Text(
                                  '2.4km Run: ${_runValue.toInt()} minutes',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Slider(
                                  value: _runValue,
                                  min: 8,
                                  max: 20,
                                  divisions: 120,
                                  label: '${_runValue.toStringAsFixed(1)} min',
                                  onChanged: (value) {
                                    setState(() {
                                      _runValue = value;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 120,
                                ), // Spacer so bottom bar does not overlap content
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildScoreBar(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScoreBar(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Material(
        elevation: 6,
        color: scheme.surface,
        shadowColor: Colors.black26,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: scheme.outlineVariant)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Progress takes the most space
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IPPT Score',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _score / 100.0,
                        minHeight: 8,
                        backgroundColor: scheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Score value
              Text(
                '$_scoreInt/100',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 12),
              // Award chip
              _buildAwardChip(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAwardChip(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    Color background;
    Color foreground = scheme.onPrimary;

    switch (_award) {
      case 'gold':
        background = Colors.amber.shade600;
        break;
      case 'silver':
        background = Colors.blueGrey.shade300;
        foreground = Colors.black87;
        break;
      case 'pass':
        background = Colors.green.shade600;
        break;
      default:
        background = scheme.error;
        foreground = scheme.onError;
        break;
    }

    return Chip(
      label: Text(_award.toUpperCase()),
      backgroundColor: background,
      labelStyle: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: foreground),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _CounterTab extends StatelessWidget {
  final AppSettings settings;

  const _CounterTab({required this.settings});

  @override
  Widget build(BuildContext context) {
    final DateTime? ordDate = settings.ordDate;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final int? daysToOrd = ordDate == null
        ? null
        : DateTime(
            ordDate.year,
            ordDate.month,
            ordDate.day,
          ).difference(today).inDays.clamp(-999999, 999999);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (ordDate == null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Set your ORD date in Settings to see the countdown.',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        )
                      else ...[
                        Text(
                          'Days until ORD',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${daysToOrd! < 0 ? 0 : daysToOrd}',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      Card(
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Icon(
                                Icons.touch_app,
                                size: 48,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'ORD Countdown',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ordDate == null
                                    ? 'No ORD date set. Go to Settings to configure your ORD date.'
                                    : 'Counting down the days until your ORD date.',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
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
}
