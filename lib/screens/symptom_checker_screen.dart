import 'package:flutter/material.dart';
import 'package:visionary/services/ai_service.dart';
import '../widgets/custom_button.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final _symptomController = TextEditingController();
  final _aiService = AiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _symptomController.dispose();
    super.dispose();
  }

  void _analyzeSymptoms() async {
    if (_symptomController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your symptoms.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final analysis = await _aiService.analyzeSymptoms(_symptomController.text);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Symptom Analysis'),
        content: Text(analysis),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptom Checker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Describe your symptoms',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _symptomController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText:
                        'e.g., "I have blurry vision and my eyes feel dry."',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Analyze Symptoms',
                onPressed: _analyzeSymptoms,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
