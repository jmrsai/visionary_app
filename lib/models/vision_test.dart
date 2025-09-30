import 'package:flutter/material.dart';

class VisionTest {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  VisionTest({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });
}
