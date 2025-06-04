import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'article_menu.dart';
import 'meditation.dart';
import 'music.dart';

void main() {
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/mood_tracker',
      routes: {
        '/home': (context) => const LandingPage(),
        '/mood_tracker': (context) => const MoodTrackerScreen(),
        '/articles': (context) => const ArticlesApp(),
        '/meditation': (context) => const MeditationTimerPage(),
        '/music': (context) => const MusicListApp(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  int _selectedIndex = 1; // Default to mood tracker (index 1)
  String _selectedMood = 'Happy';
  bool _showOkButton = false;

  final List<Map<String, dynamic>> _mainMoods = [
    {'emoji': '😊', 'color': Color(0xFF4a7ab8), 'label': 'Happy'},
    {'emoji': '😐', 'color': Color(0xFF3a5f9a), 'label': 'Neutral'},
    {'emoji': '😠', 'color': Color(0xFF3a5f9a), 'label': 'Angry'},
    {'emoji': '😢', 'color': Color(0xFF3a5f9a), 'label': 'Sad'},
  ];

  final Map<String, List<Map<String, String>>> _categorizedDetailedMoods = {
    'Happy': [
      {'emoji': '😄', 'label': 'Joyful'},
      {'emoji': '🤩', 'label': 'Excited'},
      {'emoji': '😇', 'label': 'Grateful'},
      {'emoji': '😜', 'label': 'Silly'},
    ],
    'Neutral': [
      {'emoji': '🤔', 'label': 'Thinking'},
      {'emoji': '😌', 'label': 'Calm'},
      {'emoji': '😶', 'label': 'Neutral'},
      {'emoji': '🙂', 'label': 'Slightly Happy'},
    ],
    'Angry': [
      {'emoji': '😡', 'label': 'Angry'},
      {'emoji': '🤬', 'label': 'Rage'},
      {'emoji': '😤', 'label': 'Frustrated'},
      {'emoji': '👿', 'label': 'Devilish'},
    ],
    'Sad': [
      {'emoji': '😞', 'label': 'Disappointed'},
      {'emoji': '😔', 'label': 'Sad'},
      {'emoji': '😟', 'label': 'Worried'},
      {'emoji': '😢', 'label': 'Crying'},
    ],
  };

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        break;
      case 1:
        // Already on mood tracker
        break;
      case 2:
        Navigator.pushNamed(context, '/articles');
        break;
      case 3:
        Navigator.pushNamed(context, '/meditation');
        break;
      case 4:
        Navigator.pushNamed(context, '/music');
        break;
    }
  }

  void _onMoodSelected(String mood) {
    setState(() {
      _selectedMood = mood;
      _showOkButton = false;
    });
  }

  void _onDetailedMoodSelected(String mood) {
    setState(() {
      _selectedMood = mood;
      _showOkButton = true;
    });
  }

  void _onOkPressed() {
    setState(() {
      _showOkButton = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood "$_selectedMood" confirmed!')),
    );
  }

  String _getCurrentMainCategory() {
    if (_categorizedDetailedMoods.containsKey(_selectedMood)) {
      return _selectedMood;
    }
    for (String category in _categorizedDetailedMoods.keys) {
      if (_categorizedDetailedMoods[category]!
          .any((mood) => mood['label'] == _selectedMood)) {
        return category;
      }
    }
    return 'Happy';
  }

  List<Map<String, String>> _getCurrentDetailedMoods() {
    if (_categorizedDetailedMoods.containsKey(_selectedMood)) {
      return _categorizedDetailedMoods[_selectedMood]!;
    }
    for (String category in _categorizedDetailedMoods.keys) {
      if (_categorizedDetailedMoods[category]!
          .any((mood) => mood['label'] == _selectedMood)) {
        return _categorizedDetailedMoods[category]!;
      }
    }
    return _categorizedDetailedMoods['Happy']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildMoodMenuSection(),
                      const SizedBox(height: 24),
                      _buildTodaysNotesSection(),
                      const SizedBox(height: 24),
                      _buildVoiceSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMoodMenuSection() {
    final currentDetailedMoods = _getCurrentDetailedMoods();
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4a7ab8),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mood Menu – $_selectedMood',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mood logged!')),
                  );
                },
                child: const Text(
                  'Log menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _mainMoods.map((mood) {
              bool isSelected = _getCurrentMainCategory() == mood['label'];
              return GestureDetector(
                onTap: () => _onMoodSelected(mood['label']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4a7ab8) : const Color(0xFF3a5f9a),
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                  ),
                  child: Center(
                    child: Text(
                      mood['emoji'],
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3a5f9a),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: currentDetailedMoods.length,
              itemBuilder: (context, index) {
                final mood = currentDetailedMoods[index];
                bool isSelectedDetailed = mood['label'] == _selectedMood;
                return GestureDetector(
                  onTap: () => _onDetailedMoodSelected(mood['label']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelectedDetailed ? const Color(0xFF4a7ab8).withOpacity(0.3) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelectedDetailed ? Border.all(color: Colors.white, width: 1) : null,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          mood['emoji']!,
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mood['label']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: isSelectedDetailed ? FontWeight.w700 : FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_showOkButton) ...[
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _onOkPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4a7ab8),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTodaysNotesSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFf7d9a6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF4a7ab8), width: 8),
          ),
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 1,
                color: const Color(0xFF4a7ab8).withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              const Text(
                'Add a Note, or start with a prompt.',
                style: TextStyle(
                  color: Color(0xFF7a6f5f),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: const Color(0xFF4a7ab8).withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              ...List.generate(4, (index) => Container(
                width: double.infinity,
                height: 1,
                color: const Color(0xFF4a7ab8).withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 8),
              )),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Starting writing mode...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4a7ab8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Start Writing',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -12,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF4a7ab8),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: const Text(
              "Today's Notes:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4a7ab8),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.mic, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Voice',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Starting voice recording...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3a5f9a),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Start Recording',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF4a7ab8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: 'Mood Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Meditation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
        ],
      ),
    );
  }
}