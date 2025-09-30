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
  int _selectedNavIndex = 0;
  bool _isOffline = false;
  Map<String, dynamic> _testResults = {};
  List<String> _achievements = [];
  int _sparkleStars = 0;

  ViewType get currentView => _currentView;
  int get selectedNavIndex => _selectedNavIndex;
  bool get isOffline => _isOffline;
  Map<String, dynamic> get testResults => _testResults;
  List<String> get achievements => _achievements;
  int get sparkleStars => _sparkleStars;

  AppStateProvider() {
    _loadAppState();
  }

  void setCurrentView(ViewType view) {
    _currentView = view;
    _updateNavIndex();
    notifyListeners();
  }

  void setNavIndex(int index) {
    _selectedNavIndex = index;
    _updateCurrentView();
    notifyListeners();
  }

  void setOfflineStatus(bool offline) {
    _isOffline = offline;
    notifyListeners();
  }

  void saveTestResult(String testType, Map<String, dynamic> result) {
    _testResults[testType] = {
      ...result,
      'timestamp': DateTime.now().toIso8601String(),
    };
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

  void _updateNavIndex() {
    switch (_currentView) {
      case ViewType.dashboard:
        _selectedNavIndex = 0;
        break;
      case ViewType.visionTests:
        _selectedNavIndex = 1;
        break;
      case ViewType.exercises:
        _selectedNavIndex = 2;
        break;
      case ViewType.aiChatbot:
        _selectedNavIndex = 3;
        break;
      case ViewType.profile:
        _selectedNavIndex = 4;
        break;
      default:
        _selectedNavIndex = 0;
    }
  }

  void _updateCurrentView() {
    switch (_selectedNavIndex) {
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
    
    // Load test results (simplified)
    final testResultsKeys = prefs.getKeys().where((key) => key.startsWith('test_result_'));
    for (String key in testResultsKeys) {
      final testType = key.replaceFirst('test_result_', '');
      final resultString = prefs.getString(key);
      if (resultString != null) {
        // In a real app, you'd properly deserialize this
        _testResults[testType] = {'data': resultString};
      }
    }
    
    notifyListeners();
  }

  Future<void> _saveAppState() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt('sparkle_stars', _sparkleStars);
    await prefs.setStringList('achievements', _achievements);
    
    // Save test results (simplified)
    for (String testType in _testResults.keys) {
      await prefs.setString('test_result_$testType', _testResults[testType].toString());
    }
  }

  void clearAllData() async {
    _testResults.clear();
    _achievements.clear();
    _sparkleStars = 0;
    
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => 
      key.startsWith('test_result_') || 
      key == 'sparkle_stars' || 
      key == 'achievements'
    );
    
    for (String key in keys) {
      await prefs.remove(key);
    }
    
    notifyListeners();
  }
}