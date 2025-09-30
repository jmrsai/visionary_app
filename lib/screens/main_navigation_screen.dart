import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visionary/screens/ai_health_chatbot_screen.dart';
import 'package:visionary/screens/dashboard_screen.dart';
import 'package:visionary/screens/exercises_screen.dart';
import 'package:visionary/screens/profile_screen.dart';
import 'package:visionary/screens/vision_tests_screen.dart';
import '../providers/app_state_provider.dart';

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
    final theme = Theme.of(context).bottomNavigationBarTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
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
