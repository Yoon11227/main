import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'translation_page.dart';
import 'pronunciation_practice_page.dart';
import 'history_page.dart';
import 'settings_page.dart';
import 'translation_page.dart';
import 'pronunciation_practice_page.dart';
import 'history_page.dart';
import 'settings_page.dart';

void main() {
  runApp(const PronounceRightApp());
}

class PronounceRightApp extends StatelessWidget {
  const PronounceRightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PronounceRight',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  bool showMenuButtons = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _handleStartPressed() {
    HapticFeedback.lightImpact();
    setState(() {
      showMenuButtons = true;
    });
    _slideController.forward();
  }

  void _handleBackPressed() {
    _slideController.reverse().then((_) {
      setState(() {
        showMenuButtons = false;
      });
    });
  }

  void _navigateToPage(String pageName) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _getPageWidget(pageName),
      ),
    );
  }

  Widget _getPageWidget(String pageName) {
    switch (pageName) {
      case 'Translation Page':
        return const TranslationPage();
      case 'Pronunciation Practice':
        return const PronunciationPracticePage();
      case 'History':
        return const HistoryPage();
      case 'Settings':
        return const SettingsPage();
      default:
        return const MainPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
            child: Column(
              children: [
                // Header
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  'PronounceRight',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  'Perfect your pronunciation with AI',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                
                // Company Logo (Recording Button)
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade400,
                        Colors.blue.shade600,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mic,
                    size: MediaQuery.of(context).size.width * 0.15,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                
                // Main Buttons or Menu Buttons
                Expanded(
                  child: showMenuButtons ? _buildMenuButtons() : _buildMainButtons(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainButtons() {
    return Column(
      children: [
        // Start Button
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.08,
          child: ElevatedButton(
            onPressed: _handleStartPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Start',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ),
        ),
        
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        
        // Join a Member Button
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.08,
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Join Member feature coming soon!')),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue.shade600,
              side: BorderSide(color: Colors.blue.shade600, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Join a Member',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade600,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons() {
    final menuItems = [
      {'name': 'Pronunciation Practice', 'icon': Icons.record_voice_over, 'color': Colors.blue},
      {'name': 'History', 'icon': Icons.history, 'color': Colors.purple},
      {'name': 'Settings', 'icon': Icons.settings, 'color': Colors.grey},
    ];

    return Column(
      children: [
        // Back Button
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: _handleBackPressed,
            icon: const Icon(Icons.arrow_back),
            iconSize: MediaQuery.of(context).size.width * 0.07,
          ),
        ),
        
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        
        // Menu Buttons
        Expanded(
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: menuItems.map((item) => Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: ElevatedButton(
                    onPressed: () => _navigateToPage(item['name'] as String),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (item['color'] as MaterialColor).shade50,
                      foregroundColor: (item['color'] as MaterialColor).shade700,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: (item['color'] as MaterialColor).shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: MediaQuery.of(context).size.width * 0.07,
                          color: (item['color'] as MaterialColor).shade600,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                        Text(
                          item['name'] as String,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: (item['color'] as MaterialColor).shade700,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: MediaQuery.of(context).size.width * 0.04,
                          color: (item['color'] as MaterialColor).shade400,
                        ),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }
}