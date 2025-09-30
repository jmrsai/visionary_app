import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

enum ButtonType { primary, secondary, outline, text }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildButton(theme, isDark),
          );
        },
      ),
    );
  }

  Widget _buildButton(ThemeData theme, bool isDark) {
    switch (widget.type) {
      case ButtonType.primary:
        return _buildPrimaryButton(theme, isDark);
      case ButtonType.secondary:
        return _buildSecondaryButton(theme, isDark);
      case ButtonType.outline:
        return _buildOutlineButton(theme, isDark);
      case ButtonType.text:
        return _buildTextButton(theme, isDark);
    }
  }

  Widget _buildPrimaryButton(ThemeData theme, bool isDark) {
    return Container(
      width: widget.width,
      height: widget.height ?? 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.onPressed != null
              ? isDark
                  ? [AppTheme.accentGreen, AppTheme.accentGreen.withOpacity(0.8)]
                  : [AppTheme.primaryBlue, AppTheme.primaryBlue.withOpacity(0.8)]
              : [Colors.grey.shade400, Colors.grey.shade500],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: widget.onPressed != null
            ? [
                BoxShadow(
                  color: (isDark ? AppTheme.accentGreen : AppTheme.primaryBlue).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _buildButtonContent(
              theme,
              isDark ? AppTheme.primaryBlue : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(ThemeData theme, bool isDark) {
    return Container(
      width: widget.width,
      height: widget.height ?? 56,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _buildButtonContent(
              theme,
              isDark ? AppTheme.textDark : AppTheme.textLight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton(ThemeData theme, bool isDark) {
    final color = isDark ? AppTheme.accentGreen : AppTheme.primaryBlue;
    
    return Container(
      width: widget.width,
      height: widget.height ?? 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _buildButtonContent(theme, color),
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton(ThemeData theme, bool isDark) {
    final color = isDark ? AppTheme.accentGreen : AppTheme.primaryBlue;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _buildButtonContent(theme, color),
        ),
      ),
    );
  }

  Widget _buildButtonContent(ThemeData theme, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        else ...[
          if (widget.icon != null) ...[
            Icon(widget.icon, color: textColor, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            widget.text,
            style: theme.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}