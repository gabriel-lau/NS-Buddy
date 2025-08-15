import 'package:flutter/material.dart';
import 'controllers/app_controller.dart';
import 'controllers/counter_controller.dart';
import 'models/app_settings.dart';
import 'models/counter.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppSettings _settings;
  late final AppController _appController;
  late final Counter _counter;
  late final CounterController _counterController;

  @override
  void initState() {
    super.initState();
    _settings = AppSettings();
    _appController = AppController(settings: _settings);
    _counter = Counter();
    _counterController = CounterController(counter: _counter);
    // Load persisted counter value
    _counter.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settings,
      builder: (context, _) {
        return MaterialApp(
          title: 'NS Buddy',
          theme: _appController.buildLightTheme(),
          darkTheme: _appController.buildDarkTheme(),
          themeMode: _appController.themeMode,
          home: HomeView(
            appController: _appController,
            counterController: _counterController,
          ),
        );
      },
    );
  }
}
