import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Placeholder data - replace with actual data from a provider
    final stats = [
      {
        'value': '12',
        'label': 'Tests Taken',
        'color': isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
      },
      {
        'value': '8',
        'label': 'Exercises Done',
        'color': isDark ? AppTheme.accentYellow : AppTheme.accentOrange,
      },
      {
        'value': '3',
        'label': 'Achievements',
        'color': isDark ? AppTheme.accentRed : AppTheme.accentPurple,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: stats.map((stat) {
        return Expanded(
          child: _buildStatCard(
            context,
            value: stat['value'] as String,
            label: stat['label'] as String,
            color: stat['color'] as Color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(BuildContext context, {required String value, required String label, required Color color}) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withAlpha(38),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withAlpha(179),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
