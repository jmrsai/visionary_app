import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visionary/providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/onboarding_1.png',
      'title': 'Welcome to Visionary',
      'description': 'Your personal guide to better eye health. Let\'s get started on a journey to clearer vision.',
    },
    {
      'image': 'assets/images/onboarding_2.png',
      'title': 'Track Your Symptoms',
      'description': 'Use our AI-powered symptom checker to understand and monitor your eye health concerns.',
    },
    {
      'image': 'assets/images/onboarding_3.png',
      'title': 'Personalized Exercises',
      'description': 'Discover daily exercises and activities tailored to your needs to improve your vision.',
    },
    {
      'image': 'assets/images/onboarding_4.png',
      'title': 'Join the Community',
      'description': 'Connect with others, share your progress, and learn from the experiences of the Visionary community.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryBlue, AppTheme.accentGreen],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return _buildPageContent(
                    imagePath: _onboardingData[index]['image']!,
                    title: _onboardingData[index]['title']!,
                    description: _onboardingData[index]['description']!,
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildControls(appState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent({required String imagePath, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FadeTransition(
              opacity: _animationController,
              child: Image.asset(
                imagePath,
                height: MediaQuery.of(context).size.height * 0.35,
              ),
            ),
          ),
          const SizedBox(height: 48),
          FadeTransition(
            opacity: _animationController,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: _animationController,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withAlpha(204),
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(AppStateProvider appState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPageIndicator(),
          if (_currentPage == _onboardingData.length - 1)
            _buildGetStartedButton(appState)
          else
            _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_onboardingData.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Colors.white
                : Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildGetStartedButton(AppStateProvider appState) {
    return CustomButton(
      text: 'Get Started',
      onPressed: appState.completeOnboarding,
      type: ButtonType.primary,
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            _pageController.jumpToPage(_onboardingData.length - 1);
          },
          child: Text(
            'Skip',
            style: TextStyle(
              color: Colors.white.withAlpha(230),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CustomButton(
          text: 'Next',
          onPressed: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          type: ButtonType.secondary,
          icon: Icons.arrow_forward_ios,
        ),
      ],
    );
  }
}
