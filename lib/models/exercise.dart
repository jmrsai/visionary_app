import 'package:flutter/material.dart';

class Exercise {
  final String title;
  final String description;
  final String duration;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  Exercise({
    required this.title,
    required this.description,
    required this.duration,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
