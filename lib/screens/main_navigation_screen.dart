import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visionary/screens/ai_health_chatbot_screen.dart';
import 'package:visionary/screens/dashboard_screen.dart';
import 'package:visionary/screens/exercises_screen.dart';
import 'package:visionary/screens/profile_screen.dart';
import 'package:visionary/screens/vision_tests_screen.dart';
import 'package:visionary/screens/sports_vision_screen.dart' as sports_vision;
import 'package:visionary/screens/squint_assessment_screen.dart' as squint_assessment;
import 'package:visionary/screens/disease_detection_screen.dart' as disease_detection;
import 'package:visionary/screens/kids_zone_screen.dart' as kids_zone;
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const DashboardScreen(),
    const VisionTestsScreen(),
    const ExercisesScreen(),
    const AIHealthChatbotScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    context.read<AppStateProvider>().setCurrentNavIndex(index);
  }

  void _onNavItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final viewType = appState.currentView;

    Widget currentScreen;
    switch (viewType) {
      case ViewType.dashboard:
        currentScreen = _screens[appState.currentNavIndex];
        break;
      case ViewType.symptomChecker:
        currentScreen = const AIHealthChatbotScreen();
        break;
      case ViewType.visionTests:
        currentScreen = const VisionTestsScreen();
        break;
      case ViewType.exercises:
        currentScreen = const ExercisesScreen();
        break;
      case ViewType.sportsVision:
        currentScreen = const sports_vision.SportsVisionScreen();
        break;
      case ViewType.squintAssessment:
        currentScreen = const squint_assessment.SquintAssessmentScreen();
        break;
      case ViewType.diseaseDetection:
        currentScreen = const disease_detection.DiseaseDetectionScreen();
        break;
      case ViewType.kidsZone:
        currentScreen = const kids_zone.KidsZoneScreen();
        break;
      case ViewType.profile:
        currentScreen = const ProfileScreen();
        break;
      default:
        currentScreen = _screens[appState.currentNavIndex];
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
        // physics: const NeverScrollableScrollPhysics(), // Optional: to disable swipe
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, appState),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, AppStateProvider appState) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).bottomNavigationBarTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValue(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: appState.currentNavIndex,
          onTap: _onNavItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility),
              label: 'Tests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: 'AI Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}