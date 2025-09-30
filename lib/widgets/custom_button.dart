import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visionary/theme/app_theme.dart';

enum ButtonType {
  primary,
  secondary,
  tertiary,
}

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          decoration: _buildButtonDecoration(isDark),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null)
                        Icon(
                          widget.icon,
                          color: _getTextColor(isDark),
                          size: 20,
                        ),
                      if (widget.icon != null)
                        const SizedBox(width: 8),
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: _getTextColor(isDark),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Decoration _buildButtonDecoration(bool isDark) {
    switch (widget.type) {
      case ButtonType.primary:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: _isHovering
                ? (isDark
                    ? [AppTheme.accentGreen, AppTheme.accentGreen.withAlpha(204)]
                    : [AppTheme.primaryBlue, AppTheme.primaryBlue.withAlpha(204)])
                : (isDark
                    ? [AppTheme.accentGreen, AppTheme.accentGreen]
                    : [AppTheme.primaryBlue, AppTheme.primaryBlue]),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _getShadowColor(isDark).withAlpha(_isHovering ? 102 : 51),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case ButtonType.secondary:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
          border: Border.all(
            color: isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
            width: 1.5,
          ),
        );
      case ButtonType.tertiary:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,
        );
    }
  }

  Color _getTextColor(bool isDark) {
    switch (widget.type) {
      case ButtonType.primary:
        return Colors.white;
      case ButtonType.secondary:
        return isDark ? AppTheme.accentGreen : AppTheme.primaryBlue;
      case ButtonType.tertiary:
        return isDark ? AppTheme.textDark : AppTheme.textLight;
    }
  }

  Color _getShadowColor(bool isDark) {
    return isDark ? AppTheme.accentGreen : AppTheme.primaryBlue;
  }
}
