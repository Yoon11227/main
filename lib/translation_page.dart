import 'package:flutter/material.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  String transcribedText = '';
  bool isRecording = false;

  void _startRecording() async {
    setState(() {
      isRecording = true;
      transcribedText = 'Recording...';
    });
    
    // Simulate recording and transcription process
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() {
      transcribedText = 'Hello, this is a sample transcribed text from your speech recording.';
      isRecording = false;
    });
  }

  void _clearText() {
    setState(() {
      transcribedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation Page'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Record your speech to convert to text:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            
            // Transcribed Text Display
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Text(
                  transcribedText.isEmpty ? 'Transcribed text will appear here...' : transcribedText,
                  style: TextStyle(
                    fontSize: 16,
                    color: transcribedText.isEmpty ? Colors.grey.shade500 : Colors.black,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Recording Button
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: isRecording ? null : _startRecording,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRecording ? Colors.red.shade500 : Colors.green.shade500,
                        boxShadow: [
                          BoxShadow(
                            color: (isRecording ? Colors.red : Colors.green).withOpacity(0.3),
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
                  const SizedBox(height: 16),
                  Text(
                    isRecording ? 'Recording...' : 'Tap to record',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _clearText,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Clear Text'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}