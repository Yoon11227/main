import 'package:flutter/material.dart';
import 'dart:math';

class PronunciationPracticePage extends StatefulWidget {
  const PronunciationPracticePage({super.key});

  @override
  State<PronunciationPracticePage> createState() => _PronunciationPracticePageState();
}

class _PronunciationPracticePageState extends State<PronunciationPracticePage> with TickerProviderStateMixin {
  final List<String> practiceWords = [
    'pronunciation', 'beautiful', 'wonderful', 'communication', 
    'international', 'education', 'development', 'environment'
  ];
  
  String selectedWord = '';
  bool isRecording = false;
  String feedback = '';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
    
    _pulseController.repeat(reverse: true);
    
    await Future.delayed(const Duration(seconds: 3));
    
    _pulseController.stop();
    _pulseController.reset();
    
    final isCorrect = Random().nextDouble() > 0.3;
    final score = 75 + Random().nextInt(25);
    
    setState(() {
      isRecording = false;
      feedback = isCorrect 
          ? 'Excellent pronunciation! Score: $score%' 
          : 'Good try! Focus on vowel sounds. Score: $score%';
    });
  }

  void _resetPractice() {
    setState(() {
      selectedWord = '';
      feedback = '';
      isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Practice'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _resetPractice,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a word to practice:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            
            // Word Selection Grid
            Expanded(
              flex: 2,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: practiceWords.length,
                itemBuilder: (context, index) {
                  final word = practiceWords[index];
                  final isSelected = selectedWord == word;
                  
                  return GestureDetector(
                    onTap: () => _selectWord(word),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          word,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            
            // Selected Word and Recording Section
            if (selectedWord.isNotEmpty) ...[
              Center(
                child: Column(
                  children: [
                    Text(
                      'Practice Word:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      selectedWord,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                        fontSize: MediaQuery.of(context).size.width * 0.07,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    
                    // Recording Button
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isRecording ? _pulseAnimation.value : 1.0,
                          child: GestureDetector(
                            onTap: isRecording ? null : _startRecording,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              height: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isRecording ? Colors.red.shade500 : Colors.blue.shade500,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isRecording ? Colors.red : Colors.blue).withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.mic,
                                size: MediaQuery.of(context).size.width * 0.1,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    
                    Text(
                      isRecording ? 'Recording...' : 'Tap to record',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            
            // Feedback Section
            if (feedback.isNotEmpty && !isRecording)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                decoration: BoxDecoration(
                  color: feedback.contains('Excellent') ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: feedback.contains('Excellent') ? Colors.green.shade200 : Colors.orange.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  feedback,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}