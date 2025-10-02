import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/presentation/viewmodels/counter_tab_viewmodel.dart';
import 'package:provider/provider.dart';

class CounterTabWidget extends StatelessWidget {
  const CounterTabWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterTabViewModel(context.read<UserInfoUsecases>()),
      child: _CounterTabWidgetContent(),
    );
  }
}

class _CounterTabWidgetContent extends StatelessWidget {
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
    final counterTabViewModel = context.watch<CounterTabViewModel>();
    final userInfo = counterTabViewModel.userInfoEntity;
    final DateTime? ordDate = userInfo.ordDate;
    final DateTime? enlistmentDate = userInfo.enlistmentDate;
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
