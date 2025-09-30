import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/feature_card.dart';
import '../widgets/quick_stats_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, isDark),
            const SizedBox(height: 24),
            const QuickStatsWidget(),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Achievements'),
            const SizedBox(height: 12),
            _buildAchievementsGrid(appState.achievements),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Recent Activity'),
            const SizedBox(height: 12),
            _buildRecentActivity(appState.testResults),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Settings'),
            const SizedBox(height: 12),
            _buildSettings(context, isDark),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Logout',
              onPressed: () => _showLogoutConfirmation(context),
              variant: ButtonVariant.danger,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            isDark ? AppTheme.primaryBlue.withAlpha(0.2) : AppTheme.primaryBlue,
            isDark ? AppTheme.accentGreen.withAlpha(77) : AppTheme.accentGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppTheme.primaryBlue.withAlpha(25)
                : AppTheme.primaryBlue.withAlpha(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jane Doe',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'jane.doe@example.com',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildAchievementsGrid(List<String> achievements) {
    if (achievements.isEmpty) {
      return const Text('No achievements yet. Keep playing!');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return FeatureCard(
          title: achievement,
          icon: Icons.star,
          onTap: () {},
        );
      },
    );
  }

  Widget _buildRecentActivity(List<TestResult> testResults) {
    if (testResults.isEmpty) {
      return const Text('No recent activity.');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: testResults.length > 3 ? 3 : testResults.length,
      itemBuilder: (context, index) {
        final result = testResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.check_circle_outline, color: AppTheme.success),
            title: Text(result.testName, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              'Score: ${result.score.toStringAsFixed(1)} - ${result.timestamp.day}/${result.timestamp.month}',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildSettings(BuildContext context, bool isDark) {
    return Card(
      child: Column(
        children: [
          _buildSettingsTile(
            context,
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: Switch(
              value: isDark,
              onChanged: (value) {},
              activeTrackColor: AppTheme.accentGreen,
              activeThumbImage: const AssetImage('assets/images/moon.png'),
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notifications,
            title: 'Notifications',
            trailing: Switch(
              value: true, // This should be managed by a provider
              onChanged: (value) {},
              activeTrackColor: AppTheme.accentGreen,
            ),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: 'About Us',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
      {
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.titleMedium),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                // Perform logout logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
