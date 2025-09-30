class ConversationContext {
  String? lastUserMessage;
  String? lastAiResponse;

  ConversationContext({this.lastUserMessage, this.lastAiResponse});

  ConversationContext copyWith({
    String? lastUserMessage,
    String? lastAiResponse,
  }) {
    return ConversationContext(
      lastUserMessage: lastUserMessage ?? this.lastUserMessage,
      lastAiResponse: lastAiResponse ?? this.lastAiResponse,
    );
  }
}