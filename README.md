# Visionary App - Flutter Eye Health Companion

A comprehensive Flutter eye health application with AI-powered features, vision tests, and interactive exercises.

## Features

### 🔍 AI-Powered Health Assistant
- Intelligent symptom checker with natural language processing
- Interactive chatbot for eye health questions and advice
- Personalized recommendations based on user input

### 👁️ Comprehensive Vision Tests
- **Visual Acuity Test** - Measure sharpness of vision
- **Amsler Grid Test** - Check for macular degeneration
- **Color Vision Test** - Test for color blindness
- **Astigmatism Test** - Check for irregular cornea shape
- **Peripheral Vision Test** - Test side vision capabilities
- **Contrast Sensitivity** - Measure ability to see contrasts

### 💪 Interactive Eye Exercises
- **Blinking Exercises** - Reduce dry eyes and refresh vision
- **Focus Shifting** - Improve focusing ability and reduce strain
- **Eye Rotations** - Strengthen eye muscles and improve mobility
- **Palming Relaxation** - Deep relaxation for tired eyes

### 🎯 Advanced Features
- Sports vision training for athletes
- Squint assessment tools
- AI-powered ocular disease detection
- Kids Zone with fun vision games and activities

### 🎨 Design & Experience
- **Modern UI/UX** - Clean, intuitive interface with smooth animations
- **Dark/Light Mode** - Automatic theme switching with user preference
- **Color Palette** - Deep blue (#1A3A6D) and soft green (#6DDCCF) for optimal eye comfort
- **Accessibility** - Designed with eye health and accessibility in mind

### 📊 Progress Tracking
- Test results history and analytics
- Achievement system with Sparkle Stars rewards
- Progress visualization and insights
- Personalized recommendations

## Technology Stack

- **Flutter** - Cross-platform mobile development
- **Provider** - State management
- **Shared Preferences** - Local data persistence
- **Google Fonts** - Typography
- **Flutter Animate** - Smooth animations and transitions
- **Material Design 3** - Modern UI components

## Getting Started

### Prerequisites
- Flutter SDK (>=3.13.0)
- Dart SDK (>=3.1.0)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/visionary-app.git
   cd visionary-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   └── chat_message.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── app_state_provider.dart
│   └── theme_provider.dart
├── screens/                  # App screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── onboarding_screen.dart
│   ├── main_navigation_screen.dart
│   ├── dashboard_screen.dart
│   ├── vision_tests_screen.dart
│   ├── exercises_screen.dart
│   ├── ai_chatbot_screen.dart
│   ├── profile_screen.dart
│   └── [other_screens].dart
├── widgets/                  # Reusable UI components
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   ├── feature_card.dart
│   ├── quick_stats_widget.dart
│   └── [other_widgets].dart
└── theme/                    # App theming
    └── app_theme.dart
```

## Key Features Implementation

### Authentication System
- Email/password login and registration
- Persistent session management
- User profile management
- Secure logout functionality

### Vision Testing Suite
- Professional-grade vision tests
- Guided test instructions
- Result storage and tracking
- Progress analytics

### AI Health Assistant
- Natural language chatbot interface
- Symptom analysis and recommendations
- Suggested responses for better interaction
- Context-aware conversations

### Exercise System
- Guided eye exercise routines
- Step-by-step instructions
- Timer-based sessions
- Progress tracking

## Design Philosophy

The app follows a **calm, clear, and confident** design approach:

- **Calm**: Soothing colors and gentle animations reduce eye strain
- **Clear**: Intuitive navigation and clear information hierarchy
- **Confident**: Professional design instills trust in health recommendations

## Color Palette

- **Primary Blue**: #1A3A6D - Trust, reliability, medical professionalism
- **Accent Green**: #6DDCCF - Health, growth, positive outcomes
- **Success Green**: #10B981 - Positive results and achievements
- **Warning Orange**: #F59E0B - Caution and attention
- **Error Red**: #EF4444 - Alerts and important warnings

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

**Important**: This application is designed for educational and wellness purposes only. It is not intended to replace professional medical advice, diagnosis, or treatment. Always consult with qualified eye care professionals for any vision concerns or before making health-related decisions.

## Support

For support, email support@visionaryapp.com or open an issue in the GitHub repository.

---

**Visionary App** - Your comprehensive vision health companion 👁️✨