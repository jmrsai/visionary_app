import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visionary/models/app_state.dart';
import 'package:visionary/models/tip.dart';
import 'package:visionary/theme/app_theme.dart';

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
  bool _onboardingCompleted = false;
  int _completedExercisesToday = 0;

  ViewType get currentView => _currentView;
  int get currentNavIndex => _currentNavIndex;
  bool get isOffline => _isOffline;
  List<TestResult> get testResults => _testResults;
  List<String> get achievements => _achievements;
  int get sparkleStars => _sparkleStars;
  bool get onboardingCompleted => _onboardingCompleted;
  int get completedExercisesToday => _completedExercisesToday;

  late Tip _currentTip;
  Tip get currentTip => _currentTip;

  AppStateProvider() {
    _loadAppState();
    _currentTip = _generateRandomTip();
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

  void completeOnboarding() {
    _onboardingCompleted = true;
    _saveAppState();
    notifyListeners();
  }

  void showNewTip() {
    _currentTip = _generateRandomTip();
    notifyListeners();
  }

  Tip _generateRandomTip() {
    // In a real app, these would be more varied and perhaps fetched from a service
    final tips = [
      Tip(
        text: 'Take a 20-second break every 20 minutes to look at something 20 feet away.',
        icon: Icons.timer,
        color: AppTheme.primaryBlue,
      ),
      Tip(
        text: 'Blink frequently to keep your eyes lubricated and reduce dryness.',
        icon: Icons.visibility_off_outlined,
        color: AppTheme.accentGreen,
      ),
      Tip(
        text: 'Adjust your screen brightness to match the ambient light in your room.',
        icon: Icons.brightness_6_outlined,
        color: AppTheme.accentPurple,
      ),
    ];
    return tips[DateTime.now().second % tips.length];
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
    _onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    _completedExercisesToday = prefs.getInt('completed_exercises_today') ?? 0;
    // Loading test results would be more complex, omitted for brevity
    notifyListeners();
  }

  Future<void> _saveAppState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sparkle_stars', _sparkleStars);
    await prefs.setStringList('achievements', _achievements);
    await prefs.setBool('onboarding_completed', _onboardingCompleted);
    await prefs.setInt('completed_exercises_today', _completedExercisesToday);
    // Saving test results would be more complex, omitted for brevity
  }

  void clearAllData() async {
    _testResults.clear();
    _achievements.clear();
    _sparkleStars = 0;
    _onboardingCompleted = false;
    _completedExercisesToday = 0;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sparkle_stars');
    await prefs.remove('achievements');
    await prefs.remove('onboarding_completed');
    await prefs.remove('completed_exercises_today');
    // Clearing test results would be more complex, omitted for brevity

    notifyListeners();
  }
}
