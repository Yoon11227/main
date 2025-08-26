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
  String selectedVoice = 'Female';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            // Customization button under User Information
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              height: 60.0,
              child: ElevatedButton(
                onPressed: _navigateToCustomization,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade50,
                  foregroundColor: Colors.indigo.shade700,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.indigo.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tune,
                      size: 28.0,
                      color: Colors.indigo.shade600,
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      'Customization',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.shade700,
                        fontSize: 16.0,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.0,
                      color: Colors.indigo.shade400,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24.0),
            
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
            
            const SizedBox(height: 24.0),
            
            // Data Management Section
            _buildSectionHeader('Data Management'),
            _buildInfoTile(
              icon: Icons.refresh,
              title: 'Reset All Data',
              subtitle: 'Clear all progress and settings',
              onTap: _showResetDialog,
              textColor: Colors.red,
            ),
            
            const SizedBox(height: 24.0),
            
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
      padding: const EdgeInsets.only(
        bottom: 8.0,
        top: 8.0,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
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
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: textColor ?? Colors.grey.shade600,
          size: 24.0,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
        trailing: onTap != null
            ? Icon(
                Icons.arrow_forward_ios,
                size: 16.0,
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
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: Icon(
          icon,
          color: Colors.grey.shade600,
          size: 24.0,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14.0,
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
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.grey.shade600,
          size: 24.0,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14.0,
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
                style: const TextStyle(
                  fontSize: 14.0,
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