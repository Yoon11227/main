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
  String selectedVoice = '여성';

  final List<String> voices = ['여성', '남성'];

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('모든 데이터 초기화'),
        content: const Text('정말로 모든 데이터를 초기화하시겠습니까? 기록, 설정, 진행 상황이 모두 지워집니다. 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('모든 데이터가 초기화 되었습니다!')),
              );
            },
            child: const Text('초기화', style: TextStyle(color: Colors.red)),
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
        title: const Text('설정'),
        backgroundColor: Colors.grey.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // User Information Section
            _buildSectionHeader('사용자 정보'),
            _buildInfoTile(
              icon: Icons.person,
              title: '프로필',
              subtitle: '프로필 정보 관리',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('프로필 관리는 곧 추가될 예정입니다!')),
                );
              },
            ),
            _buildInfoTile(
              icon: Icons.email,
              title: '계정',
              subtitle: 'john.doe@example.com',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('계정 설정은 곧 추가될 예정입니다!')),
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
                      '맞춤 설정',
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
            _buildSectionHeader('앱 성정'),
            _buildSwitchTile(
              icon: Icons.notifications,
              title: '알림',
              subtitle: '연습 알림 받기',
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            _buildSwitchTile(
              icon: Icons.volume_up,
              title: '효과음',
              subtitle: '피드백 시 효과음 재생',
              value: soundEnabled,
              onChanged: (value) {
                setState(() {
                  soundEnabled = value;
                });
              },
            ),
            _buildSwitchTile(
              icon: Icons.vibration,
              title: '진동',
              subtitle: '버튼 터치 시 진동',
              value: hapticFeedbackEnabled,
              onChanged: (value) {
                setState(() {
                  hapticFeedbackEnabled = value;
                });
              },
            ),
            
            _buildDropdownTile(
              icon: Icons.record_voice_over,
              title: '음성',
              subtitle: '발음 안내 음성',
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
            _buildSectionHeader('데이터 관리'),
            _buildInfoTile(
              icon: Icons.refresh,
              title: '모든 데이터 초기화',
              subtitle: '모든 진행 상황 및 설정 지우기',
              onTap: _showResetDialog,
              textColor: Colors.red,
            ),
            
            const SizedBox(height: 24.0),
            
            // About Section
            _buildSectionHeader('정보'),
            _buildInfoTile(
              icon: Icons.info,
              title: '앱 버전',
              subtitle: '1.0.0',
              onTap: null,
            ),
            _buildInfoTile(
              icon: Icons.help,
              title: '도움말 및 지원',
              subtitle: '앱 사용 도움말',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('곧 추가될 기능입니다!')),
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