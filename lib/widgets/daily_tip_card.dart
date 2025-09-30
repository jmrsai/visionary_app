import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class DailyTipCard extends StatefulWidget {
  const DailyTipCard({super.key});

  @override
  State<DailyTipCard> createState() => _DailyTipCardState();
}

class _DailyTipCardState extends State<DailyTipCard> {
  int _currentTipIndex = 0;

  final List<DailyTip> _tips = [
    DailyTip(
      title: 'Follow the 20-20-20 Rule',
      description: 'Every 20 minutes, look at something 20 feet away for 20 seconds to reduce eye strain.',
      icon: Icons.timer,
      color: AppTheme.success,
    ),
    DailyTip(
      title: 'Blink Frequently',
      description: 'Blinking helps keep your eyes moist and reduces dryness, especially during screen time.',
      icon: Icons.visibility,
      color: AppTheme.primaryBlue,
    ),
    DailyTip(
      title: 'Proper Lighting',
      description: 'Ensure adequate lighting when reading or using devices to reduce eye strain.',
      icon: Icons.lightbulb,
      color: AppTheme.warning,
    ),
    DailyTip(
      title: 'Stay Hydrated',
      description: 'Drinking plenty of water helps maintain eye moisture and overall eye health.',
      icon: Icons.local_drink,
      color: AppTheme.accentGreen,
    ),
    DailyTip(
      title: 'Regular Eye Checkups',
      description: 'Visit an eye care professional annually for comprehensive eye examinations.',
      icon: Icons.medical_services,
      color: AppTheme.error,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Set tip based on day of year
    _currentTipIndex = DateTime.now().day % _tips.length;
  }

  void _nextTip() {
    setState(() {
      _currentTipIndex = (_currentTipIndex + 1) % _tips.length;
    });
  }

  void _previousTip() {
    setState(() {
      _currentTipIndex = (_currentTipIndex - 1 + _tips.length) % _tips.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentTip = _tips[_currentTipIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            currentTip.color.withAlpha(25),
            currentTip.color.withAlpha(13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: currentTip.color.withAlpha(77),
        ),
        boxShadow: [
          BoxShadow(
            color: currentTip.color.withAlpha(25),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: currentTip.color.withAlpha(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  currentTip.icon,
                  color: currentTip.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Tip',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: currentTip.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      currentTip.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.textDark : AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _previousTip,
                    icon: Icon(
                      Icons.chevron_left,
                      color: currentTip.color,
                    ),
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: _nextTip,
                    icon: Icon(
                      Icons.chevron_right,
                      color: currentTip.color,
                    ),
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            currentTip.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              _tips.length,
              (index) => Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: index == _currentTipIndex
                      ? currentTip.color
                      : currentTip.color.withAlpha(77),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 150.ms)
        .slideX(begin: 0.2, end: 0);
  }
}

class DailyTip {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  DailyTip({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}