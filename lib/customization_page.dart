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
        const SnackBar(content: Text('먼저 연습할 텍스트를 입력하세요!')),
      );
      return;
    }
    
    setState(() {
      isRecording = true;
      feedback = '녹음중...';
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
          ? '훌륭한 발음입니다! 점수: $score%' 
          : '수고하셨습니다! 좀 더 명확하게 발음해보세요. 점수: $score%';
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
        title: const Text('발음 맞춤 설정'),
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
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Practice Sentence Display
              Text(
                '연습 문장:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade200),
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
                    customText.isEmpty 
                        ? '어눌한 말을 텍스트로 보여주는 앱을 위한 발음 연습입니다.'
                        : customText,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.indigo.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Recording Button
              Center(
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isRecording ? _pulseAnimation.value : 1.0,
                          child: GestureDetector(
                            onTap: isRecording ? null : _startRecording,
                            child: Container(
                              width: 100,
                              height: 100,
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
                              child: const Icon(
                                Icons.mic,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isRecording ? '녹음 중...' : '녹음하려면 탭하세요',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Custom Text Input Section (Optional)
              ExpansionTile(
                title: const Text(
                  '원하는 문장 입력',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _textController,
                      maxLines: 4,
                      onChanged: (value) {
                        setState(() {
                          customText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '연습할 문장을 입력하세요...',
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
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // Customization Settings
              const SizedBox(height: 24),
              _buildSectionHeader('녹음 설정'),
              _buildSliderSetting(
                '녹음 시간',
                '${recordingDuration.round()} 초',
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
                '피드백 민감도',
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
              
              const SizedBox(height: 16),
              
              _buildSectionHeader('연습 모드'),
              _buildDropdownSetting(
                '발음 모드',
                '연습 유형 선택',
                pronunciationMode,
                pronunciationModes,
                (value) {
                  setState(() {
                    pronunciationMode = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildSectionHeader('오디오 설정'),
              _buildSwitchSetting(
                '자동 재생',
                '녹음 완료 후 재생',
                autoPlayback,
                (value) {
                  setState(() {
                    autoPlayback = value;
                  });
                },
              ),
              _buildSwitchSetting(
                '파형 표시',
                '녹음 중 오디오 파형 표시',
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
        bottom: 12,
        top: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
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
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    fontSize: 16,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.indigo.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
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
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
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
                  fontSize: 14,
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