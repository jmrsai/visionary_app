import 'dart:async';

import 'package:visionary/models/chat_response.dart';

class AIChatService {
  Future<ChatResponse> getResponse(String message, String currentSymptom) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple mock logic for responses
    if (currentSymptom.isEmpty) {
      if (message.toLowerCase().contains('symptoms')) {
        return ChatResponse(
          content: 'I can help with that. What symptoms are you experiencing?',
          symptom: 'starting',
          suggestions: ['Blurry vision', 'Eye pain', 'Headaches'],
        );
      } else if (message.toLowerCase().contains('question')) {
        return ChatResponse(
          content: 'Of course. What is your question about eye health?',
        );
      } else if (message.toLowerCase().contains('conditions')) {
        return ChatResponse(
          content: 'I can provide information on various eye conditions. Which one are you interested in?',
          quickReplies: ['Cataracts', 'Glaucoma', 'Myopia'],
        );
      } else {
        return ChatResponse(
          content: "I'm sorry, I didn't quite understand. You can ask me to check symptoms, answer questions, or tell you about eye conditions.",
          suggestions: [
            'Check my symptoms',
            'I have a question about my eye health',
            'Tell me about common eye conditions'
          ],
        );
      }
    } else {
      // Follow-up logic based on currentSymptom
      return ChatResponse(
        content: 'Thank you for sharing. Based on your symptoms, I recommend consulting with an eye care professional. Would you like me to help you find one?',
        symptom: '', // Reset symptom tracking
        suggestions: ['Yes, find a doctor near me', 'No, thank you'],
      );
    }
  }
}
