import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'mood_tracker_journal_menu.dart';
import 'article_menu.dart';
import 'music.dart';
import 'dart:async';

void main() {
  runApp(MeditationApp());
}

class MeditationApp extends StatelessWidget {
  const MeditationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation Timer',
      theme: ThemeData(
        fontFamily: 'Open Sans',
        primaryColor: const Color(0xFF2D5D9F),
      ),
      initialRoute: '/meditation',
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

class MeditationTimerPage extends StatefulWidget {
  const MeditationTimerPage({super.key});

  @override
  State<MeditationTimerPage> createState() => _MeditationTimerPageState();
}

class _MeditationTimerPageState extends State<MeditationTimerPage> {
  int _totalSeconds = 30 * 60; // 30 minutes in seconds
  bool _isRunning = false;
  late Timer _timer;
  bool _showSettings = false;
  int _selectedIndex = 3; // Set to 3 since this is the meditation screen

  @override
  void dispose() {
    if (_isRunning) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) {
      _timer.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_totalSeconds > 0) {
            _totalSeconds--;
          } else {
            _timer.cancel();
            _isRunning = false;
          }
        });
      });
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _toggleSettings() {
    setState(() {
      _showSettings = !_showSettings;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildCustomIcon(String assetPath, int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _selectedIndex == index ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        assetPath,
        width: 24,
        height: 24,
        color: _selectedIndex == index ? Colors.white : Colors.white70,
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
        // Already on meditation screen, no navigation needed
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MusicListApp()),
        );
        break;
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 4),
              Container(
                width: 16,
                height: 2,
                color: Colors.black,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://storage.googleapis.com/a1aa/image/73a0fba1-4b40-42f0-9834-f6592e3a8942.jpg',
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 30),
                      color: const Color(0xFF2D5D9F),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Column(
                      children: [
                        Text(
                          'Meditation',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF2D5D9F),
                          ),
                        ),
                        Text(
                          'Meditate to calm down',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2D5D9F),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, size: 24),
                      color: const Color(0xFF2D5D9F),
                      onPressed: _toggleSettings,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://storage.googleapis.com/a1aa/image/b817b732-c4d6-4b5f-a78e-766626922979.jpg',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _formatTime(_totalSeconds),
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Color(0xFF2D5D9F),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5D9F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 12),
                ),
                child: Text(
                  _isRunning ? 'PAUSE' : 'START',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 2.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // Settings Sidebar
          if (_showSettings)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color(0xFF2D5D9F),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: _toggleSettings,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                        leading: Icon(Icons.music_note, color: Color(0xFF2D5D9F)),
                        title: Text(
                          'Add music',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            color: Color(0xFF2D5D9F),
                          ),
                        ),
                        onTap: () {
                          // Implement music selection
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.timer, color: Color(0xFF2D5D9F)),
                        title: Text(
                          'Set timer',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            color: Color(0xFF2D5D9F),
                          ),
                        ),
                        onTap: () {
                          // Implement timer setting
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Overlay to close settings when tapping outside
          if (_showSettings)
            GestureDetector(
              onTap: _toggleSettings,
              child: Container(
                color: Colors.transparent,
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}