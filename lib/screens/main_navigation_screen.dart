import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'vision_tests_screen.dart';
import 'exercises_screen.dart';
import 'ai_chatbot_screen.dart';
import 'profile_screen.dart';
import 'symptom_checker_screen.dart';
import 'sports_vision_screen.dart';
import 'squint_assessment_screen.dart';
import 'disease_detection_screen.dart';
import 'kids_zone_screen.dart';
import '../app_routes.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.setNavIndex(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildCurrentView(ViewType viewType) {
    switch (viewType) {
      case ViewType.dashboard:
        return const DashboardScreen();
      case ViewType.symptomChecker:
        return const SymptomCheckerScreen();
      case ViewType.aiChatbot:
        return const AIChatbotScreen();
      case ViewType.visionTests:
        return const VisionTestsScreen();
      case ViewType.exercises:
        return const ExercisesScreen();
      case ViewType.sportsVision:
        return const SportsVisionScreen();
      case ViewType.squintAssessment:
        return const SquintAssessmentScreen();
      case ViewType.diseaseDetection:
        return const DiseaseDetectionScreen();
      case ViewType.kidsZone:
        return const KidsZoneScreen();
      case ViewType.profile:
        return const ProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        // Handle non-main navigation views
        if (!_isMainNavView(appState.currentView)) {
          return _buildCurrentView(appState.currentView);
        }

        return MaterialApp(
          routes: AppRoutes.routes,
          home: Scaffold(
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                appState.setNavIndex(index);
              },
              children: const [
                DashboardScreen(),
                VisionTestsScreen(),
                ExercisesScreen(),
                AIChatbotScreen(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: _buildBottomNavBar(appState),
          ),
        );
      },
    );
  }

  bool _isMainNavView(ViewType viewType) {
    return const [
      ViewType.dashboard,
      ViewType.visionTests,
      ViewType.exercises,
      ViewType.aiChatbot,
      ViewType.profile,
    ].contains(viewType);
  }

  Widget _buildBottomNavBar(AppStateProvider appState) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                isSelected: appState.selectedNavIndex == 0,
                onTap: () => _onNavTap(0),
                isDark: isDark,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.visibility_outlined,
                activeIcon: Icons.visibility,
                label: 'Tests',
                isSelected: appState.selectedNavIndex == 1,
                onTap: () => _onNavTap(1),
                isDark: isDark,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.fitness_center_outlined,
                activeIcon: Icons.fitness_center,
                label: 'Exercise',
                isSelected: appState.selectedNavIndex == 2,
                onTap: () => _onNavTap(2),
                isDark: isDark,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.psychology_outlined,
                activeIcon: Icons.psychology,
                label: 'AI Chat',
                isSelected: appState.selectedNavIndex == 3,
                onTap: () => _onNavTap(3),
                isDark: isDark,
              ),
              _buildNavItem(
                context: context,
                index: 4,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isSelected: appState.selectedNavIndex == 4,
                onTap: () => _onNavTap(4),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final activeColor = isDark ? AppTheme.accentGreen : AppTheme.primaryBlue;
    final inactiveColor = isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey('$index-$isSelected'),
                color: isSelected ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: theme.textTheme.labelSmall!.copyWith(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    ).animate(target: isSelected ? 1 : 0).scale(
      begin: const Offset(1.0, 1.0),
      end: const Offset(1.1, 1.1),
      duration: 200.ms,
      curve: Curves.easeInOut,
    );
  }
}