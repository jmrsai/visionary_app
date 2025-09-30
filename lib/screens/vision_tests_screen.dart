import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visionary/models/vision_test.dart';
import 'package:visionary/providers/app_state_provider.dart';
import 'package:visionary/widgets/test_card.dart';
import 'package:visionary/theme/app_theme.dart';
import 'package:visionary/models/app_state.dart';

class VisionTestsScreen extends StatelessWidget {
  const VisionTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    final List<VisionTest> visionTests = [
      VisionTest(
        title: 'Visual Acuity',
        description: 'Test your sharpness of vision.',
        icon: Icons.remove_red_eye_outlined,
        onTap: () => appState.setCurrentView(ViewType.symptomChecker), // Placeholder
      ),
      VisionTest(
        title: 'Color Blindness',
        description: 'Test for color vision deficiency.',
        icon: Icons.color_lens_outlined,
        onTap: () {},
      ),
      VisionTest(
        title: 'Field of Vision',
        description: 'Check for gaps in your peripheral vision.',
        icon: Icons.fullscreen_outlined,
        onTap: () {},
      ),
      VisionTest(
        title: 'Contrast Sensitivity',
        description: 'Test your ability to distinguish between light and dark.',
        icon: Icons.brightness_6_outlined,
        onTap: () {},
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision Tests'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: visionTests.length,
              itemBuilder: (context, index) {
                final test = visionTests[index];
                return TestCard(
                  test: test,
                );
              },
            ),
            const SizedBox(height: 24),
            _buildRecentResults(context, appState.testResults),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentResults(BuildContext context, List<TestResult> testResults) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Results',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (testResults.isEmpty)
          const Text('No recent test results.')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: testResults.length > 3 ? 3 : testResults.length,
            itemBuilder: (context, index) {
              final result = testResults[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline, color: AppTheme.success),
                  title: Text(result.testName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    'Score: ${result.score.toStringAsFixed(1)} - ${result.timestamp.day}/${result.timestamp.month}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to detailed result screen
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}
