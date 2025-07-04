import 'package:flutter/material.dart';
import 'models/journalentry.dart';
import 'services/journal_service.dart';
import 'journal_editor.dart';
import 'landing_page.dart';
import 'article_menu.dart';
import 'meditation.dart';
import 'music.dart';
import 'mood_tracker_journal_menu.dart';

class JournalLogPage extends StatefulWidget {
  const JournalLogPage({super.key});

  @override
  State<JournalLogPage> createState() => _JournalLogPageState();
}

class _JournalLogPageState extends State<JournalLogPage> {
  int _selectedIndex = 1; // Set to 1 since this is the journal screen
  List<JournalEntry> journalEntries = [];
  bool _isLoading = true;
  final JournalService _journalService = JournalService();

  @override
  void initState() {
    super.initState();
    _loadJournalHistory();
  }

  Future<void> _loadJournalHistory() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final entries = await _journalService.getJournalHistory();
      
      if (mounted) {
        setState(() {
          journalEntries = entries;
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
            content: Text('Failed to load journal entries: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshJournalHistory() async {
    await _loadJournalHistory();
  }

  void _addJournalEntry(JournalEntry entry) {
    // Refresh the list after adding/editing
    _refreshJournalHistory();
  }

  void _navigateToEditor({JournalEntry? existingEntry}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEditorScreen(
          onSave: _addJournalEntry,
          existingEntry: existingEntry,
        ),
      ),
    );
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24.0, right: 8.0),
        child: FloatingActionButton(
          onPressed: () => _navigateToEditor(),
          backgroundColor: Colors.white,
          elevation: 6,
          child: const Icon(Icons.add, size: 32, color: Color(0xFF2F5497)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                    'Journal Log',
                    style: TextStyle(
                      color: Color(0xFF2F5497),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF2F5497)),
                    onPressed: _refreshJournalHistory,
                  ),
                ],
              ),
            ),

            // Journal Entries
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2F5497),
                      ),
                    )
                  : journalEntries.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No journal entries yet',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start journaling by tapping the + button!',
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
                          onRefresh: _refreshJournalHistory,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: journalEntries.length,
                            itemBuilder: (context, index) {
                              final entry = journalEntries[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () => _navigateToEditor(existingEntry: entry),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              entry.formattedDate,
                                              style: const TextStyle(
                                                color: Color(0xFF2F5497),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  entry.formattedTime,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Icon(
                                                  Icons.edit,
                                                  size: 16,
                                                  color: Colors.grey[400],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          entry.previewText,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (entry.imageUrls != null && entry.imageUrls!.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.image,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${entry.imageUrls!.length} image(s)',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
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