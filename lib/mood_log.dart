import 'package:flutter/material.dart';
import 'models/mood_entry.dart';
import 'services/mood_service.dart';
import 'landing_page.dart';
import 'mood_tracker_journal_menu.dart';
import 'article_menu.dart';
import 'meditation.dart';
import 'music.dart';

class MoodLogPage extends StatefulWidget {
  const MoodLogPage({super.key});

  @override
  State<MoodLogPage> createState() => _MoodLogPageState();
}

class _MoodLogPageState extends State<MoodLogPage> {
  List<MoodEntry> moodEntries = [];
  bool _isLoading = true;
  final MoodService _moodService = MoodService();
  int _selectedIndex = 1; // Set to 1 since this is related to journal tracker

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  Future<void> _loadMoodHistory() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final entries = await _moodService.getMoodHistory();
      
      if (mounted) {
        setState(() {
          moodEntries = entries;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load mood history: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshMoodHistory() async {
    await _loadMoodHistory();
  }

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
        );
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

  Widget _buildMoodIcon(String mood, String? detailedMood) {
    String iconPath;
    Color iconColor;

    switch (mood.toLowerCase()) {
      case 'happy':
        iconPath = 'assets/icons/main/happy.png';
        iconColor = const Color(0xFF4CAF50);
        break;
      case 'sad':
        iconPath = 'assets/icons/main/sad.png';
        iconColor = const Color(0xFF2196F3);
        break;
      case 'angry':
        iconPath = 'assets/icons/main/angry.png';
        iconColor = const Color(0xFFF44336);
        break;
      case 'neutral':
        iconPath = 'assets/icons/main/neutral.png';
        iconColor = const Color(0xFF9E9E9E);
        break;
      default:
        iconPath = 'assets/icons/main/neutral.png';
        iconColor = const Color(0xFF9E9E9E);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.3)),
      ),
      child: Image.asset(
        iconPath,
        width: 32,
        height: 32,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.mood,
            color: iconColor,
            size: 24,
          );
        },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(width: 24, height: 2, color: const Color(0xFF3B2F3B)),
                      const SizedBox(height: 4),
                      Container(width: 16, height: 2, color: const Color(0xFF3B2F3B)),
                      const SizedBox(height: 4),
                      Container(width: 24, height: 2, color: const Color(0xFF3B2F3B)),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://storage.googleapis.com/a1aa/image/ee92acf3-e911-4d37-c6d2-e5b1aeae2bbf.jpg',
                    ),
                  ),
                ],
              ),
            ),

            // Back Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Color(0xFF2F5497), size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Title with refresh button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF2F5497),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mood Log',
                    style: TextStyle(
                      color: Color(0xFF2F5497),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF2F5497)),
                    onPressed: _refreshMoodHistory,
                  ),
                ],
              ),
            ),

            // Mood Entries
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2F5497),
                      ),
                    )
                  : moodEntries.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.mood_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No mood entries yet',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start tracking your mood to see your history here!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _refreshMoodHistory,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: moodEntries.length,
                            itemBuilder: (context, index) {
                              final entry = moodEntries[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      // Mood icon
                                      _buildMoodIcon(entry.mood, entry.detailedMood),
                                      const SizedBox(width: 16),
                                      
                                      // Mood details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  entry.detailedMood ?? entry.mood,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF2F5497),
                                                  ),
                                                ),
                                                Text(
                                                  entry.formattedTime,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              entry.formattedDate,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            if (entry.note != null && entry.note!.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  entry.note!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
