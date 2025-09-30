import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final List<EyeExercise> _exercises = [
    EyeExercise(
      id: 'blinking',
      title: 'Blinking Exercise',
      description: 'Reduce dry eyes and refresh your vision',
      duration: '2 minutes',
      difficulty: 'Easy',
      icon: Icons.visibility,
      color: AppTheme.success,
      instructions: [
        'Sit comfortably and relax',
        'Blink slowly and deliberately',
        'Hold eyes closed for 2 seconds',
        'Repeat 10-15 times',
      ],
    ),
    EyeExercise(
      id: 'focus_shifting',
      title: 'Focus Shifting',
      description: 'Improve focusing ability and reduce strain',
      duration: '3 minutes',
      difficulty: 'Medium',
      icon: Icons.center_focus_strong,
      color: AppTheme.primaryBlue,
      instructions: [
        'Hold your thumb 10 inches from your face',
        'Focus on your thumb for 15 seconds',
        'Shift focus to an object 20 feet away',
        'Focus on distant object for 15 seconds',
        'Repeat 5 times',
      ],
    ),
    EyeExercise(
      id: 'eye_rotations',
      title: 'Eye Rotations',
      description: 'Strengthen eye muscles and improve mobility',
      duration: '2 minutes',
      difficulty: 'Easy',
      icon: Icons.rotate_right,
      color: AppTheme.accentGreen,
      instructions: [
        'Look up and slowly circle your eyes clockwise',
        'Complete 5 clockwise rotations',
        'Rest for 2 seconds',
        'Complete 5 counter-clockwise rotations',
        'Blink several times to finish',
      ],
    ),
    EyeExercise(
      id: 'palming',
      title: 'Palming Relaxation',
      description: 'Deep relaxation for tired eyes',
      duration: '5 minutes',
      difficulty: 'Easy',
      icon: Icons.spa,
      color: AppTheme.warning,
      instructions: [
        'Rub your palms together to generate warmth',
        'Cup your palms over closed eyes',
        'Ensure no light enters',
        'Breathe deeply and relax',
        'Visualize complete darkness',
        'Hold for 3-5 minutes',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye Exercises'),
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
                  _buildExercisesList(context),
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
              ? [AppTheme.accentGreen.withAlpha(0.2), AppTheme.success.withAlpha(0.2)]
              : [AppTheme.success.withAlpha(0.1), AppTheme.accentGreen.withAlpha(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? AppTheme.accentGreen : AppTheme.success).withAlpha(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fitness_center,
                size: 32,
                color: isDark ? AppTheme.accentGreen : AppTheme.success,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Strengthen Your Vision',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.textDark : AppTheme.textLight,
                      ),
                    ),
                    Text(
                      'Guided exercises for healthier eyes',
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
              color: (isDark ? AppTheme.accentGreen : AppTheme.success).withAlpha(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 20,
                  color: isDark ? AppTheme.accentGreen : AppTheme.success,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recommended: 2-3 exercises daily for best results',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppTheme.accentGreen : AppTheme.success,
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

  Widget _buildExercisesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Exercises',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _exercises.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildExerciseCard(_exercises[index], index);
          },
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildExerciseCard(EyeExercise exercise, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: exercise.color.withAlpha(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: exercise.color.withAlpha(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: exercise.color.withAlpha(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  exercise.icon,
                  color: exercise.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.textDark : AppTheme.textLight,
                      ),
                    ),
                    Text(
                      exercise.description,
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
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.timer,
                text: exercise.duration,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                icon: Icons.signal_cellular_alt,
                text: exercise.difficulty,
                color: _getDifficultyColor(exercise.difficulty),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Start Exercise',
            onPressed: () => _startExercise(exercise),
            width: double.infinity,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: (100 * index).ms,
        )
        .slideX(
          begin: 0.2,
          end: 0,
          duration: 400.ms,
          delay: (100 * index).ms,
        );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.success;
      case 'medium':
        return AppTheme.warning;
      case 'hard':
        return AppTheme.error;
      default:
        return AppTheme.secondaryLight;
    }
  }

  void _startExercise(EyeExercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildExerciseGuide(exercise),
    );
  }

  Widget _buildExerciseGuide(EyeExercise exercise) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(bottom: 24),
            ),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: exercise.color.withAlpha(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    exercise.icon,
                    color: exercise.color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        exercise.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Instructions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: exercise.instructions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: exercise.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            exercise.instructions[index],
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Close',
                    type: ButtonType.outline,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Begin Exercise',
                    onPressed: () {
                      Navigator.pop(context);
                      _beginGuidedExercise(exercise);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _beginGuidedExercise(EyeExercise exercise) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting ${exercise.title}...'),
        backgroundColor: exercise.color,
      ),
    );
  }
}

class EyeExercise {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String difficulty;
  final IconData icon;
  final Color color;
  final List<String> instructions;

  EyeExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.icon,
    required this.color,
    required this.instructions,
  });
}