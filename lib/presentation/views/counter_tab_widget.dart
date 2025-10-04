import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/presentation/viewmodels/counter_tab_viewmodel.dart';
import 'package:provider/provider.dart';

class CounterTabWidget extends StatelessWidget {
  const CounterTabWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<UserInfoUsecases, CounterTabViewModel>(
      create: (context) =>
          CounterTabViewModel(context.read<UserInfoUsecases>()),
      update: (context, userInfoUsecases, previous) => previous!..updateView(),
      child: _CounterTabWidgetContent(),
    );
  }
}

class _CounterTabWidgetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counterTabViewModel = context.watch<CounterTabViewModel>();
    // final counterTabViewModel = Provider.of<CounterTabViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    if (counterTabViewModel.ordDate == null ||
                        counterTabViewModel.enlistmentDate == null)
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
                                      counterTabViewModel.enlistmentDate == null
                                          ? 'No enlistment date set. Go to Settings to configure your enlistment date.'
                                          : counterTabViewModel.ordDate == null
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
                              value: counterTabViewModel.percentElapsed,
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
                                counterTabViewModel.remainingDays == null
                                    ? 'N/A'
                                    : '${counterTabViewModel.remainingDays!.abs()}',
                                style: Theme.of(context).textTheme.displaySmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                counterTabViewModel.remainingDays == null
                                    ? 'No ORD date set'
                                    : counterTabViewModel.remainingDays! < 0
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
                                        counterTabViewModel.percentElapsed !=
                                                null
                                            ? '${(counterTabViewModel.percentElapsed! * 100).toStringAsFixed(1)}%'
                                            : 'N/A',
                                        Icons.percent,
                                      ),
                                      // Enlistment Date
                                      _buildGridItem(
                                        context,
                                        'Enlisted On',
                                        counterTabViewModel.enlistmentDate !=
                                                null
                                            ? counterTabViewModel.formatDate(
                                                counterTabViewModel
                                                    .enlistmentDate,
                                              )
                                            : 'Not set',
                                        Icons.military_tech,
                                      ),
                                      // ORD Date
                                      _buildGridItem(
                                        context,
                                        'ORD Date',
                                        counterTabViewModel.formatDate(
                                          counterTabViewModel.ordDate,
                                        ),
                                        Icons.celebration,
                                      ),
                                      // Days Since Enlistment
                                      _buildGridItem(
                                        context,
                                        'Days Served',
                                        counterTabViewModel.elapsedDays != null
                                            ? '${counterTabViewModel.elapsedDays} days'
                                            : 'N/A',
                                        Icons.calendar_today,
                                      ),
                                      // Weekdays Left
                                      _buildGridItem(
                                        context,
                                        'Weekdays Left',
                                        counterTabViewModel
                                            .calculateWeekdaysLeft(
                                              counterTabViewModel.today,
                                              counterTabViewModel.ordDate,
                                            )
                                            .toString(),
                                        Icons.work,
                                      ),
                                      // Weekends Left
                                      _buildGridItem(
                                        context,
                                        'Weekends Left',
                                        counterTabViewModel
                                            .calculateWeekendsLeft(
                                              counterTabViewModel.today,
                                              counterTabViewModel.ordDate,
                                            )
                                            .toString(),
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
}
