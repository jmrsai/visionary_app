import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/chat_message.dart';
import '../theme/app_theme.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onSuggestionTap;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUser = message.type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(isDark, isUser),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _buildMessageBubble(context, theme, isDark, isUser),
                if (message.suggestedResponses != null && message.suggestedResponses!.isNotEmpty)
                  _buildSuggestions(context, isDark),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            _buildAvatar(isDark, isUser),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildAvatar(bool isDark, bool isUser) {
    if (isUser) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
        child: Icon(
          Icons.person,
          color: isDark ? AppTheme.textDark : AppTheme.textLight,
          size: 20,
        ),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
            isDark ? AppTheme.primaryBlue : AppTheme.accentGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(
        Icons.psychology,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ThemeData theme, bool isDark, bool isUser) {
    if (message.isTyping) {
      return _buildTypingIndicator(isDark);
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUser
            ? (isDark ? AppTheme.accentGreen : AppTheme.primaryBlue)
            : (isDark ? AppTheme.cardDark : AppTheme.cardLight),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isUser ? 16 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 16),
        ),
        border: !isUser && !isDark
            ? Border.all(color: Colors.grey.shade200)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isUser
                  ? Colors.white
                  : (isDark ? AppTheme.textDark : AppTheme.textLight),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatTime(message.timestamp),
            style: theme.textTheme.bodySmall?.copyWith(
              color: isUser
                  ? Colors.white.withOpacity(0.7)
                  : (isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(4),
        ),
        border: !isDark ? Border.all(color: Colors.grey.shade200) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'AI is thinking',
            style: TextStyle(
              color: isDark ? AppTheme.textDark : AppTheme.textLight,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 24,
            height: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                return Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.2, 1.2),
                      duration: 600.ms,
                      delay: (200 * index).ms,
                      curve: Curves.easeInOut,
                    );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: message.suggestedResponses!.map((suggestion) {
          return GestureDetector(
            onTap: () => onSuggestionTap(suggestion),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.accentGreen : AppTheme.primaryBlue)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (isDark ? AppTheme.accentGreen : AppTheme.primaryBlue)
                      .withOpacity(0.3),
                ),
              ),
              child: Text(
                suggestion,
                style: TextStyle(
                  color: isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}