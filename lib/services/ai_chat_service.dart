import 'dart:math';
import '../models/chat_models.dart';

class AIChatService {
  Future<ChatMessage> generateResponse(String userMessage, ConversationContext context) async {
    final lowerMessage = userMessage.toLowerCase();
    
    // Emergency detection
    if (_isEmergencySymptom(lowerMessage)) {
      return _createEmergencyResponse();
    }
    
    // Pain assessment
    if (lowerMessage.contains('pain') || lowerMessage.contains('hurt')) {
      return _createPainAssessmentResponse();
    }
    
    // Blurry vision assessment
    if (lowerMessage.contains('blurry') || lowerMessage.contains('unclear') || lowerMessage.contains('fuzzy')) {
      return _createBlurryVisionResponse();
    }
    
    // Redness assessment
    if (lowerMessage.contains('red') || lowerMessage.contains('bloodshot') || lowerMessage.contains('pink')) {
      return _createRednessResponse();
    }
    
    // Duration follow-up
    if (lowerMessage.contains('day') || lowerMessage.contains('week') || lowerMessage.contains('month')) {
      return _createDurationFollowUpResponse();
    }
    
    // Eye affected
    if (lowerMessage.contains('left eye') || lowerMessage.contains('right eye') || lowerMessage.contains('both eyes')) {
      return _createEyeAffectedResponse();
    }
    
    // Severity assessment
    if (lowerMessage.contains('mild') || lowerMessage.contains('moderate') || 
        lowerMessage.contains('significant') || lowerMessage.contains('severe')) {
      return _createSeverityResponse(lowerMessage);
    }
    
    // Photo analysis request
    if (lowerMessage.contains('photo') || lowerMessage.contains('picture') || lowerMessage.contains('image')) {
      return _createPhotoAnalysisResponse();
    }
    
    // General health questions
    if (lowerMessage.contains('general') || lowerMessage.contains('checkup') || lowerMessage.contains('healthy')) {
      return _createGeneralHealthResponse();
    }
    
    // Educational responses
    if (lowerMessage.contains('nutrition') || lowerMessage.contains('food')) {
      return _createNutritionResponse();
    }
    
    if (lowerMessage.contains('screen') || lowerMessage.contains('computer') || lowerMessage.contains('digital')) {
      return _createScreenTimeResponse();
    }
    
    // Default response
    return _createDefaultResponse();
  }
  
  bool _isEmergencySymptom(String message) {
    final emergencyKeywords = [
      'sudden vision loss',
      'severe pain',
      'flashing lights',
      'curtain over vision',
      'can\'t see'
    ];
    
    return emergencyKeywords.any((keyword) => message.contains(keyword));
  }
  
  ChatMessage _createEmergencyResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "🚨 This sounds like a potential emergency. Please seek immediate medical attention at an emergency room or contact an ophthalmologist right away. Don't delay - sudden vision changes can be serious.",
      timestamp: DateTime.now(),
      severity: MessageSeverity.emergency,
    );
  }
  
  ChatMessage _createPainAssessmentResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "I understand you're experiencing eye pain. Can you help me understand more about it?",
      timestamp: DateTime.now(),
      quickReplies: [
        'Sharp, stabbing pain',
        'Dull ache',
        'Burning sensation',
        'Pressure behind eye',
        'Pain when moving eyes'
      ],
    );
  }
  
  ChatMessage _createBlurryVisionResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "Blurry vision can have various causes. When did you first notice this change?",
      timestamp: DateTime.now(),
      quickReplies: [
        'Just started today',
        'A few days ago',
        'Over the past week',
        'Gradually over months',
        'Comes and goes'
      ],
    );
  }
  
  ChatMessage _createRednessResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "Red eyes can indicate several conditions. Are you experiencing any other symptoms along with the redness?",
      timestamp: DateTime.now(),
      quickReplies: [
        'Itching',
        'Discharge',
        'Burning',
        'Just redness',
        'Take a photo for analysis'
      ],
    );
  }
  
  ChatMessage _createDurationFollowUpResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "Thank you for that information. Is this affecting one eye or both eyes?",
      timestamp: DateTime.now(),
      quickReplies: [
        'Only my left eye',
        'Only my right eye',
        'Both eyes',
        'It alternates between eyes'
      ],
    );
  }
  
  ChatMessage _createEyeAffectedResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "Got it. On a scale of 1-10, how would you rate your discomfort or concern level?",
      timestamp: DateTime.now(),
      quickReplies: [
        '1-3 (Mild)',
        '4-6 (Moderate)',
        '7-8 (Significant)',
        '9-10 (Severe)'
      ],
    );
  }
  
  ChatMessage _createSeverityResponse(String message) {
    if (message.contains('severe') || message.contains('9') || message.contains('10')) {
      return ChatMessage(
        id: _generateId(),
        type: MessageType.ai,
        content: "Given the severity you've described, I recommend seeing an eye care professional within the next 24 hours. In the meantime, here's what might help:",
        timestamp: DateTime.now(),
        severity: MessageSeverity.high,
      );
    } else {
      return ChatMessage(
        id: _generateId(),
        type: MessageType.ai,
        content: "Thank you for all that information. Would you like me to take a photo of your eye area for additional analysis, or shall I provide recommendations based on what you've told me?",
        timestamp: DateTime.now(),
        quickReplies: [
          'Take photo for analysis',
          'Give me recommendations',
          'Ask more questions',
          'Connect with a doctor'
        ],
      );
    }
  }
  
  ChatMessage _createPhotoAnalysisResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "I'll help you take a photo for analysis. Please follow the guidelines for the best results:",
      timestamp: DateTime.now(),
    );
  }
  
  ChatMessage _createGeneralHealthResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "Great! I can help you maintain optimal eye health. What would you like to know about?",
      timestamp: DateTime.now(),
      quickReplies: [
        'Daily eye care tips',
        'Screen time effects',
        'Nutrition for eyes',
        'When to see a doctor',
        'Eye exercises'
      ],
    );
  }
  
  ChatMessage _createNutritionResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "Excellent question! Here are key nutrients for eye health:\n\n• **Vitamin A**: Carrots, sweet potatoes, spinach\n• **Omega-3**: Fish, flaxseeds, walnuts\n• **Lutein & Zeaxanthin**: Leafy greens, eggs\n• **Vitamin C**: Citrus fruits, berries\n• **Zinc**: Nuts, seeds, legumes\n\nWould you like specific meal suggestions or have other questions?",
      timestamp: DateTime.now(),
      quickReplies: [
        'Meal suggestions',
        'Supplements advice',
        'Screen time tips',
        'Exercise recommendations'
      ],
    );
  }
  
  ChatMessage _createScreenTimeResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "Digital eye strain is very common! Here's how to protect your eyes:\n\n• **20-20-20 Rule**: Every 20 minutes, look 20 feet away for 20 seconds\n• **Proper lighting**: Avoid glare and dark rooms\n• **Screen distance**: 20-26 inches away\n• **Blink frequently**: Helps keep eyes moist\n• **Blue light filters**: Use evening modes\n\nWould you like me to set up personalized reminders?",
      timestamp: DateTime.now(),
      quickReplies: [
        'Set up reminders',
        'More screen tips',
        'Exercise recommendations',
        'Check my symptoms'
      ],
    );
  }
  
  ChatMessage _createDefaultResponse() {
    return ChatMessage(
      id: _generateId(),
      type: MessageType.ai,
      content: "I want to make sure I understand you correctly. Could you tell me more about what you're experiencing? You can describe your symptoms in your own words.",
      timestamp: DateTime.now(),
      quickReplies: [
        'I have eye pain',
        'Vision problems',
        'Eyes look different',
        'General eye health',
        'Start over'
      ],
    );
  }
  
  ConversationContext updateContext(ConversationContext current, String userMessage, ChatMessage aiResponse) {
    final lowerMessage = userMessage.toLowerCase();
    
    // Update symptoms
    List<String> newSymptoms = List.from(current.symptoms);
    if (lowerMessage.contains('pain') && !newSymptoms.contains('pain')) {
      newSymptoms.add('pain');
    }
    if (lowerMessage.contains('blurry') && !newSymptoms.contains('blurry vision')) {
      newSymptoms.add('blurry vision');
    }
    if (lowerMessage.contains('red') && !newSymptoms.contains('redness')) {
      newSymptoms.add('redness');
    }
    
    return current.copyWith(
      symptoms: newSymptoms,
      duration: lowerMessage.contains('day') || lowerMessage.contains('week') || lowerMessage.contains('month') 
          ? userMessage : current.duration,
      eyeAffected: lowerMessage.contains('left eye') || lowerMessage.contains('right eye') || lowerMessage.contains('both eyes')
          ? userMessage : current.eyeAffected,
      severity: lowerMessage.contains('mild') || lowerMessage.contains('moderate') || lowerMessage.contains('severe')
          ? userMessage : current.severity,
    );
  }
  
  String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }
}