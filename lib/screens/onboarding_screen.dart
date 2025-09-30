import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _currentPage = 0;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Visionary',
      description: 'Your comprehensive vision health companion powered by AI technology.',
      icon: Icons.visibility,
      gradient: const [AppTheme.primaryBlue, AppTheme.accentGreen],
    ),
    OnboardingPage(
      title: 'AI-Powered Health Assistant',
      description: 'Get personalized eye health advice and symptom analysis from our advanced AI.',
      icon: Icons.psychology,
      gradient: const [AppTheme.accentGreen, AppTheme.primaryBlue],
    ),
    OnboardingPage(
      title: 'Comprehensive Vision Tests',
      description: 'Take professional-grade vision tests from the comfort of your home.',
      icon: Icons.remove_red_eye,
      gradient: const [AppTheme.primaryBlue, AppTheme.success],
    ),
    OnboardingPage(
      title: 'Interactive Eye Exercises',
      description: 'Strengthen your eyes with guided exercises and track your progress.',
      icon: Icons.fitness_center,
      gradient: const [AppTheme.success, AppTheme.accentGreen],
    ),
    OnboardingPage(
      title: 'Kids Zone & Family Care',
      description: 'Fun games and activities to keep your family\'s vision healthy.',
      icon: Icons.child_care,
      gradient: const [AppTheme.accentGreen, AppTheme.warning],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showNameInput();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showNameInput() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'What should we call you?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us personalize your experience',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.secondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                label: 'Your Name',
                hint: 'Enter your preferred name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Get Started',
                width: double.infinity,
                onPressed: _completeOnboarding,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _completeOnboarding() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.completeOnboarding(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(_pages[index]);
              },
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: page.gradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withAlpha(77),
                    width: 2,
                  ),
                ),
                child: Icon(
                  page.icon,
                  size: 60,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .scale(duration: 800.ms, curve: Curves.elasticOut)
                  .then()
                  .shimmer(duration: 2000.ms, color: Colors.white.withAlpha(77)),
              
              const SizedBox(height: 60),
              
              Text(
                page.title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 24),
              
              Text(
                page.description,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withAlpha(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms)
                  .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: AppTheme.primaryBlue,
              dotColor: Colors.grey.shade300,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: CustomButton(
                    text: 'Previous',
                    type: ButtonType.outline,
                    onPressed: _previousPage,
                  ),
                ),
              if (_currentPage > 0) const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                  onPressed: _nextPage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}