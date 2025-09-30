import 'dart:convert';

enum MessageType { user, ai, system, assistant }

enum MessageSeverity { low, medium, high }

class AnalysisResult {
  final String condition;
  final int confidence;
  final List<String> recommendations;

  AnalysisResult({
    required this.condition,
    required this.confidence,
    required this.recommendations,
  });

  AnalysisResult copyWith({
    String? condition,
    int? confidence,
    List<String>? recommendations,
  }) {
    return AnalysisResult(
      condition: condition ?? this.condition,
      confidence: confidence ?? this.confidence,
      recommendations: recommendations ?? this.recommendations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'condition': condition,
      'confidence': confidence,
      'recommendations': recommendations,
    };
  }

  factory AnalysisResult.fromMap(Map<String, dynamic> map) {
    return AnalysisResult(
      condition: map['condition'] ?? '',
      confidence: map['confidence']?.toInt() ?? 0,
      recommendations: List<String>.from(map['recommendations'] ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory AnalysisResult.fromJson(String source) => AnalysisResult.fromMap(json.decode(source));

  @override
  String toString() => 'AnalysisResult(condition: $condition, confidence: $confidence, recommendations: $recommendations)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AnalysisResult &&
      other.condition == condition &&
      other.confidence == confidence &&
      other.recommendations == recommendations;
  }

  @override
  int get hashCode => condition.hashCode ^ confidence.hashCode ^ recommendations.hashCode;
}

class ChatMessage {
  final String id;
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final AnalysisResult? analysis;
  final MessageSeverity? severity;
  final List<String>? quickReplies;

  ChatMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.analysis,
    this.severity,
    this.quickReplies,
  });

  ChatMessage copyWith({
    String? id,
    MessageType? type,
    String? content,
    DateTime? timestamp,
    AnalysisResult? analysis,
    MessageSeverity? severity,
    List<String>? quickReplies,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      analysis: analysis ?? this.analysis,
      severity: severity ?? this.severity,
      quickReplies: quickReplies ?? this.quickReplies,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'analysis': analysis?.toMap(),
      'severity': severity?.toString(),
      'quickReplies': quickReplies,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      type: MessageType.values.firstWhere((e) => e.toString() == map['type']),
      content: map['content'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      analysis: map['analysis'] != null ? AnalysisResult.fromMap(map['analysis']) : null,
      severity: map['severity'] != null ? MessageSeverity.values.firstWhere((e) => e.toString() == map['severity']) : null,
      quickReplies: map['quickReplies'] == null ? null : List<String>.from(map['quickReplies']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) => ChatMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatMessage(id: $id, type: $type, content: $content, timestamp: $timestamp, analysis: $analysis, severity: $severity, quickReplies: $quickReplies)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChatMessage &&
      other.id == id &&
      other.type == type &&
      other.content == content &&
      other.timestamp == timestamp &&
      other.analysis == analysis &&
      other.severity == severity &&
      other.quickReplies == quickReplies;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      type.hashCode ^
      content.hashCode ^
      timestamp.hashCode ^
      analysis.hashCode ^
      severity.hashCode ^
      quickReplies.hashCode;
  }
}