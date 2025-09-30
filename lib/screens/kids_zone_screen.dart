import 'package:flutter/material.dart';

class KidsZoneScreen extends StatelessWidget {
  const KidsZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kids Zone')),
      body: const Center(child: Text('Kids Zone Screen Content')),
    );
  }
}