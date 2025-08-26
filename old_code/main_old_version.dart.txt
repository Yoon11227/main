import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

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
      case 'Translation':
        return const TranslationPage();
      case 'Test':
        return const TestPage();
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                const SizedBox(height: 40),
                Text(
                  'PronounceRight',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Perfect your pronunciation with AI',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 60),
                
                // Company Logo (Recording Button)
                Container(
                  width: 140,
                  height: 140,
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
                  child: const Icon(
                    Icons.mic,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 80),
                
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
          height: 60,
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
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Join a Member Button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Handle join member functionality
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
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons() {
    final menuItems = [
      {'name': 'Translation Page', 'icon': Icons.translate, 'color': Colors.green},
      {'name': 'Test Page', 'icon': Icons.quiz, 'color': Colors.orange},
      {'name': 'Pronunciation Practice', 'icon': Icons.record_voice_over, 'color': Colors.blue},
      {'name': 'History Page', 'icon': Icons.history, 'color': Colors.purple},
      {'name': 'Settings Page', 'icon': Icons.settings, 'color': Colors.grey},
    ];

    return Column(
      children: [
        // Back Button
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: _handleBackPressed,
            icon: const Icon(Icons.arrow_back),
            iconSize: 28,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Menu Buttons
        Expanded(
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: menuItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 70,
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
                          size: 28,
                          color: (item['color'] as MaterialColor).shade600,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          item['name'] as String,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: (item['color'] as MaterialColor).shade700,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
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

// Translation Page
class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final TextEditingController _textController = TextEditingController();
  String translatedText = '';
  bool isTranslating = false;

  void _translateText() async {
    if (_textController.text.isEmpty) return;
    
    setState(() {
      isTranslating = true;
    });
    
    // Simulate translation process
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      translatedText = 'Translated: ${_textController.text}';
      isTranslating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation Page'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter text to translate:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Type your text here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isTranslating ? null : _translateText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isTranslating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Translate'),
              ),
            ),
            const SizedBox(height: 24),
            if (translatedText.isNotEmpty) ...[
              Text(
                'Translation Result:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  translatedText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Test Page
class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final List<String> exampleSentences = [
    'The quick brown fox jumps over the lazy dog.',
    'She sells seashells by the seashore.',
    'How much wood would a woodchuck chuck?',
    'Peter Piper picked a peck of pickled peppers.',
  ];
  
  int currentSentenceIndex = 0;
  bool isRecording = false;
  String feedback = '';

  void _startRecording() async {
    setState(() {
      isRecording = true;
      feedback = 'Recording...';
    });
    
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() {
      isRecording = false;
      feedback = 'Good pronunciation! Score: ${85 + Random().nextInt(15)}%';
    });
  }

  void _nextSentence() {
    setState(() {
      currentSentenceIndex = (currentSentenceIndex + 1) % exampleSentences.length;
      feedback = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Practice Sentence:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Text(
                exampleSentences[currentSentenceIndex],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: isRecording ? null : _startRecording,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRecording ? Colors.red.shade500 : Colors.orange.shade500,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (feedback.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  feedback,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextSentence,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Next Sentence'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pronunciation Practice Page
class PronunciationPracticePage extends StatefulWidget {
  const PronunciationPracticePage({super.key});

  @override
  State<PronunciationPracticePage> createState() => _PronunciationPracticePageState();
}

class _PronunciationPracticePageState extends State<PronunciationPracticePage> {
  final List<String> practiceWords = [
    'pronunciation', 'beautiful', 'wonderful', 'communication', 'international', 'education'
  ];
  
  String selectedWord = '';
  bool isRecording = false;
  String feedback = '';

  void _selectWord(String word) {
    setState(() {
      selectedWord = word;
      feedback = '';
    });
  }

  void _startRecording() async {
    if (selectedWord.isEmpty) return;
    
    setState(() {
      isRecording = true;
      feedback = 'Recording...';
    });
    
    await Future.delayed(const Duration(seconds: 2));
    
    final isCorrect = Random().nextDouble() > 0.3;
    setState(() {
      isRecording = false;
      feedback = isCorrect 
          ? 'Excellent pronunciation!' 
          : 'Try again - focus on the vowel sounds';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Practice'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a word to practice:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: practiceWords.map((word) => 
                GestureDetector(
                  onTap: () => _selectWord(word),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: selectedWord == word ? Colors.blue.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedWord == word ? Colors.blue.shade300 : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      word,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: selectedWord == word ? Colors.blue.shade700 : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ).toList(),
            ),
            const SizedBox(height: 40),
            if (selectedWord.isNotEmpty) ...[
              Center(
                child: Column(
                  children: [
                    Text(
                      'Practice:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedWord,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: _startRecording,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isRecording ? Colors.red.shade500 : Colors.blue.shade500,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mic,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 30),
            if (feedback.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: feedback.contains('Excellent') ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: feedback.contains('Excellent') ? Colors.green.shade200 : Colors.orange.shade200,
                  ),
                ),
                child: Text(
                  feedback,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// History Page
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyItems = [
      {'word': 'pronunciation', 'score': 92, 'date': '2024-01-15'},
      {'word': 'beautiful', 'score': 88, 'date': '2024-01-14'},
      {'word': 'wonderful', 'score': 95, 'date': '2024-01-13'},
      {'word': 'communication', 'score': 85, 'date': '2024-01-12'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('History Page'),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Practice History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: historyItems.length,
                itemBuilder: (context, index) {
                  final item = historyItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple.shade100,
                        child: Text(
                          '${item['score']}',
                          style: TextStyle(
                            color: Colors.purple.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        item['word'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('Date: ${item['date']}'),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.shade400,
                        size: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool soundEnabled = true;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
        backgroundColor: Colors.grey.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // User Information
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('User Information'),
                subtitle: const Text('Edit your profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User Information feature coming soon!')),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Notifications
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                subtitle: const Text('Enable push notifications'),
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Sound
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.volume_up),
                title: const Text('Sound Effects'),
                subtitle: const Text('Enable sound feedback'),
                value: soundEnabled,
                onChanged: (value) {
                  setState(() {
                    soundEnabled = value;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Reset Progress
            Card(
              child: ListTile(
                leading: const Icon(Icons.refresh, color: Colors.orange),
                title: const Text('Reset Progress'),
                subtitle: const Text('Clear all test and practice data'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset Progress'),
                      content: const Text('Are you sure you want to reset all your progress? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Progress reset successfully!')),
                            );
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}