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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _settings = AppSettings();
    _appController = AppController(settings: _settings);
    _counter = Counter();
    _counterController = CounterController(counter: _counter);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load persisted counter value
    await _counter.load();
    // Load persisted settings
    await _appController.initializeSettings();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

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
