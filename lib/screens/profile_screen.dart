import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class FeatureData {
  final IconData icon;
  final String title;
  final String routeName;

  const FeatureData({
    required this.icon,
    required this.title,
    required this.routeName,
  });
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<FeatureData> features = const [
    FeatureData(icon: Icons.home, title: 'Home', routeName: '/home'),
    FeatureData(icon: Icons.chat, title: 'AI Chatbot', routeName: '/ai-chatbot'),
    FeatureData(icon: Icons.fitness_center, title: 'Exercises', routeName: '/exercises'),
    FeatureData(icon: Icons.visibility, title: 'Vision Tests', routeName: '/vision-tests'),
    FeatureData(icon: Icons.check, title: 'Symptom Checker', routeName: '/symptom-checker'),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return Card(
            child: ListTile(
              leading: Icon(feature.icon),
              title: Text(feature.title),
              onTap: () => Navigator.pushNamed(context, feature.routeName),
            ),
          );
        },
      ),
    );
  }
}
