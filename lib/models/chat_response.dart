class ChatResponse {
  final String content;
  final String symptom;
  final List<String>? suggestions;
  final List<String>? quickReplies;

  ChatResponse({
    required this.content,
    this.symptom = '',
    this.suggestions,
    this.quickReplies,
  });
}
