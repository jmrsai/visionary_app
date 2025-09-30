import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  final GenerativeModel _model;

  AiService()
      : _model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
        );

  Future<String> analyzeSymptoms(String symptoms) async {
    try {
      final prompt = 'Analyze the following eye-related symptoms and provide a brief, helpful analysis. The user has described their symptoms as: "$symptoms". Please do not provide a diagnosis, but rather a helpful analysis of the symptoms and suggestions for when to see a doctor.';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'I am sorry, I could not analyze the symptoms.';
    } catch (e) {
      return 'There was an error analyzing your symptoms. Please try again later.';
    }
  }

  Future<String> chat(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await _model.generateContent(content);
      return response.text ?? 'I am sorry, I could not process your message.';
    } catch (e) {
      return 'There was an error with the chat. Please try again later.';
    }
  }
}
