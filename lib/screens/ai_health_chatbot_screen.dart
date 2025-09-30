import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/chat_message.dart';
import '../services/ai_chat_service.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/image_capture_widget.dart';

class AIHealthChatbotScreen extends StatefulWidget {
  const AIHealthChatbotScreen({super.key});

  @override
  State<AIHealthChatbotScreen> createState() => _AIHealthChatbotScreenState();
}

class _AIHealthChatbotScreenState extends State<AIHealthChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIChatService _chatService = AIChatService();
  
  List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _showImageCapture = false;
  ConversationContext _context = ConversationContext();

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
    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.ai,
      content: "Hello! I'm your AI Eye Health Assistant. I'm here to help you understand your symptoms, provide guidance, and connect you with the right care when needed. How can I help you today?",
      timestamp: DateTime.now(),
      quickReplies: [
        'I have eye pain',
        'My vision is blurry',
        'My eyes are red',
        'I want a general checkup',
        'I have questions about eye health'
      ],
    );
    
    setState(() {
      _messages = [welcomeMessage];
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

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.user,
      content: content,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _textController.clear();
    _scrollToBottom();

    // Generate AI response
    await Future.delayed(const Duration(milliseconds: 1500));
    final aiResponse = await _chatService.generateResponse(content, _context);
    
    setState(() {
      _messages.add(aiResponse);
      _isTyping = false;
      _context = _chatService.updateContext(_context, content, aiResponse);
    });

    _scrollToBottom();
  }

  void _handleQuickReply(String reply) {
    _sendMessage(reply);
  }

  void _toggleImageCapture() {
    setState(() {
      _showImageCapture = !_showImageCapture;
    });
  }

  Future<void> _handleImageCapture() async {
    setState(() {
      _showImageCapture = false;
    });

    // Add system message
    final systemMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.system,
      content: "Analyzing your image...",
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(systemMessage);
    });

    _scrollToBottom();

    // Simulate image analysis
    await Future.delayed(const Duration(seconds: 3));

    final analysisResult = AnalysisResult(
      condition: 'Mild Blepharitis',
      confidence: 82,
      recommendations: [
        'Apply warm compresses 2-3 times daily',
        'Gently clean eyelid margins',
        'Avoid eye makeup temporarily',
        'Use preservative-free artificial tears'
      ],
    );

    final analysisMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.ai,
      content: "Analysis complete! Based on the image, I can see signs that suggest **${analysisResult.condition}** (${analysisResult.confidence}% confidence).\n\nThis appears to be inflammation of the eyelid margins. Here's what I recommend:",
      timestamp: DateTime.now(),
      analysis: analysisResult,
      severity: MessageSeverity.low,
      quickReplies: [
        'How to do warm compress',
        'When to see doctor',
        'Prevention tips',
        'Track symptoms'
      ],
    );

    setState(() {
      _messages.add(analysisMessage);
    });

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.read<AppState>().navigateBack(),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Health Assistant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 8,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Online & Ready',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Health Disclaimer
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(25),
              border: Border.all(color: Colors.blue.withAlpha(77)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.medical_services,
                  color: Colors.blue,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Health Disclaimer: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'This AI assistant provides general guidance only and is not a substitute for professional medical advice. For emergencies or serious symptoms, seek immediate medical attention.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const TypingIndicator();
                }
                return ChatMessageWidget(
                  message: _messages[index],
                  onSuggestionTap: (suggestion) {  },
                  onQuickReply: _handleQuickReply,
                );
              },
            ),
          ),
          // Image Capture Widget
          if (_showImageCapture)
            ImageCaptureWidget(
              onCapture: _handleImageCapture,
              onCancel: () => setState(() => _showImageCapture = false),
            ),
          // Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withAlpha(51)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Describe your symptoms or ask about eye health...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.withAlpha(25),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: _toggleImageCapture,
                        ),
                        IconButton(
                          icon: const Icon(Icons.mic),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Voice input coming soon!'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                onPressed: () => _sendMessage(_textController.text),
                child: const Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quick Actions
          Wrap(
            spacing: 8,
            children: [
              _buildQuickAction(
                Icons.favorite,
                'Health Tips',
                () => _sendMessage('Give me general eye health tips'),
              ),
              _buildQuickAction(
                Icons.visibility,
                'Vision Check',
                () => _sendMessage('I want to check my vision'),
              ),
              _buildQuickAction(
                Icons.lightbulb,
                'Prevention',
                () => _sendMessage('How can I prevent eye problems'),
              ),
              _buildQuickAction(
                Icons.warning,
                'Emergency Signs',
                () => _sendMessage('What are eye emergency signs'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withAlpha(77)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
