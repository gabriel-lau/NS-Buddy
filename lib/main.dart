import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:ns_buddy/data/datasources/shared_preference_data_source.dart';
import 'package:ns_buddy/data/repositories/settings_repository_impl.dart';
import 'package:ns_buddy/data/repositories/user_info_repository_impl.dart';
import 'package:ns_buddy/domain/entities/settings_entity.dart';
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/domain/usecases/settings_usecases_impl.dart';
import 'package:ns_buddy/domain/usecases/user_info_usecases_impl.dart';
import 'package:ns_buddy/presentation/viewmodels/temp_view_model.dart';
import 'presentation/views/home_view.dart';
import 'presentation/views/onboarding_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late final AppSettings _settings;
  // late final AppController _appController;

  late final SharedPreferenceDataSource _localDataSource =
      SharedPreferenceDataSource();
  late final SettingsUsecases settingsUsecases; // Assume initialized elsewhere
  late final UserInfoUsecases userInfoUsecases; // Assume initialized elsewhere
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // _settings = AppSettings();
    // _appController = AppController(settings: _settings);

    settingsUsecases = SettingsUsecasesImpl(
      SettingsRepositoryImpl(_localDataSource),
    );
    userInfoUsecases = UserInfoUsecasesImpl(
      UserInfoRepositoryImpl(_localDataSource),
    );
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load persisted settings
    // await _appController.initializeSettings();
    await settingsUsecases.retrieveSettings();
    await userInfoUsecases.retrieveUserInfo();

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

    // return AnimatedBuilder(
    //   animation: _settings,
    //   builder: (context, _) {
    //     return DynamicColorBuilder(
    //       builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    //         return MaterialApp(
    //           title: 'NS Buddy',
    //           theme: _appController.buildLightTheme(
    //             dynamicScheme: lightDynamic,
    //           ),
    //           darkTheme: _appController.buildDarkTheme(
    //             dynamicScheme: darkDynamic,
    //           ),
    //           themeMode: _appController.themeMode,
    //           home: _settings.hasCompletedOnboarding
    //               ? HomeView(appController: _appController)
    //               : OnboardingView(appController: _appController),
    //         );
    //       },
    //     );
    //   },
    // );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserInfoUsecases>(
          create: (_) => userInfoUsecases,
        ),
        ChangeNotifierProvider<SettingsUsecases>(
          create: (_) => settingsUsecases,
        ),
      ],
      child: MaterialApp(
        title: 'NS Buddy',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: HomeView(),
      ),
    );
  }
}
