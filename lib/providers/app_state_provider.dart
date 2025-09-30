import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class AppStateProvider extends ChangeNotifier {
  ViewType _currentView = ViewType.dashboard;
  int _currentNavIndex = 0;
  bool _isOffline = false;
  final List<TestResult> _testResults = [];
  List<String> _achievements = [];
  int _sparkleStars = 0;

  ViewType get currentView => _currentView;
  int get currentNavIndex => _currentNavIndex;
  bool get isOffline => _isOffline;
  List<TestResult> get testResults => _testResults;
  List<String> get achievements => _achievements;
  int get sparkleStars => _sparkleStars;

  AppStateProvider() {
    _loadAppState();
  }

  void setCurrentView(ViewType view) {
    _currentView = view;
    _updateNavIndexFromView();
    notifyListeners();
  }

  void setCurrentNavIndex(int index) {
    _currentNavIndex = index;
    _updateViewFromNavIndex();
    notifyListeners();
  }

  void navigateBack() {
    // A simple navigation back logic
    setCurrentView(ViewType.dashboard);
  }

  void setOfflineStatus(bool offline) {
    _isOffline = offline;
    notifyListeners();
  }

  void saveTestResult(TestResult result) {
    _testResults.add(result);
    _saveAppState();
    notifyListeners();
  }

  void addAchievement(String achievement) {
    if (!_achievements.contains(achievement)) {
      _achievements.add(achievement);
      _saveAppState();
      notifyListeners();
    }
  }

  void addSparkleStars(int stars) {
    _sparkleStars += stars;
    _saveAppState();
    notifyListeners();
  }

  void _updateNavIndexFromView() {
    switch (_currentView) {
      case ViewType.dashboard:
        _currentNavIndex = 0;
        break;
      case ViewType.visionTests:
        _currentNavIndex = 1;
        break;
      case ViewType.exercises:
        _currentNavIndex = 2;
        break;
      case ViewType.aiChatbot:
        _currentNavIndex = 3;
        break;
      case ViewType.profile:
        _currentNavIndex = 4;
        break;
      default:
        // For other views, we might not want to change the nav index
        break;
    }
  }

  void _updateViewFromNavIndex() {
    switch (_currentNavIndex) {
      case 0:
        _currentView = ViewType.dashboard;
        break;
      case 1:
        _currentView = ViewType.visionTests;
        break;
      case 2:
        _currentView = ViewType.exercises;
        break;
      case 3:
        _currentView = ViewType.aiChatbot;
        break;
      case 4:
        _currentView = ViewType.profile;
        break;
    }
  }

  Future<void> _loadAppState() async {
    final prefs = await SharedPreferences.getInstance();
    _sparkleStars = prefs.getInt('sparkle_stars') ?? 0;
    _achievements = prefs.getStringList('achievements') ?? [];
    // Loading test results would be more complex, omitted for brevity
    notifyListeners();
  }

  Future<void> _saveAppState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sparkle_stars', _sparkleStars);
    await prefs.setStringList('achievements', _achievements);
    // Saving test results would be more complex, omitted for brevity
  }

  void clearAllData() async {
    _testResults.clear();
    _achievements.clear();
    _sparkleStars = 0;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sparkle_stars');
    await prefs.remove('achievements');
    // Clearing test results would be more complex, omitted for brevity

    notifyListeners();
  }
}

class TestResult {
  final String testName;
  final double score;
  final DateTime timestamp;

  TestResult({required this.testName, required this.score, required this.timestamp});
}
