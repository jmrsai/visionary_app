enum MessageType { user, ai, system }
enum MessageSeverity { low, medium, high, emergency }

class ChatMessage {
  final String id;
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final List<String>? quickReplies;
  final String? imageUrl;
  final AnalysisResult? analysis;
  final MessageSeverity? severity;
  final bool isTyping;
  final List<String>? suggestedResponses;


  ChatMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.quickReplies,
    this.imageUrl,
    this.analysis,
    this.severity,
    this.isTyping = false,
    this.suggestedResponses,
  });
}

class AnalysisResult {
  final String condition;
  final int confidence;
  final List<String> recommendations;

  AnalysisResult({
    required this.condition,
    required this.confidence,
    required this.recommendations,
  });
}

class ConversationContext {
  List<String> symptoms;
  String duration;
  String severity;
  String eyeAffected;
  int painLevel;
  bool visionChanges;
  bool recentTests;

  ConversationContext({
    this.symptoms = const [],
    this.duration = '',
    this.severity = '',
    this.eyeAffected = '',
    this.painLevel = 0,
    this.visionChanges = false,
    this.recentTests = false,
  });

  ConversationContext copyWith({
    List<String>? symptoms,
    String? duration,
    String? severity,
    String? eyeAffected,
    int? painLevel,
    bool? visionChanges,
    bool? recentTests,
  }) {
    return ConversationContext(
      symptoms: symptoms ?? this.symptoms,
      duration: duration ?? this.duration,
      severity: severity ?? this.severity,
      eyeAffected: eyeAffected ?? this.eyeAffected,
      painLevel: painLevel ?? this.painLevel,
      visionChanges: visionChanges ?? this.visionChanges,
      recentTests: recentTests ?? this.recentTests,
    );
  }
}