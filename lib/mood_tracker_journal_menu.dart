import 'package:flutter/material.dart';
import 'article_menu.dart';
import 'landing_page.dart';
import 'meditation.dart';
import 'music.dart';
import 'journal_log.dart';
import 'mood_log.dart';
import 'services/mood_service.dart';
import 'models/mood_entry.dart';

void main() {
  runApp(const MoodTrackerScreen());
}

class MoodTrackerScreen extends StatelessWidget {
  const MoodTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Menu',
      theme: ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.blue,
      ),
      home: const MoodMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MoodMenuScreen extends StatefulWidget {
  const MoodMenuScreen({super.key});

  @override
  State<MoodMenuScreen> createState() => _MoodMenuScreenState();
}

class _MoodMenuScreenState extends State<MoodMenuScreen> {
  int _selectedIndex = 1; // Set to 1 since this is the journal tracker screen
  String _selectedMood = 'Happy';
  bool _showOkButton = false;
  bool _isLoading = false; // Add loading state
  final MoodService _moodService = MoodService(); // Add mood service

  final List<Map<String, dynamic>> _mainMoods = [
    {'emoji': 'assets/icons/main/happy.png', 'color': Color(0xFF4a7ab8), 'label': 'Happy'},
    {'emoji': 'assets/icons/main/neutral.png', 'color': Color(0xFF3a5f9a), 'label': 'Neutral'},
    {'emoji': 'assets/icons/main/angry.png', 'color': Color(0xFF3a5f9a), 'label': 'Angry'},
    {'emoji': 'assets/icons/main/sad.png', 'color': Color(0xFF3a5f9a), 'label': 'Sad'},
  ];

  // Organized detailed moods by category
  final Map<String, List<Map<String, String>>> _categorizedDetailedMoods = {
    'Happy': [
      {'emoji': 'assets/icons/happy/joyful.png', 'label': 'Joyful'},
      {'emoji': 'assets/icons/happy/excited.png', 'label': 'Excited'},
      {'emoji': 'assets/icons/happy/grateful.png', 'label': 'Grateful'},
      {'emoji': 'assets/icons/happy/silly.png', 'label': 'Silly'},
      {'emoji': 'assets/icons/happy/funny.png', 'label': 'Funny'},
      {'emoji': 'assets/icons/happy/lovely.png', 'label': 'Lovely'},
      {'emoji': 'assets/icons/happy/ambitious.png', 'label': 'Ambitious'},
      {'emoji': 'assets/icons/happy/cool.png', 'label': 'Cool'},
      {'emoji': 'assets/icons/happy/mischievous.png', 'label': 'Mischievous'},
      {'emoji': 'assets/icons/happy/happy.png', 'label': 'happy'},
    ],
    'Neutral': [
      {'emoji': 'assets/icons/neutral/calm.png', 'label': 'Calm'},
      {'emoji': 'assets/icons/neutral/dizzy.png', 'label': 'Dizzy'},
      {'emoji': 'assets/icons/neutral/embarrassed.png', 'label': 'Embarrassed'},
      {'emoji': 'assets/icons/neutral/nervous.png', 'label': 'Nervous'},
      {'emoji': 'assets/icons/neutral/neutral.png', 'label': 'Neutral'},
      {'emoji': 'assets/icons/neutral/relieved.png', 'label': 'Relieved'},
      {'emoji': 'assets/icons/neutral/shocked.png', 'label': 'Shocked'},
      {'emoji': 'assets/icons/neutral/shy.png', 'label': 'Shy'},
      {'emoji': 'assets/icons/neutral/sleepy.png', 'label': 'Sleepy'},
      {'emoji': 'assets/icons/neutral/thinking.png', 'label': 'Thinking'},
    ],
    'Angry': [
      {'emoji': 'assets/icons/angry/angry.png', 'label': 'angry'},
      {'emoji': 'assets/icons/angry/rage.png', 'label': 'rage'},
      {'emoji': 'assets/icons/angry/annoyed.png', 'label': 'Annoyed'},
      {'emoji': 'assets/icons/angry/irritated.png', 'label': 'Irritated'},
      {'emoji': 'assets/icons/angry/mad.png', 'label': 'Mad'}
    ],
    'Sad': [
      {'emoji': 'assets/icons/sad/disappointed.png', 'label': 'Disappointed'},
      {'emoji': 'assets/icons/sad/sad.png', 'label': 'Sad'},
      {'emoji': 'assets/icons/sad/sobbing.png', 'label': 'Sobbing'},
      {'emoji': 'assets/icons/sad/terrible.png', 'label': 'Terrible'},
      {'emoji': 'assets/icons/sad/worried.png', 'label': 'Worried'}
    ],
  };

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different screens based on index
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
        break;
      case 1:
        // Already on journal tracker screen, no navigation needed
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ArticlesApp()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MeditationApp()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MusicListApp()),
        );
        break;
    }
  }

  void _onMoodSelected(String mood) {
    setState(() {
      _selectedMood = mood;
      _showOkButton = false; // Don't show OK for main mood categories
    });
  }

  void _onDetailedMoodSelected(String mood) {
    setState(() {
      _selectedMood = mood;
      _showOkButton = true; // Show OK only for detailed moods
    });
  }

  Future<void> _onOkPressed() async {
    if (_isLoading) return; // Prevent multiple taps
    
    setState(() {
      _isLoading = true;
    });

    try {
      final mainCategory = _getCurrentMainCategory();
      final detailedMood = _selectedMood != mainCategory ? _selectedMood : null;
      
      await _moodService.saveMood(
        mood: mainCategory,
        detailedMood: detailedMood,
      );

      if (mounted) {
        setState(() {
          _showOkButton = false;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mood "$_selectedMood" saved successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save mood: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _getCurrentMainCategory() {
    // If selected mood is a main category, return it
    if (_categorizedDetailedMoods.containsKey(_selectedMood)) {
      return _selectedMood;
    }
    
    // If it's a detailed mood, find which category it belongs to
    for (String category in _categorizedDetailedMoods.keys) {
      final detailedMoods = _categorizedDetailedMoods[category]!;
      if (detailedMoods.any((mood) => mood['label'] == _selectedMood)) {
        return category;
      }
    }
    
    // Default to Happy
    return 'Happy';
  }

  List<Map<String, String>> _getCurrentDetailedMoods() {
    // Check if the selected mood is a main category
    if (_categorizedDetailedMoods.containsKey(_selectedMood)) {
      return _categorizedDetailedMoods[_selectedMood]!;
    }
    
    // If it's a detailed mood, find which category it belongs to
    for (String category in _categorizedDetailedMoods.keys) {
      final detailedMoods = _categorizedDetailedMoods[category]!;
      if (detailedMoods.any((mood) => mood['label'] == _selectedMood)) {
        return detailedMoods;
      }
    }
    
    // Default to Happy if nothing matches
    return _categorizedDetailedMoods['Happy']!;
  }

  Widget _buildEmojiImage(String path, double size) {
    return Image.asset(
      path,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(size / 4),
          ),
          child: Icon(
            Icons.mood,
            size: size * 0.6,
            color: Colors.grey[600],
          ),
        );
      },
    );
  }

  Widget _buildCustomIcon(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        assetPath,
        width: 24,
        height: 24,
        color: isSelected ? Colors.white : Colors.white70,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            _getDefaultIcon(index),
            color: isSelected ? Colors.white : Colors.white70,
            size: 24,
          );
        },
      ),
    );
  }

  IconData _getDefaultIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.book;
      case 2:
        return Icons.article;
      case 3:
        return Icons.self_improvement;
      case 4:
        return Icons.music_note;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMoodMenuSection() {
    // Get the detailed moods for current category
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoodLogPage()),
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
          // Main mood selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _mainMoods.map((mood) {
              bool isSelected = _getCurrentMainCategory() == mood['label'];
              return GestureDetector(
                onTap: () => _onMoodSelected(mood['label']),
                child: AnimatedScale(
                  scale: isSelected ? 1.0 : 0.95,
                  duration: const Duration(milliseconds: 150),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF4a7ab8) : const Color(0xFF3a5f9a),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ] : null,
                    ),
                    child: Center(
                      child: _buildEmojiImage(mood['emoji'], 48),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Detailed mood grid - now shows category-specific moods
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
                crossAxisCount: 5,
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
                  child: AnimatedScale(
                    scale: isSelectedDetailed ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 150),
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
                          _buildEmojiImage(mood['emoji']!, 32),
                          const SizedBox(height: 4),
                          Text(
                            mood['label']!,
                            style: TextStyle(
                              color: isSelectedDetailed ? Colors.white : Colors.white,
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
                  ),
                );
              },
            ),
          ),
          // OK Button - appears when mood is selected
          if (_showOkButton) ...[
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onOkPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4a7ab8),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 3,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4a7ab8)),
                        ),
                      )
                    : const Text(
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF7a6f5f), width: 1),
                  ),
                ),
                child: const Text(
                  'Add a Note, or start with a prompt.',
                  style: TextStyle(
                    color: Color(0xFF7a6f5f),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push( 
                      context,
                        MaterialPageRoute(builder: (context) => const JournalLogPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4a7ab8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Start Writing',
                    style: TextStyle(
                      fontSize: 14,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFF4a7ab8),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              "Today's Notes:",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
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
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(
            Icons.mic,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle recording action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Starting voice recording...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3a5f9a),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Recording',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
        items: [
          BottomNavigationBarItem(
            icon: _buildCustomIcon('assets/icons/navbar/home.png', 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildCustomIcon('assets/icons/navbar/journal_tracker.png', 1),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: _buildCustomIcon('assets/icons/navbar/article.png', 2),
            label: 'Article',
          ),
          BottomNavigationBarItem(
            icon: _buildCustomIcon('assets/icons/navbar/meditation.png', 3),
            label: 'Meditation',
          ),
          BottomNavigationBarItem(
            icon: _buildCustomIcon('assets/icons/navbar/music.png', 4),
            label: 'Music',
          ),
        ],
      ),
    );
  }
}