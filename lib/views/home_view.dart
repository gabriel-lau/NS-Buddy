import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../controllers/counter_controller.dart';
import 'settings_view.dart';

class HomeView extends StatelessWidget {
  final AppController appController;
  final CounterController counterController;

  const HomeView({
    super.key,
    required this.appController,
    required this.counterController,
  });

  @override
  Widget build(BuildContext context) {
    final settings = appController.settings;
    return AnimatedBuilder(
      animation: Listenable.merge([settings, counterController.counter]),
      builder: (context, _) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              elevation: 0,
              title: const Text('Flutter Demo Home Page'),
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
                _IPPTTab(),
                _CounterTab(counterController: counterController),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _IPPTTab extends StatefulWidget {
  const _IPPTTab();

  @override
  State<_IPPTTab> createState() => _IPPTTabState();
}

class _IPPTTabState extends State<_IPPTTab> {
  double _pushUpValue = 0;
  double _sitUpValue = 0;
  double _runValue = 8;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Collapsible card at the top
                    Card(
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'IPPT Information',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Information content will be added here.',
                              style: TextStyle(fontStyle: FontStyle.italic),
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
                                  color: Theme.of(context).colorScheme.primary,
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
    );
  }
}

class _CounterTab extends StatelessWidget {
  final CounterController counterController;

  const _CounterTab({required this.counterController});

  @override
  Widget build(BuildContext context) {
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
                      Text(
                        'You have pushed the button this many times:',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${counterController.value}',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
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
                                'Counter Tab',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Use the floating action button to increment the counter. The value is persisted using shared_preferences.',
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
      floatingActionButton: FloatingActionButton(
        onPressed: counterController.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
