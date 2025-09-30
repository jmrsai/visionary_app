import 'package:flutter/material.dart';
import 'package:visionary/screens/sports_vision_screen.dart';
import 'package:visionary/screens/squint_assessment_screen.dart';
import 'package:visionary/screens/disease_detection_screen.dart';
import 'package:visionary/screens/kids_zone_screen.dart';

class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String visionTests = '/visionTests';
  static const String exercises = '/exercises';
  static const String aiChatbot = '/aiChatbot';
  static const String profile = '/profile';
  static const String symptomChecker = '/symptomChecker';
  static const String sportsVision = '/sportsVision';
  static const String squintAssessment = '/squintAssessment';
  static const String diseaseDetection = '/diseaseDetection';
  static const String kidsZone = '/kidsZone';

  static Map<String, WidgetBuilder> routes = {
    sportsVision: (context) => const SportsVisionScreen(),
    squintAssessment: (context) => const SquintAssessmentScreen(),
    diseaseDetection: (context) => const DiseaseDetectionScreen(),
    kidsZone: (context) => const KidsZoneScreen(),
  };
}