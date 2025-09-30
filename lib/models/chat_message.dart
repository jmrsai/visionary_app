import 'package:flutter/material.dart';

enum MessageType { user, ai }

class ChatMessage {
  final String id;
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final List<String>? suggestedResponses;
  final List<String>? quickReplies;

  ChatMessage({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.suggestedResponses,
    this.quickReplies,
  });
}
