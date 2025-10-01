import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ns_buddy/domain/entities/user_info_entity.dart';
import 'package:ns_buddy/presentation/viewmodels/temp_view_model.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'settings_view.dart';

class HomeView extends StatelessWidget {
  // final AppController appController;

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final tempViewModel = Provider.of<TempViewModel>(context);
    return AnimatedBuilder(
      animation: tempViewModel,
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
                      MaterialPageRoute(builder: (context) => SettingsView()),
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
                _IPPTTab(settings: tempViewModel.userInfo),
                _CounterTab(settings: tempViewModel.userInfo),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _IPPTTab extends StatefulWidget {
  final UserInfoEntity settings;

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
      // If DateTime.now() is still between enlistment date and ORD date, assume NSF
      _isNSF =
          widget.settings.enlistmentDate != null &&
          widget.settings.ordDate != null &&
          DateTime.now().isAfter(widget.settings.enlistmentDate!) &&
          DateTime.now().isBefore(widget.settings.ordDate!);
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
              _buildScoreBar(context),
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
  final UserInfoEntity settings;

  const _CounterTab({required this.settings});

  // Helper method to format a date as DD MMM YYYY
  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  // Helper method to calculate weekdays left
  int _calculateWeekdaysLeft(DateTime from, DateTime? to) {
    if (to == null) return 0;
    int weekdaysCount = 0;
    DateTime current = DateTime(from.year, from.month, from.day);

    while (current.isBefore(to) || current.isAtSameMomentAs(to)) {
      // Weekdays are Monday (1) to Friday (5)
      if (current.weekday >= 1 && current.weekday <= 5) {
        weekdaysCount++;
      }
      current = current.add(const Duration(days: 1));
    }

    return weekdaysCount;
  }

  // Helper method to calculate weekends left
  int _calculateWeekendsLeft(DateTime from, DateTime? to) {
    if (to == null) return 0;
    int weekendsCount = 0;
    DateTime current = DateTime(from.year, from.month, from.day);

    while (current.isBefore(to) || current.isAtSameMomentAs(to)) {
      // Weekends are Saturday (6) and Sunday (7)
      if (current.weekday == 6 || current.weekday == 7) {
        weekendsCount++;
      }
      current = current.add(const Duration(days: 1));
    }

    return weekendsCount;
  }

  // Helper method to build a grid item
  Widget _buildGridItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? ordDate = settings.ordDate;
    final DateTime? enlistmentDate = settings.enlistmentDate;
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    // Calculate percentage elapsed from enlistment to ORD
    double? percentElapsed = 0;
    int? totalDays;
    int? elapsedDays;
    int? remainingDays;
    if (ordDate != null && enlistmentDate != null) {
      totalDays = ordDate.difference(enlistmentDate).inDays;
      elapsedDays = today.difference(enlistmentDate).inDays;
      remainingDays = ordDate.difference(today).inDays;
      percentElapsed = totalDays > 0
          ? (elapsedDays.clamp(0, totalDays) / totalDays)
          : null;
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (ordDate == null || enlistmentDate == null)
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              color: Theme.of(
                                context,
                              ).colorScheme.tertiaryContainer,
                              margin: const EdgeInsets.all(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.numbers,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'ORD Countdown',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      enlistmentDate == null
                                          ? 'No enlistment date set. Go to Settings to configure your enlistment date.'
                                          : ordDate == null
                                          ? 'No ORD date set. Go to Settings to configure your ORD date.'
                                          : 'Counting down the days until your ORD date.',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    // Circular indicator for percentage elapsed
                    SizedBox(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 300,
                            width: 300,
                            child: CircularProgressIndicator(
                              padding: const EdgeInsets.all(8),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                remainingDays == null
                                    ? 'N/A'
                                    : '${remainingDays.abs()}',
                                style: Theme.of(context).textTheme.displaySmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                remainingDays == null
                                    ? 'No ORD date set'
                                    : remainingDays < 0
                                    ? 'days since ORD'
                                    : 'remaining days',
                                style: Theme.of(context).textTheme.titleLarge
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
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            margin: const EdgeInsets.all(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.numbers,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'ORD Countdown',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Grid for ORD countdown stats
                                  GridView.count(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 3,
                                    childAspectRatio: 2,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    children: [
                                      // Percentage Done
                                      _buildGridItem(
                                        context,
                                        'Completed',
                                        percentElapsed != null
                                            ? '${(percentElapsed * 100).toStringAsFixed(1)}%'
                                            : 'N/A',
                                        Icons.percent,
                                      ),
                                      // Enlistment Date
                                      _buildGridItem(
                                        context,
                                        'Enlisted On',
                                        enlistmentDate != null
                                            ? _formatDate(enlistmentDate)
                                            : 'Not set',
                                        Icons.military_tech,
                                      ),
                                      // ORD Date
                                      _buildGridItem(
                                        context,
                                        'ORD Date',
                                        _formatDate(ordDate),
                                        Icons.celebration,
                                      ),
                                      // Days Since Enlistment
                                      _buildGridItem(
                                        context,
                                        'Days Served',
                                        elapsedDays != null
                                            ? '$elapsedDays days'
                                            : 'N/A',
                                        Icons.calendar_today,
                                      ),
                                      // Weekdays Left
                                      _buildGridItem(
                                        context,
                                        'Weekdays Left',
                                        _calculateWeekdaysLeft(
                                          today,
                                          ordDate,
                                        ).toString(),
                                        Icons.work,
                                      ),
                                      // Weekends Left
                                      _buildGridItem(
                                        context,
                                        'Weekends Left',
                                        _calculateWeekendsLeft(
                                          today,
                                          ordDate,
                                        ).toString(),
                                        Icons.weekend,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
