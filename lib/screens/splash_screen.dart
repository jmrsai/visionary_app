import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryBlue,
              AppTheme.accentGreen,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App icon with pulse animation
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withAlpha(0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.visibility,
                  size: 60,
                  color: Colors.white,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    duration: 2000.ms,
                    begin: const Offset(0.9, 0.9),
                    end: const Offset(1.1, 1.1),
                    curve: Curves.easeInOut,
                  ),
              
              const SizedBox(height: 40),
              
              // App name
              Text(
                'Visionary',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              )
                  .animate()
                  .fadeIn(duration: 1000.ms, delay: 500.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 12),
              
              // Tagline
              Text(
                'Your Vision Companion',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white.withAlpha(0.9),
                  fontWeight: FontWeight.w500,
                ),
              )
                  .animate()
                  .fadeIn(duration: 1000.ms, delay: 800.ms)
                  .slideY(begin: 0.3, end: 0),
              
              const SizedBox(height: 60),
              
              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withAlpha(0.8),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 1200.ms),
              
              const SizedBox(height: 20),
              
              Text(
                'Initializing your vision journey...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(0.8),
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 1500.ms),
            ],
          ),
        ),
      ),
    );
  }
}