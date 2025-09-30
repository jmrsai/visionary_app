import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TypingIndicator extends StatefulWidget {
  final bool showIndicator;

  const TypingIndicator({super.key, this.showIndicator = false});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with TickerProviderStateMixin {
  late AnimationController _appearanceController;
  late Animation<double> _indicatorAnimation;

  late AnimationController _repeatingController;
  final List<Interval> _dotIntervals = const [
    Interval(0.0, 0.8),
    Interval(0.1, 0.9),
    Interval(0.2, 1.0),
  ];

  @override
  void initState() {
    super.initState();
    _appearanceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _indicatorAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: Curves.easeOut,
    );

    _repeatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.showIndicator) {
      _showIndicator();
    } 
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        _showIndicator();
      } else {
        _hideIndicator();
      }
    }
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    _repeatingController.dispose();
    super.dispose();
  }

  void _showIndicator() {
    _appearanceController.forward();
    _repeatingController.repeat();
  }

  void _hideIndicator() {
    _appearanceController.reverse();
    _repeatingController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _indicatorAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.5),
          end: Offset.zero,
        ).animate(_indicatorAnimation),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildAnimatedDot(0),
            _buildAnimatedDot(1),
            _buildAnimatedDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.5,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _repeatingController,
          curve: _dotIntervals[index],
        ),
      ),
      child: Animate().custom(
        duration: 1500.ms,
        builder: (context, value, child) => Transform.translate(
          offset: Offset(0, -value * 4),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.withAlpha((_repeatingController.value * 255).round()),
            ),
          ),
        ),
      ),
    );
  }
}
