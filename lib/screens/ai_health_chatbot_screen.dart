import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visionary/models/chat_message.dart';
import 'package:visionary/providers/app_state_provider.dart';
import 'package:visionary/services/ai_chat_service.dart';
import 'package:visionary/widgets/chat_message_widget.dart';
import 'package:visionary/widgets/typing_indicator.dart';

class AIHealthChatbotScreen extends StatefulWidget {
  const AIHealthChatbotScreen({super.key});

  @override
  State<AIHealthChatbotScreen> createState() => _AIHealthChatbotScreenState();
}

class _AIHealthChatbotScreenState extends State<AIHealthChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIChatService _chatService = AIChatService();

  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String _currentSymptom = '';

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    setState(() {
      _messages.add(
        ChatMessage(
          id: 'initial',
          type: MessageType.ai,
          content: 'Welcome to the Visionary AI Health Chatbot. How can I assist you with your eye health today?',
          timestamp: DateTime.now(),
          suggestedResponses: [
            'Check my symptoms',
            'I have a question about my eye health',
            'Tell me about common eye conditions'
          ],
        ),
      );
    });
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

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.user,
      content: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    // Simulate AI response
    try {
      final response = await _chatService.getResponse(text, _currentSymptom);
      final aiResponse = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.ai,
        content: response.content,
        timestamp: DateTime.now(),
        suggestedResponses: response.suggestions,
        quickReplies: response.quickReplies,
      );

      setState(() {
        _isTyping = false;
        _messages.add(aiResponse);
        if (response.symptom.isNotEmpty) {
          _currentSymptom = response.symptom;
        }
      });
    } catch (e) {
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: MessageType.ai,
        content: 'Sorry, I am having trouble connecting. Please try again later.',
        timestamp: DateTime.now(),
      );
      setState(() {
        _isTyping = false;
        _messages.add(errorMessage);
      });
    }

    _scrollToBottom();
  }

  void _onSuggestionTapped(String suggestion) {
    _sendMessage(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Health Chatbot'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => appState.navigateBack(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeChat,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const TypingIndicator();
                }
                final message = _messages[index];
                return ChatMessageWidget(
                  message: message,
                  onSuggestionTap: _onSuggestionTapped,
                  onQuickReply: _sendMessage, // Use _sendMessage for quick replies
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Type your message or symptom...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              mini: true,
              elevation: 2,
              onPressed: () => _sendMessage(_textController.text),
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
