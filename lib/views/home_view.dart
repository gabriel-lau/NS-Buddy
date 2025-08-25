import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert' as convert;
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
  double _runValue = 20 * 60;

  Map<String, dynamic>?
  _ipptData; // Loaded from lib/assets/ippt_score_chart.json

  // Local, non-persisted age state
  late int _age = 16;
  final List<int> _ageOptions = List<int>.generate(45, (i) => 16 + i); // 16..60

  // Local, non-persisted gender state (disabled for now)
  // late String _genderLocal = 'male';

  // Local, non-persisted Shiong vocation
  late bool _isShiongVocLocal = false;

  late bool _isNSF = true;

  // Tracks if any parameter in the collapsible card was edited by the user
  bool _isEdited = false;

  int get _pushPoints {
    if (_ipptData == null) return 0;
    final String ageGroup = _getAgeGroup(_age);
    final int pushUps = _pushUpValue.round().clamp(0, 60);
    return _pointsForReps('push_up', pushUps, ageGroup);
  }

  int get _sitPoints {
    if (_ipptData == null) return 0;
    final String ageGroup = _getAgeGroup(_age);
    final int sitUps = _sitUpValue.round().clamp(0, 60);
    return _pointsForReps('sit_up', sitUps, ageGroup);
  }

  int get _runPoints {
    if (_ipptData == null) return 0;
    final String ageGroup = _getAgeGroup(_age);
    final int runSeconds = _runValue.round().clamp(8 * 60, 18 * 60 + 30);
    return _pointsForRun(runSeconds, ageGroup);
  }

  int get _score => _pushPoints + _sitPoints + _runPoints;

  String get _award {
    if (_score < 50) return 'fail';
    if (_score < 60) return 'pass';
    if (_score < 75 && !_isNSF) return 'pass (incentive)';
    if (_score < 75 && _isNSF) return 'pass';
    if (_score < 85 && !_isShiongVocLocal) return 'silver';
    if (_score < 90 && _isShiongVocLocal) return 'silver';
    return 'gold';
  }

  @override
  void initState() {
    super.initState();
    _resetParameters();
    _loadIpptJson();
  }

  void _resetParameters() {
    setState(() {
      _age = _deriveAgeFromDob(widget.settings.dob) ?? 16;
      // _genderLocal = (widget.settings.gender == 'female') ? 'female' : 'male';
      _isShiongVocLocal = widget.settings.isShiongVoc;
      _isNSF = widget.settings.isNSF;
      _isEdited = false;
    });
  }

  Future<void> _loadIpptJson() async {
    try {
      final String jsonStr = await rootBundle.loadString(
        'lib/assets/ippt_score_chart.json',
      );
      final Map<String, dynamic> data = convert.jsonDecode(jsonStr);
      setState(() {
        _ipptData = data;
      });
    } catch (e) {
      // If asset missing or malformed, keep score at 0
      debugPrint('Failed to load IPPT JSON: $e');
    }
  }

  String _getAgeGroup(int age) {
    if (age < 22) return '<22';
    if (age <= 24) return '22-24';
    if (age <= 27) return '25-27';
    if (age <= 30) return '28-30';
    if (age <= 33) return '31-33';
    if (age <= 36) return '34-36';
    if (age <= 39) return '37-39';
    if (age <= 42) return '40-42';
    if (age <= 45) return '43-45';
    if (age <= 48) return '46-48';
    if (age <= 51) return '49-51';
    if (age <= 54) return '52-54';
    if (age <= 57) return '55-57';
    return '58-60';
  }

  int _pointsForReps(String category, int reps, String ageGroup) {
    final Map<String, dynamic>? scoring =
        _ipptData?['ippt']?[category]?['scoring'] as Map<String, dynamic>?;
    if (scoring == null) return 0;
    final Map<String, dynamic>? row = scoring['$reps'] as Map<String, dynamic>?;
    if (row == null) return 0;
    final dynamic value = row[ageGroup];
    if (value is int) return value;
    return 0;
  }

  int _pointsForRun(int runSeconds, String ageGroup) {
    final Map<String, dynamic>? runTable =
        _ipptData?['ippt']?['run_2_4km']?['scoring'] as Map<String, dynamic>?;
    if (runTable == null) return 0;

    int parseTimeToSeconds(String mmss) {
      final parts = mmss.split(':');
      if (parts.length != 2) return 0;
      final int m = int.tryParse(parts[0]) ?? 0;
      final int s = int.tryParse(parts[1]) ?? 0;
      return m * 60 + s;
    }

    // Build sorted list of bucket seconds
    final List<int> buckets =
        runTable.keys.map((k) => parseTimeToSeconds(k)).toList()..sort();

    // Choose the smallest bucket that is >= user's time (conservative rounding)
    int chosen = buckets.last;
    for (final b in buckets) {
      if (runSeconds <= b) {
        chosen = b;
        break;
      }
    }

    String formatSeconds(int secs) {
      final int m = secs ~/ 60;
      final int s = secs % 60;
      final String ss = s.toString().padLeft(2, '0');
      return '$m:$ss';
    }

    final Map<String, dynamic>? row =
        runTable[formatSeconds(chosen)] as Map<String, dynamic>?;
    if (row == null) return 0;
    final dynamic value = row[ageGroup];
    if (value is int) return value;
    return 0;
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
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                                        'Commando, NDU or Guards',
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
                                        'NSF',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ),
                                    Switch(
                                      value: _isNSF,
                                      onChanged: (val) {
                                        setState(() {
                                          _isNSF = val;
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
                                Row(
                                  children: [
                                    Text(
                                      'Push-ups: ${_pushUpValue.toInt()}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    Spacer(),
                                    Text('$_pushPoints Points'),
                                  ],
                                ),
                                Slider(
                                  value: _pushUpValue,
                                  min: 0,
                                  max: 60,
                                  divisions: 60,
                                  onChanged: (value) {
                                    setState(() {
                                      _pushUpValue = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Sit-up Slider
                                Row(
                                  children: [
                                    Text(
                                      'Sit-ups: ${_sitUpValue.toInt()} ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    Spacer(),
                                    Text('$_sitPoints Points'),
                                  ],
                                ),
                                Slider(
                                  value: _sitUpValue,
                                  min: 0,
                                  max: 60,
                                  divisions: 60,
                                  onChanged: (value) {
                                    setState(() {
                                      _sitUpValue = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                // 2.4km Run Slider
                                Row(
                                  children: [
                                    Text(
                                      '2.4km: ${(_runValue / 60).toInt()} mins ${(_runValue % 60).toInt()} sec',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    Spacer(),
                                    Text('$_runPoints Points'),
                                  ],
                                ),

                                Slider(
                                  value: _runValue,
                                  min: 8 * 60,
                                  max: 20 * 60,
                                  divisions: 72,
                                  onChanged: (value) {
                                    setState(() {
                                      _runValue = value;
                                    });
                                  },
                                ),
                                // const SizedBox(
                                //   height: 120,
                                // ), // Spacer so bottom bar does not overlap content
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '$_score Points',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  _buildAwardChip(context),
                ],
              ),
              const SizedBox(height: 6),
              // Progress takes the most space
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            semanticsLabel: _score.toString(),
                            value: _score / 100.0,
                            minHeight: 8,
                            backgroundColor: scheme.surfaceContainerHighest,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Award chip
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
      case 'pass (incentive)':
        background = Colors.green.shade600;
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
    final DateTime? enlistmentDate = settings.enlistmentDate;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final int? daysToOrd = ordDate == null
        ? null
        : DateTime(
            ordDate.year,
            ordDate.month,
            ordDate.day,
          ).difference(today).inDays.clamp(-999999, 999999);

    // Calculate percentage elapsed from enlistment to ORD
    double? percentElapsed;
    int? totalDays;
    int? elapsedDays;
    if (ordDate != null && enlistmentDate != null) {
      totalDays = ordDate.difference(enlistmentDate).inDays;
      elapsedDays = today.difference(enlistmentDate).inDays;
      percentElapsed = totalDays > 0
          ? (elapsedDays.clamp(0, totalDays) / totalDays)
          : null;
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: <Widget>[
                    if (ordDate != null) ...[
                      const SizedBox(height: 16),
                      // Circular indicator for percentage elapsed
                      if (enlistmentDate != null && percentElapsed != null)
                        SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 300,
                                width: 300,
                                child: CircularProgressIndicator(
                                  value: percentElapsed,
                                  strokeWidth: 10,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(percentElapsed * 100).toStringAsFixed(1)}%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${elapsedDays ?? 0} / ${totalDays ?? 0} days',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),
                    ],
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
            );
          },
        ),
      ),
    );
  }
}
