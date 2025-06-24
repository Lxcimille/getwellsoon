import 'package:flutter/material.dart';
import 'models/journalentry.dart';

class MoodLogPage extends StatefulWidget {
  const MoodLogPage({super.key});

  @override
  State<MoodLogPage> createState() => _MoodLogPageState();
}

class _MoodLogPageState extends State<MoodLogPage> {
  List<JournalEntry> moodEntries = [];

  void _addMoodEntry(JournalEntry entry) {
    setState(() {
      // Check if we're updating an existing entry
      int existingIndex = moodEntries.indexWhere((e) => e.id == entry.id);
      if (existingIndex != -1) {
        moodEntries[existingIndex] = entry;
      } else {
        moodEntries.add(entry);
      }
    });
  }

  void _navigateToEditor() async {
    await Navigator.pushNamed(
      context,
      '/journal_editor',
      arguments: {
        'onSave': _addMoodEntry,
      },
    );
  }

  Widget _buildCustomIcon(String assetPath, int index) {
    bool isSelected = index == 2; // Set index 2 (Save/Journal) as selected for this page
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
      ),
      child: Image.asset(
        assetPath,
        color: Colors.white,
        errorBuilder: (context, error, stackTrace) {
          // Fallback icons if assets don't load
          IconData fallbackIcon;
          switch (index) {
            case 0:
              fallbackIcon = Icons.home;
              break;
            case 1:
              fallbackIcon = Icons.edit;
              break;
            case 2:
              fallbackIcon = Icons.save;
              break;
            case 3:
              fallbackIcon = Icons.local_cafe;
              break;
            case 4:
              fallbackIcon = Icons.music_note;
              break;
            default:
              fallbackIcon = Icons.circle;
          }
          return Icon(fallbackIcon, color: Colors.white, size: 24);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24.0, right: 8.0),
        child: FloatingActionButton(
          onPressed: _navigateToEditor,
          backgroundColor: Colors.white,
          elevation: 6,
          child: const Icon(Icons.add, size: 32, color: Color(0xFF2F5497)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: Container(
  decoration: const BoxDecoration(
    color: Color(0xFF4a7ab8), // Match the mood tracker color
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(24),
      topRight: Radius.circular(24),
    ),
  ),
  child: BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.transparent,
    elevation: 0,
    currentIndex: 0, // You can set this based on which page is active
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
        label: 'Edit',
      ),
      BottomNavigationBarItem(
        icon: _buildCustomIcon('assets/icons/navbar/article.png', 2),
        label: 'Save',
      ),
      BottomNavigationBarItem(
        icon: _buildCustomIcon('assets/icons/navbar/meditation.png', 3),
        label: 'Break',
      ),
      BottomNavigationBarItem(
        icon: _buildCustomIcon('assets/icons/navbar/music.png', 4),
        label: 'Music',
      ),
    ],
    onTap: (index) {
      switch (index) {
        case 0:
          Navigator.pushNamed(
            context,
            '/landingpage',
          );
          break;
        case 1:
          Navigator.pushNamed(
            context,
            '/mood_tracker_journal'
          );
          break;
        case 2:
          Navigator.pushNamed(
            context,
            '/article_menu'
          );
          break;
        case 3:
          Navigator.pushNamed(
            context,
            '/meditation'
          );
          break;
        case 4:
          Navigator.pushNamed(
            context,
            '/music',
          );
          break;
      }
    },
  ),
),

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

            // Title and Dropdown with underline
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
                  DropdownButton<String>(
                    value: 'Tue - 11 March 2025',
                    iconEnabledColor: Colors.purple,
                    style: const TextStyle(color: Color(0xFF2F5497), fontSize: 14),
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Tue - 11 March 2025',
                        child: Text('Tue - 11 March 2025'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),

            // Mood Entries or Empty Message
            Expanded(
              child: moodEntries.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Record your mood by pressing the '' button!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: moodEntries.length,
                      itemBuilder: (context, index) {
                        final entry = moodEntries[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              // Navigate to editor with existing entry for editing
                              Navigator.pushNamed(
                                context,
                                '/journal_editor',
                                arguments: {
                                  'onSave': _addMoodEntry,
                                  'existingEntry': entry,
                                },
                              );
                            },
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
                                      Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.grey[400],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    entry.content.length > 100
                                        ? '${entry.content.substring(0, 100)}...'
                                        : entry.content,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
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
