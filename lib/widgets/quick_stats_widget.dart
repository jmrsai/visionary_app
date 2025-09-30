import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? null : Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(25)
                : Colors.grey.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildStatsRow(context, appState.testResults, appState.sparkleStars, isDark),
          const SizedBox(height: 16),
          _buildAverageScoreChart(context, appState.testResults, isDark),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
      BuildContext context, List<TestResult> testResults, int sparkleStars, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          context,
          icon: Icons.check_circle_outline,
          label: 'Tests Taken',
          value: testResults.length.toString(),
          color: AppTheme.primaryBlue,
          isDark: isDark,
        ),
        _buildStatItem(
          context,
          icon: Icons.star_border,
          label: 'Sparkle Stars',
          value: sparkleStars.toString(),
          color: AppTheme.accentGreen,
          isDark: isDark,
        ),
        _buildStatItem(
          context,
          icon: Icons.military_tech_outlined,
          label: 'Achievements',
          value: '5', // Placeholder
          color: Colors.orange,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
      {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color.withAlpha(0.15),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildAverageScoreChart(
      BuildContext context, List<TestResult> testResults, bool isDark) {
    final theme = Theme.of(context);
    final averageScore = testResults.isEmpty
        ? 0
        : testResults.map((r) => r.score).reduce((a, b) => a + b) / testResults.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Average Test Score',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: averageScore / 100,
                  minHeight: 12,
                  backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${averageScore.toStringAsFixed(1)}%',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
