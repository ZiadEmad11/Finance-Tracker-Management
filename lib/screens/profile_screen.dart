import 'package:flutter/material.dart';
import 'package:moneywise/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            _buildSettingsSection(context),
            const SizedBox(height: 24),
            _buildAppSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      color: AppTheme.darkTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.darkTheme.primaryColor.withOpacity(0.2),
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: AppTheme.darkTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "John Doe",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "john.doe@example.com",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.darkTheme.primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text("Edit Profile"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      color: AppTheme.darkTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "Settings",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            _buildListTile(
              context,
              Icons.notifications_rounded,
              "Notifications",
              Icons.chevron_right,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildListTile(
              context,
              Icons.lock_rounded,
              "Security",
              Icons.chevron_right,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildListTile(
              context,
              Icons.palette_rounded,
              "Appearance",
              Icons.chevron_right,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildListTile(
              context,
              Icons.language_rounded,
              "Language",
              Icons.chevron_right,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSection(BuildContext context) {
    return Card(
      color: AppTheme.darkTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "App",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            _buildListTile(
              context,
              Icons.help_rounded,
              "Help & Support",
              Icons.chevron_right,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildListTile(
              context,
              Icons.star_rounded,
              "Rate Us",
              Icons.chevron_right,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildListTile(
              context,
              Icons.share_rounded,
              "Share App",
              Icons.chevron_right,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildListTile(
              context,
              Icons.info_rounded,
              "About",
              Icons.chevron_right,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 16),
            _buildListTile(
              context,
              Icons.exit_to_app_rounded,
              "Sign Out",
              null,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('hasCompletedOnboarding', false);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                      (Route<dynamic> route) => false,
                );
              },
              textColor: Colors.redAccent[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context,
      IconData leadingIcon,
      String title,
      IconData? trailingIcon, {
        Color? textColor,
        required VoidCallback onTap,
      }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        leadingIcon,
        color: textColor ?? AppTheme.darkTheme.primaryColor,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: textColor ?? Colors.white,
        ),
      ),
      trailing: trailingIcon != null
          ? Icon(
        trailingIcon,
        color: Colors.grey[600],
      )
          : null,
    );
  }
}