import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:ns_buddy/app_theme.dart';
import 'package:ns_buddy/data/datasources/shared_preference_datasource.dart';
import 'package:ns_buddy/data/repositories/settings_repository_impl.dart';
import 'package:ns_buddy/data/repositories/user_info_repository_impl.dart';
import 'package:ns_buddy/domain/interfaces/settings_usecases.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/domain/usecases/settings_usecases_impl.dart';
import 'package:ns_buddy/domain/usecases/user_info_usecases_impl.dart';
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
  late final SharedPreferenceDataSource _localDataSource =
      SharedPreferenceDataSource();
  late final SettingsUsecases settingsUsecases; // Assume initialized elsewhere
  late final UserInfoUsecases userInfoUsecases; // Assume initialized elsewhere
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load persisted settings
    settingsUsecases = SettingsUsecasesImpl(
      SettingsRepositoryImpl(_localDataSource),
    );
    userInfoUsecases = UserInfoUsecasesImpl(
      UserInfoRepositoryImpl(_localDataSource),
    );
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
      return DynamicColorBuilder(
        builder: (light, dark) {
          return MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
            theme: ThemeData(
              useMaterial3: true,
              colorScheme:
                  light ??
                  ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.light,
                  ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme:
                  dark ??
                  ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.dark,
                  ),
            ),
          );
        },
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserInfoUsecases>(
          create: (_) => userInfoUsecases,
        ),
        ChangeNotifierProvider<SettingsUsecases>(
          create: (_) => settingsUsecases,
        ),
      ],
      child: AnimatedBuilder(
        animation: settingsUsecases,
        builder: (context, _) {
          final appTheme = AppTheme(settingsUsecases);
          return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              return MaterialApp(
                title: 'NS Buddy',
                theme: lightDynamic != null
                    ? appTheme.buildLightTheme(dynamicScheme: lightDynamic)
                    : appTheme.buildLightTheme(
                        dynamicScheme: ColorScheme.fromSeed(
                          seedColor: appTheme.primarySwatch,
                          brightness: Brightness.light,
                        ),
                      ),
                darkTheme: darkDynamic != null
                    ? appTheme.buildDarkTheme(dynamicScheme: darkDynamic)
                    : appTheme.buildDarkTheme(
                        dynamicScheme: ColorScheme.fromSeed(
                          seedColor: appTheme.primarySwatch,
                          brightness: Brightness.dark,
                        ),
                      ),
                themeMode: appTheme.themeMode,
                home:
                    userInfoUsecases.userInfoEntity != null &&
                        userInfoUsecases.userInfoEntity!.hasCompletedOnboarding
                    ? HomeView()
                    : OnboardingView(),
              );
            },
          );
        },
      ),
    );
  }
}
