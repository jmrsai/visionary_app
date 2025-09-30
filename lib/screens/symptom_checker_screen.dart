import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class SymptomCheckerScreen extends StatelessWidget {
  const SymptomCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Checker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search,
              size: 80,
              color: AppTheme.success,
            ).animate().scale(duration: 800.ms),
            const SizedBox(height: 24),
            const Text(
              'AI Symptom Checker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 12),
            const Text(
              'Coming soon - Advanced symptom analysis',
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Back to Dashboard',
              onPressed: () => Navigator.pop(context),
            ).animate().fadeIn(delay: 900.ms),
          ],
        ),
      ),
    );
  }
}

// Placeholder screens for other features
class SportsVisionScreen extends StatelessWidget {
  const SportsVisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports Vision'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Sports Vision Training - Coming Soon'),
      ),
    );
  }
}

class SquintAssessmentScreen extends StatelessWidget {
  const SquintAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Squint Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Squint Assessment Tools - Coming Soon'),
      ),
    );
  }
}

class DiseaseDetectionScreen extends StatelessWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('AI Disease Detection - Coming Soon'),
      ),
    );
  }
}

class KidsZoneScreen extends StatelessWidget {
  const KidsZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kids Zone'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Kids Vision Quest Games - Coming Soon'),
      ),
    );
  }
}