import 'dart:convert';

enum MessageType { user, assistant, system }

class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isTyping;
  final List<String>? suggestedResponses;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isTyping = false,
    this.suggestedResponses,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isTyping,
    List<String>? suggestedResponses,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isTyping: isTyping ?? this.isTyping,
      suggestedResponses: suggestedResponses ?? this.suggestedResponses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isTyping': isTyping,
      'suggestedResponses': suggestedResponses,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      type: MessageType.values.firstWhere((e) => e.name == map['type']),
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      isTyping: map['isTyping'] ?? false,
      suggestedResponses: map['suggestedResponses']?.cast<String>(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) => ChatMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatMessage(id: $id, content: $content, type: $type, timestamp: $timestamp, isTyping: $isTyping, suggestedResponses: $suggestedResponses)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChatMessage &&
      other.id == id &&
      other.content == content &&
      other.type == type &&
      other.timestamp == timestamp &&
      other.isTyping == isTyping;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      content.hashCode ^
      type.hashCode ^
      timestamp.hashCode ^
      isTyping.hashCode;
  }
}