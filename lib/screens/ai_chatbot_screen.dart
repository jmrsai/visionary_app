import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../models/chat_message.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/custom_text_field.dart';

class AIChatbotScreen extends StatefulWidget {
  const AIChatbotScreen({super.key});

  @override
  State<AIChatbotScreen> createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    
    setState(() {
      _messages.add(
        ChatMessage(
          id: '1',
          content: 'Hello ${user.name}! 👋 I\'m your AI vision health assistant. I can help you with:\n\n• Eye health questions\n• Symptom analysis\n• Prevention tips\n• Exercise recommendations\n\nHow can I assist you today?',
          type: MessageType.assistant,
          timestamp: DateTime.now(),
          suggestedResponses: [
            'I have eye strain',
            'Check my symptoms',
            'Eye exercises',
            'Prevention tips',
          ],
        ),
      );
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text.trim(),
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      _generateAIResponse(text.trim());
    });
  }

  void _generateAIResponse(String userMessage) {
    String response;
    List<String>? suggestions;

    if (userMessage.toLowerCase().contains('strain') || 
        userMessage.toLowerCase().contains('tired')) {
      response = '👁️ Eye strain is common, especially with screen use. Here are some tips:\n\n• Follow the 20-20-20 rule\n• Ensure proper lighting\n• Take regular breaks\n• Blink more frequently\n\nWould you like me to guide you through some eye exercises?';
      suggestions = ['Start eye exercises', 'Tell me about 20-20-20', 'More tips'];
    } else if (userMessage.toLowerCase().contains('exercise')) {
      response = '💪 Great choice! Eye exercises can help reduce strain and improve focus:\n\n• Blinking exercises\n• Focus shifting\n• Eye rotations\n• Palming technique\n\nShall I start a guided exercise session?';
      suggestions = ['Start guided session', 'Learn techniques', 'Exercise schedule'];
    } else if (userMessage.toLowerCase().contains('symptom')) {
      response = '🔍 I can help analyze your symptoms. Please describe what you\'re experiencing:\n\n• Vision changes\n• Pain or discomfort\n• Dryness or irritation\n• Light sensitivity\n\nBe as specific as possible for better analysis.';
      suggestions = ['Blurry vision', 'Eye pain', 'Dry eyes', 'Light sensitivity'];
    } else {
      response = '🤖 I understand you\'re asking about "$userMessage". While I can provide general eye health information, for specific medical concerns, please consult an eye care professional.\n\nIs there anything specific about eye health I can help you with?';
      suggestions = ['Eye health tips', 'Common problems', 'When to see doctor'];
    }

    final aiMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: response,
      type: MessageType.assistant,
      timestamp: DateTime.now(),
      z: suggestions,
    );

    setState(() {
      _isTyping = false;
      _messages.add(aiMessage);
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
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
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI Assistant'),
                Text(
                  'Vision Health Expert',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return ChatMessageWidget(
                    message: ChatMessage(
                      id: 'typing',
                      content: '',
                      type: MessageType.assistant,
                      timestamp: DateTime.now(),
                      isTyping: true,
                    ),
                    onSuggestionTap: _sendMessage,
                  );
                }
                
                return ChatMessageWidget(
                  message: _messages[index],
                  onSuggestionTap: _sendMessage,
                );
              },
            ),
          ),
          _buildMessageInput(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ask about your eye health...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    hintStyle: TextStyle(
                      color: isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
                    ),
                  ),
                  style: TextStyle(
                    color: isDark ? AppTheme.textDark : AppTheme.textLight,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _sendMessage,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
                    isDark ? AppTheme.primaryBlue : AppTheme.accentGreen,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: IconButton(
                onPressed: () => _sendMessage(_messageController.text),
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}