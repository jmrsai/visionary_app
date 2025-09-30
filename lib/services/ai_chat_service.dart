import 'package:visionary/models/chat_message.dart';
import 'package:visionary/models/conversation_context.dart';

class AIChatService {
  // Replace with your actual AI model initialization and API key
  final String apiKey = 'YOUR_API_KEY'; // Store securely, don't hardcode!

  Future<ChatMessage> generateResponse(String prompt, ConversationContext context) async {
    // Simulate an AI response (replace with actual AI call)
    await Future.delayed(const Duration(seconds: 1));
    String aiResponseContent = 'This is a simulated AI response to: $prompt';

    // Basic context awareness (example)
    if (context.lastUserMessage != null) {
      aiResponseContent += '\n\nPrevious user message: ${context.lastUserMessage}';
    }

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.ai,
      content: aiResponseContent,
      timestamp: DateTime.now(),
    );
  }

    Future<ChatMessage> generateQuickReplyResponse(String prompt, ConversationContext context) async {
    // Simulate an AI response (replace with actual AI call)
    await Future.delayed(const Duration(seconds: 1));
    String aiResponseContent = 'This is a simulated AI Quick Reply response to: $prompt';

    // Basic context awareness (example)
    if (context.lastUserMessage != null) {
      aiResponseContent += '\n\nPrevious user message: ${context.lastUserMessage}';
    }

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: MessageType.ai,
      content: aiResponseContent,
      timestamp: DateTime.now(),
    );
  }

  ConversationContext updateContext(ConversationContext context, String userMessage, ChatMessage aiResponse) {
    return context.copyWith(
      lastUserMessage: userMessage,
      lastAiResponse: aiResponse.content,
    );
  }
}