import 'package:flutter/material.dart';

enum ViewType {
  dashboard,
  symptomChecker,
  aiChatbot,
  visionTests,
  exercises,
  sportsVision,
  squintAssessment,
  diseaseDetection,
  kidsZone,
  profile,
}

class TestResult {
  final String testName;
  final double score;
  final DateTime timestamp;

  TestResult({
    required this.testName,
    required this.score,
    required this.timestamp,
  });
}

class AppState extends ChangeNotifier {
  bool _showOnboarding = true;
  String _userName = 'sai';
  ViewType _currentView = ViewType.dashboard;

  bool get showOnboarding => _showOnboarding;
  String get userName => _userName;
  ViewType get currentView => _currentView;

  void completeOnboarding(String name) {
    _userName = name;
    _showOnboarding = false;
    notifyListeners();
  }

  void setCurrentView(ViewType view) {
    _currentView = view;
    notifyListeners();
  }

  void navigateBack() {
    _currentView = ViewType.dashboard;
    notifyListeners();
  }
}