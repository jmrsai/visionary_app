import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/app_state_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/feature_card.dart';
import '../widgets/quick_stats_widget.dart';
import '../widgets/daily_tip_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ScrollController _scrollController;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_scrollController.offset <= 100 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuthProvider, AppStateProvider, ThemeProvider>(
      builder: (context, authProvider, appState, themeProvider, child) {
        final user = authProvider.user!;
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(user, isDark, themeProvider),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      _buildWelcomeSection(user, isDark),
                      const SizedBox(height: 24),

                      // Quick stats
                      const QuickStatsWidget(),
                      const SizedBox(height: 24),

                      // Daily tip
                      const DailyTipCard(),
                      const SizedBox(height: 24),

                      // Quick actions
                      _buildQuickActions(context, appState, isDark),
                      const SizedBox(height: 24),

                      // Feature grid
                      _buildFeatureGrid(context, appState, isDark),
                      const SizedBox(height: 100), // Bottom padding for nav
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(dynamic user, bool isDark, ThemeProvider themeProvider) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: AnimatedOpacity(
          opacity: _showAppBarTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: isDark ? AppTheme.textDark : AppTheme.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: isDark ? AppTheme.accentGreen : AppTheme.primaryBlue,
          ),
          onPressed: themeProvider.toggleTheme,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildWelcomeSection(dynamic user, bool isDark) {
    final hour = DateTime.now().hour;
    String greeting;
    String emoji;

    if (hour < 12) {
      greeting = 'Good Morning';
      emoji = '🌅';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      emoji = '☀️';
    } else {
      greeting = 'Good Evening';
      emoji = '🌙';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppTheme.accentGreen.withAlpha(0.2), AppTheme.primaryBlue.withAlpha(0.2)]
              : [AppTheme.primaryBlue.withAlpha(0.1), AppTheme.accentGreen.withAlpha(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDark ? AppTheme.accentGreen : AppTheme.primaryBlue).withAlpha(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, ${user.name}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.textDark : AppTheme.textLight,
                          ),
                    ),
                    Text(
                      'How are your eyes feeling today?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, AppStateProvider appState, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.textDark : AppTheme.textLight,
              ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickActionCard(
                context: context,
                title: 'AI Symptom Check',
                subtitle: 'Quick analysis',
                icon: Icons.psychology,
                color: AppTheme.success,
                onTap: () => appState.setCurrentView(ViewType.symptomChecker),
              ),
              const SizedBox(width: 12),
              _buildQuickActionCard(
                context: context,
                title: 'Vision Test',
                subtitle: 'Check acuity',
                icon: Icons.visibility,
                color: AppTheme.primaryBlue,
                onTap: () => appState.setCurrentView(ViewType.visionTests),
              ),
              const SizedBox(width: 12),
              _buildQuickActionCard(
                context: context,
                title: 'Eye Exercises',
                subtitle: 'Strengthen eyes',
                icon: Icons.fitness_center,
                color: AppTheme.accentGreen,
                onTap: () => appState.setCurrentView(ViewType.exercises),
              ),
              const SizedBox(width: 12),
              _buildQuickActionCard(
                context: context,
                title: 'Kids Zone',
                subtitle: 'Fun activities',
                icon: Icons.child_care,
                color: AppTheme.warning,
                onTap: () => appState.setCurrentView(ViewType.kidsZone),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.secondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, AppStateProvider appState, bool isDark) {
    final features = [
      FeatureData(
        title: 'Symptom Checker',
        description: 'AI-powered symptom analysis',
        icon: Icons.search,
        color: AppTheme.success,
        onTap: () => appState.setCurrentView(ViewType.symptomChecker),
      ),
      FeatureData(
        title: 'Sports Vision',
        description: 'Training for athletes',
        icon: Icons.sports_tennis,
        color: AppTheme.warning,
        onTap: () => appState.setCurrentView(ViewType.sportsVision),
      ),
      FeatureData(
        title: 'Squint Assessment',
        description: 'Check eye alignment',
        icon: Icons.straighten,
        color: AppTheme.error,
        onTap: () => appState.setCurrentView(ViewType.squintAssessment),
      ),
      FeatureData(
        title: 'Disease Detection',
        description: 'AI-powered analysis',
        icon: Icons.biotech,
        color: AppTheme.primaryBlue,
        onTap: () => appState.setCurrentView(ViewType.diseaseDetection),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.textDark : AppTheme.textLight,
              ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            return FeatureCard(
              feature: features[index],
              index: index,
            );
          },
        ),
      ],
    );
  }
}

class FeatureData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  FeatureData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}