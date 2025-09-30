import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visionary/models/exercise.dart';
import 'package:visionary/providers/app_state_provider.dart';
import 'package:visionary/theme/app_theme.dart';
import 'package:visionary/widgets/exercise_card.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Exercise> exercises = [
      Exercise(
        title: 'Focus Shift',
        description: 'Improve your eye\'s ability to change focus between near and far objects.',
        duration: '5 min',
        icon: Icons.track_changes,
        color: isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
        onTap: () {},
      ),
      Exercise(
        title: 'Blinking Break',
        description: 'Reduce eye strain and dryness by consciously blinking.',
        duration: '1 min',
        icon: Icons.visibility_off_outlined,
        color: isDark ? AppTheme.accentYellow : AppTheme.accentOrange,
        onTap: () {},
      ),
      Exercise(
        title: '20-20-20 Rule',
        description: 'Every 20 minutes, look at something 20 feet away for 20 seconds.',
        duration: '20 sec',
        icon: Icons.timer_outlined,
        color: isDark ? AppTheme.accentRed : AppTheme.accentPurple,
        onTap: () {},
      ),
      Exercise(
        title: 'Figure Eight',
        description: 'Improve eye muscle control and flexibility by tracing a figure eight.',
        duration: '2 min',
        icon: Icons.gesture_outlined,
        color: isDark ? AppTheme.accentCyan : AppTheme.accentCyan,
        onTap: () {},
      ),
      Exercise(
        title: 'Palming',
        description: 'Relax your eyes and mind with this simple technique.',
        duration: '3 min',
        icon: Icons.healing_outlined,
        color: isDark ? AppTheme.accentMagenta : AppTheme.accentMagenta,
        onTap: () {},
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Exercises'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isDark, appState.completedExercisesToday),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'All Exercises'),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ExerciseCard(exercise: exercise),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, int completedToday) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors:
              isDark ? [AppTheme.accentGreen.withAlpha(51), AppTheme.success.withAlpha(51)] : [AppTheme.primaryBlue, AppTheme.accentGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppTheme.accentGreen : AppTheme.success).withAlpha(51),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stay Consistent',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete your daily eye exercises to\nmaintain optimal vision health.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(204),
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildProgressIndicator(context, completedToday),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, int completedToday) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const totalExercises = 5; // Example total
    final progress = completedToday / totalExercises;

    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            backgroundColor: isDark ? Colors.white.withAlpha(51) : Colors.white.withAlpha(77),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          Text(
            '$completedToday/$totalExercises',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
