import 'package:flutter/material.dart';
import 'package:visionary/models/vision_test.dart';

class TestCard extends StatelessWidget {
  final VisionTest test;

  const TestCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: test.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(test.icon, size: 48.0),
              const SizedBox(height: 16.0),
              Text(test.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8.0),
              Text(
                test.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
