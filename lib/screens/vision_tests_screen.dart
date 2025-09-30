import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/test_card.dart';

class VisionTestsScreen extends StatefulWidget {
  const VisionTestsScreen({super.key});

  @override
  State<VisionTestsScreen> createState() => _VisionTestsScreenState();
}

class _VisionTestsScreenState extends State<VisionTestsScreen> {
  final List<VisionTest> _tests = [
    VisionTest(
      id: 'visual_acuity',
      title: 'Visual Acuity Test',
      description: 'Measure how sharp your vision is',
      icon: Icons.visibility,
      color: AppTheme.primaryBlue,
      duration: '5-10 min',
      difficulty: 'Easy',
    ),
    VisionTest(
      id: 'amsler_grid',
      title: 'Amsler Grid Test',
      description: 'Check for macular degeneration',
      icon: Icons.grid_on,
      color: AppTheme.success,
      duration: '3-5 min',
      difficulty: 'Easy',
    ),
    VisionTest(
      id: 'color_vision',
      title: 'Color Vision Test',
      description: 'Test for color blindness',
      icon: Icons.palette,
      color: AppTheme.warning,
      duration: '5-8 min',
      difficulty: 'Medium',
    ),
    VisionTest(
      id: 'astigmatism',
      title: 'Astigmatism Test',
      description: 'Check for irregular cornea shape',
      icon: Icons.blur_circular,
      color: AppTheme.error,
      duration: '3-5 min',
      difficulty: 'Easy',
    ),
    VisionTest(
      id: 'peripheral_vision',
      title: 'Peripheral Vision',
      description: 'Test your side vision',
      icon: Icons.panorama_wide_angle,
      color: AppTheme.accentGreen,
      duration: '8-12 min',
      difficulty: 'Medium',
    ),
    VisionTest(
      id: 'contrast_sensitivity',
      title: 'Contrast Sensitivity',
      description: 'Measure ability to see contrasts',
      icon: Icons.contrast,
      color: AppTheme.primaryBlue,
      duration: '6-10 min',
      difficulty: 'Hard',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vision Tests'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildTestList(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppTheme.accentGreen.withValue(0.2), AppTheme.primaryBlue.withValue(0.2)]
              : [AppTheme.primaryBlue.withValue(0.1), AppTheme.accentGreen.withValue(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? AppTheme.accentGreen : AppTheme.primaryBlue).withValue(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.visibility,
                size: 32,
                color: isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Vision Tests',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.textDark : AppTheme.textLight,
                      ),
                    ),
                    Text(
                      'Comprehensive eye health screening',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isDark ? AppTheme.accentGreen : AppTheme.primaryBlue).withValue(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tests are designed to complement, not replace, professional eye exams.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildTestList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Tests',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tests.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return TestCard(
              test: _tests[index],
              index: index,
              onTap: () => _startTest(_tests[index]),
            );
          },
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0);
  }

  void _startTest(VisionTest test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start ${test.title}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(test.description),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: AppTheme.secondaryLight),
                const SizedBox(width: 4),
                Text('Duration: ${test.duration}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.bar_chart, size: 16, color: AppTheme.secondaryLight),
                const SizedBox(width: 4),
                Text('Difficulty: ${test.difficulty}'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Start Test',
            onPressed: () {
              Navigator.pop(context);
              _performTest(test);
            },
          ),
        ],
      ),
    );
  }

  void _performTest(VisionTest test) {
    // Navigate to specific test implementation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${test.title}...'),
        backgroundColor: test.color,
      ),
    );

    // Simulate test completion and save result
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.saveTestResult(test.id, {
      'testName': test.title,
      'completed': true,
      'score': 85 + (DateTime.now().millisecond % 15), // Mock score
      'duration': test.duration,
    });
  }
}

class VisionTest {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String duration;
  final String difficulty;

  VisionTest({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.duration,
    required this.difficulty,
  });
}