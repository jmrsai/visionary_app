import 'package:flutter/material.dart';

class SportsVisionScreen extends StatelessWidget {
  const SportsVisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sports Vision')),
      body: const Center(child: Text('Sports Vision Screen Content')),
    );
  }
}