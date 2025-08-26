import 'package:flutter/material.dart';
import 'dart:math';

class CustomizationPage extends StatefulWidget {
  const CustomizationPage({super.key});

  @override
  State<CustomizationPage> createState() => _CustomizationPageState();
}

class _CustomizationPageState extends State<CustomizationPage> with TickerProviderStateMixin {
  bool isRecording = false;
  String feedback = '';
  String customText = '';
  final TextEditingController _textController = TextEditingController();
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Customization Settings
  double recordingDuration = 5.0;
  double feedbackSensitivity = 0.7;
  bool autoPlayback = true;
  bool showWaveform = true;
  String pronunciationMode = 'Word';

  final List<String> pronunciationModes = ['Word', 'Sentence', 'Paragraph'];

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
    _textController.dispose();
    super.dispose();
  }

  void _startRecording() async {
    if (customText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text to practice first!')),
      );
      return;
    }
    
    setState(() {
      isRecording = true;
      feedback = 'Recording...';
    });
    
    _pulseController.repeat(reverse: true);
    
    await Future.delayed(Duration(seconds: recordingDuration.round()));
    
    _pulseController.stop();
    _pulseController.reset();
    
    final isCorrect = Random().nextDouble() > (1 - feedbackSensitivity);
    final score = (70 + Random().nextInt(30)).clamp(0, 100);
    
    setState(() {
      isRecording = false;
      feedback = isCorrect 
          ? 'Excellent pronunciation! Score: $score%' 
          : 'Good effort! Try focusing on clarity. Score: $score%';
    });
  }

  void _clearText() {
    setState(() {
      _textController.clear();
      customText = '';
      feedback = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Customization'),
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _clearText,
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Text Input Section
              _buildSectionHeader('Custom Text Input'),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: 4,
                  onChanged: (value) {
                    setState(() {
                      customText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your custom text to practice pronunciation...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.indigo.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.indigo.shade400, width: 2),
                    ),
                  ),
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ),
              
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              
              // Recording Section
              if (customText.isNotEmpty) ...[
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Practice Text:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      Container(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.indigo.shade200),
                        ),
                        child: Text(
                          customText,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.w500,
                            color: Colors.indigo.shade700,
                          ),
                          textAlign: TextAlign.center,
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
                                  color: isRecording ? Colors.red.shade500 : Colors.indigo.shade500,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (isRecording ? Colors.red : Colors.indigo).withOpacity(0.3),
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
                
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
              
              // Feedback Section
              if (feedback.isNotEmpty && !isRecording) ...[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  decoration: BoxDecoration(
                    color: feedback.contains('Excellent') ? Colors.green.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: feedback.contains('Excellent') ? Colors.green.shade200 : Colors.orange.shade200,
                    ),
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
              
              // Customization Settings
              _buildSectionHeader('Recording Settings'),
              _buildSliderSetting(
                'Recording Duration',
                '${recordingDuration.round()} seconds',
                recordingDuration,
                1.0,
                10.0,
                (value) {
                  setState(() {
                    recordingDuration = value;
                  });
                },
              ),
              _buildSliderSetting(
                'Feedback Sensitivity',
                '${(feedbackSensitivity * 100).round()}%',
                feedbackSensitivity,
                0.1,
                1.0,
                (value) {
                  setState(() {
                    feedbackSensitivity = value;
                  });
                },
              ),
              
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              
              _buildSectionHeader('Practice Mode'),
              _buildDropdownSetting(
                'Pronunciation Mode',
                'Choose practice type',
                pronunciationMode,
                pronunciationModes,
                (value) {
                  setState(() {
                    pronunciationMode = value!;
                  });
                },
              ),
              
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              
              _buildSectionHeader('Audio Settings'),
              _buildSwitchSetting(
                'Auto Playback',
                'Play recording after completion',
                autoPlayback,
                (value) {
                  setState(() {
                    autoPlayback = value;
                  });
                },
              ),
              _buildSwitchSetting(
                'Show Waveform',
                'Display audio waveform during recording',
                showWaveform,
                (value) {
                  setState(() {
                    showWaveform = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.015,
        top: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.045,
          fontWeight: FontWeight.bold,
          color: Colors.indigo.shade700,
        ),
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    String value,
    double currentValue,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.015),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.indigo.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                  ),
                ),
              ],
            ),
            Slider(
              value: currentValue,
              min: min,
              max: max,
              divisions: ((max - min) * 10).round(),
              activeColor: Colors.indigo.shade600,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.015),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
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
        activeColor: Colors.indigo.shade600,
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String subtitle,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.015),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
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