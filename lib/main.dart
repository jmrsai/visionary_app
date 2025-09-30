import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const OculusApp());
}

class OculusApp extends StatelessWidget {
  const OculusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'visionary - Eye Health Companion',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: appState.showOnboarding 
                ? const OnboardingScreen()
                : const MainNavigationScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
