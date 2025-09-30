import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user?.name ?? 'User'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/symptom-checker');
              },
              child: const Text('Symptom Checker'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/vision-tests');
              },
              child: const Text('Vision Tests'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/exercises');
              },
              child: const Text('Eye Exercises'),
            ),
             ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ai-chatbot');
              },
              child: const Text('AI Health Chatbot'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/strain-reduction');
              },
              child: const Text('Strain Reduction'),
            ),
          ],
        ),
      ),
    );
  }
}
