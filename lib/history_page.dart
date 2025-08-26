import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Map<String, dynamic>> historyItems = [
    {
      'word': 'pronunciation',
      'score': 92,
      'date': '2024-01-15',
      'type': 'Practice',
      'attempts': 3,
    },
    {
      'word': 'beautiful',
      'score': 88,
      'date': '2024-01-14',
      'type': 'Practice',
      'attempts': 2,
    },
    {
      'word': 'wonderful',
      'score': 95,
      'date': '2024-01-13',
      'type': 'Practice',
      'attempts': 1,
    },
    {
      'word': 'communication',
      'score': 85,
      'date': '2024-01-12',
      'type': 'Practice',
      'attempts': 4,
    },
    {
      'word': 'international',
      'score': 90,
      'date': '2024-01-11',
      'type': 'Practice',
      'attempts': 2,
    },
  ];

  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Practice', 'Test', 'Translation'];

  List<Map<String, dynamic>> get filteredItems {
    if (selectedFilter == 'All') return historyItems;
    return historyItems.where((item) => item['type'] == selectedFilter).toList();
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.orange;
    return Colors.red;
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                historyItems.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History cleared successfully!')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _clearHistory,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Statistics
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade50, Colors.purple.shade100],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Practice Statistics',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Total', '${historyItems.length}', Icons.list),
                      _buildStatItem('Avg Score', '${_calculateAverageScore()}%', Icons.trending_up),
                      _buildStatItem('Best', '${_getBestScore()}%', Icons.star),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            
            // Filter Chips
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filterOptions.length,
                itemBuilder: (context, index) {
                  final option = filterOptions[index];
                  final isSelected = selectedFilter == option;
                  
                  return Padding(
                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
                    child: FilterChip(
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = option;
                        });
                      },
                      selectedColor: Colors.purple.shade100,
                      checkmarkColor: Colors.purple.shade600,
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            
            // History List
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: MediaQuery.of(context).size.width * 0.15,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Text(
                            'No history found',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.015),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                            leading: CircleAvatar(
                              backgroundColor: _getScoreColor(item['score']).withOpacity(0.2),
                              radius: MediaQuery.of(context).size.width * 0.06,
                              child: Text(
                                '${item['score']}',
                                style: TextStyle(
                                  color: _getScoreColor(item['score']).withOpacity(0.9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                            ),
                            title: Text(
                              item['word'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                                Text(
                                  'Date: ${item['date']} • ${item['type']}',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.03,
                                  ),
                                ),
                                Text(
                                  'Attempts: ${item['attempts']}',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.03,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade400,
                              size: MediaQuery.of(context).size.width * 0.04,
                            ),
                            onTap: () {
                              _showDetailDialog(item);
                            },
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

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.purple.shade600,
          size: MediaQuery.of(context).size.width * 0.06,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: Colors.purple.shade700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            color: Colors.purple.shade600,
          ),
        ),
      ],
    );
  }

  int _calculateAverageScore() {
    if (historyItems.isEmpty) return 0;
    final total = historyItems.fold<int>(0, (sum, item) => sum + (item['score'] as int));
    return (total / historyItems.length).round();
  }

  int _getBestScore() {
    if (historyItems.isEmpty) return 0;
    return historyItems.map((item) => item['score'] as int).reduce((a, b) => a > b ? a : b);
  }

  void _showDetailDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item['word'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score: ${item['score']}%'),
            Text('Date: ${item['date']}'),
            Text('Type: ${item['type']}'),
            Text('Attempts: ${item['attempts']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}