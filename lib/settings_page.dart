import 'package:flutter/material.dart';
import 'customization_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool soundEnabled = true;
  bool hapticFeedbackEnabled = true;
  String selectedLanguage = 'English';
  String selectedVoice = 'Female';

  final List<String> languages = ['English', 'Spanish', 'French', 'German', 'Japanese'];
  final List<String> voices = ['Female', 'Male'];

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data'),
        content: const Text('Are you sure you want to reset all data? This will clear your history, settings, and progress. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data has been reset!')),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToCustomization() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomizationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.grey.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: ListView(
          children: [
            // User Information Section
            _buildSectionHeader('User Information'),
            _buildInfoTile(
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'Manage your profile information',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile management coming soon!')),
                );
              },
            ),
            _buildInfoTile(
              icon: Icons.email,
              title: 'Account',
              subtitle: 'john.doe@example.com',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account settings coming soon!')),
                );
              },
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            
            // App Settings Section
            _buildSectionHeader('App Settings'),
            _buildSwitchTile(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Receive practice reminders',
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            _buildSwitchTile(
              icon: Icons.volume_up,
              title: 'Sound Effects',
              subtitle: 'Play sounds for feedback',
              value: soundEnabled,
              onChanged: (value) {
                setState(() {
                  soundEnabled = value;
                });
              },
            ),
            _buildSwitchTile(
              icon: Icons.vibration,
              title: 'Haptic Feedback',
              subtitle: 'Vibrate on button press',
              value: hapticFeedbackEnabled,
              onChanged: (value) {
                setState(() {
                  hapticFeedbackEnabled = value;
                });
              },
            ),
            
            // Language Settings
            _buildDropdownTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'App interface language',
              value: selectedLanguage,
              items: languages,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
            _buildDropdownTile(
              icon: Icons.record_voice_over,
              title: 'Voice',
              subtitle: 'Pronunciation guide voice',
              value: selectedVoice,
              items: voices,
              onChanged: (value) {
                setState(() {
                  selectedVoice = value!;
                });
              },
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            
            // Customization Section
            _buildSectionHeader('Customization'),
            _buildInfoTile(
              icon: Icons.tune,
              title: 'Customization',
              subtitle: 'Customize pronunciation input settings',
              onTap: _navigateToCustomization,
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            
            // Data Management Section
            _buildSectionHeader('Data Management'),
            _buildInfoTile(
              icon: Icons.refresh,
              title: 'Reset All Data',
              subtitle: 'Clear all progress and settings',
              onTap: _showResetDialog,
              textColor: Colors.red,
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            
            // About Section
            _buildSectionHeader('About'),
            _buildInfoTile(
              icon: Icons.info,
              title: 'App Version',
              subtitle: '1.0.0',
              onTap: null,
            ),
            _buildInfoTile(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help with the app',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.01,
        top: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.045,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: textColor ?? Colors.grey.shade600,
          size: MediaQuery.of(context).size.width * 0.06,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.035,
          ),
        ),
        trailing: onTap != null
            ? Icon(
                Icons.arrow_forward_ios,
                size: MediaQuery.of(context).size.width * 0.04,
                color: Colors.grey.shade400,
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: Icon(
          icon,
          color: Colors.grey.shade600,
          size: MediaQuery.of(context).size.width * 0.06,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.035,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue.shade600,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.grey.shade600,
          size: MediaQuery.of(context).size.width * 0.06,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.035,
          ),
        ),
        trailing: DropdownButton<String>(
          value: value,
          underline: Container(),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}