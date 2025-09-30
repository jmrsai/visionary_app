import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visionary/firebase_options.dart';
import 'package:visionary/providers/app_state_provider.dart';
import 'package:visionary/providers/auth_provider.dart';
import 'package:visionary/screens/ai_health_chatbot_screen.dart';
import 'package:visionary/screens/email_link_screen.dart';
import 'package:visionary/screens/exercises_screen.dart';
import 'package:visionary/screens/home_screen.dart';
import 'package:visionary/screens/link_auth_handler_screen.dart';
import 'package:visionary/screens/login_screen.dart';
import 'package:visionary/screens/onboarding_screen.dart';
import 'package:visionary/screens/phone_auth_screen.dart';
import 'package:visionary/screens/symptom_checker_screen.dart';
import 'package:visionary/screens/strain_reduction_screen.dart';
import 'package:visionary/screens/vision_tests_screen.dart';
import 'package:visionary/services/background_service.dart';
import 'package:visionary/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await BackgroundServiceManager.initializeService();
  runApp(const VisionaryApp());
}

class VisionaryApp extends StatefulWidget {
  const VisionaryApp({super.key});

  @override
  State<VisionaryApp> createState() => _VisionaryAppState();
}

class _VisionaryAppState extends State<VisionaryApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initDynamicLinks();
  }

  Future<void> _initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      final Uri deepLink = dynamicLink.link;
      if (deepLink.path == '/finishSignUp') {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => LinkAuthHandlerScreen(link: deepLink.toString()),
          ),
        );
      }
    }).onError((error) {
      debugPrint('onLink error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Visionary - Eye Health Companion',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: _getHomeScreen(auth),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
              '/symptom-checker': (context) => const SymptomCheckerScreen(),
              '/vision-tests': (context) => const VisionTestsScreen(),
              '/exercises': (context) => const ExercisesScreen(),
              '/ai-chatbot': (context) => const AIHealthChatbotScreen(),
              '/phone-auth': (context) => const PhoneAuthScreen(),
              '/email-link-auth': (context) => const EmailLinkScreen(),
              '/strain-reduction': (context) => const StrainReductionScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  Widget _getHomeScreen(AuthProvider auth) {
    return FutureBuilder<PendingDynamicLinkData?>(
      future: FirebaseDynamicLinks.instance.getInitialLink(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final Uri? deepLink = snapshot.data?.link;
        if (deepLink != null && deepLink.path == '/finishSignUp') {
          return LinkAuthHandlerScreen(link: deepLink.toString());
        }

        if (auth.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (auth.isAuthenticated || auth.isAnonymous) {
          return auth.hasCompletedOnboarding ? const HomeScreen() : const OnboardingScreen();
        }
        
        return const LoginScreen();
      },
    );
  }
}
