import 'package:flutter/material.dart';
import 'mood_tracker_journal_menu.dart';
import 'article_menu.dart';
import 'meditation.dart';
import 'music.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Mood',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/landingpage',
      routes: {
        '/landingpage': (context) => const LandingPage(),
        '/mood_tracker_journal': (context) => const MoodTrackerScreen(),
        '/article_menu': (context) => const ArticlesApp(),
        '/meditation': (context) => const MeditationTimerPage(),
        '/music': (context) => const MusicListApp(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              _buildWelcomeText(),
              const SizedBox(height: 12),
              _buildMoodCard(),
              const SizedBox(height: 24),
              _buildNoteCard(context),
              const SizedBox(height: 24),
              _buildRecommendationsHeader(),
              const SizedBox(height: 8),
              _buildRecommendationList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF2E549A)),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.mood),
            title: const Text('Mood Tracker'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 1;
                _selectedIndex = 1;
              });
              Navigator.pushNamed(context, '/mood_tracker_journal');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Journal Log'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 1;
                _selectedIndex = 1;
              });
              Navigator.pushNamed(context, '/mood_tracker_journal');
            },
          ),
          ListTile(
            leading: const Icon(Icons.self_improvement),
            title: const Text('Meditation'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 3;
                _selectedIndex = 3;
              });
              Navigator.pushNamed(context, '/meditation');
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Music'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 4;
                _selectedIndex = 4;
              });
              Navigator.pushNamed(context, '/music');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 24, height: 2, color: Colors.black),
              const SizedBox(height: 4),
              Container(width: 16, height: 2, color: Colors.black),
              const SizedBox(height: 4),
              Container(width: 24, height: 2, color: Colors.black),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _currentIndex = 2;
              _selectedIndex = 2;
            });
            Navigator.pushNamed(context, '/article_menu');
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://storage.googleapis.com/a1aa/image/ab12d2e6-7d19-4fff-b75b-4325bedf099a.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 40,
                height: 40,
                color: Colors.grey,
                child: const Icon(Icons.person),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return const Center(
      child: Text(
        'Selamat datang, User!',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildMoodCard() {
    // Get current date and time
    final now = DateTime.now();
    final dayNames = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final monthNames = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
                       'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    final currentDateTime = '${dayNames[now.weekday % 7]}, ${now.day} ${monthNames[now.month - 1]} ${now.year} · ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4F7ABF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currentDateTime,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                      _selectedIndex = 1;
                    });
                    Navigator.pushNamed(context, '/mood_tracker_journal');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E549A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Update Mood',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://storage.googleapis.com/a1aa/image/53d8b836-0ea9-43de-f271-27a8975bed42.jpg',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 48,
                height: 48,
                color: Colors.grey[300],
                child: const Icon(Icons.emoji_emotions),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9E6B7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2E549A), width: 4),
          ),
          child: Column(
            children: List.generate(
              6,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xFF6B7280),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -10,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFF2E549A),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: const Text(
              'Catatan Hari Ini:',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _currentIndex = 1;
                _selectedIndex = 1;
              });
              Navigator.pushNamed(context, '/journal_log');
            },
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsHeader() {
    return const Text(
      'Recommended:',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buildRecommendationList() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildRecommendationCard(
            imageUrl: 'https://storage.googleapis.com/a1aa/image/71288186-dc42-419e-53fd-01a38c59154f.jpg',
            title: 'Apa Itu Depresi? Ketahui Gejalanya!',
          ),
          const SizedBox(width: 12),
          _buildRecommendationCard(
            imageUrl: 'https://storage.googleapis.com/a1aa/image/27ea1813-2789-4033-68cf-bf0d0d8c8d68.jpg',
            title: 'Tips Untuk Menjaga Kesehatan Mental',
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard({required String imageUrl, required String title}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = 2;
          _selectedIndex = 2;
        });
        Navigator.pushNamed(context, '/article_menu');
      },
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2E549A), width: 4),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: const Color(0xFF2E549A),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
        errorBuilder: (context, error, stackTrace) => Icon(
          _getIconForIndex(index),
          color: _selectedIndex == index ? Colors.white : Colors.white70,
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.edit;
      case 2:
        return Icons.bookmark;
      case 3:
        return Icons.self_improvement;
      case 4:
        return Icons.music_note;
      default:
        return Icons.home;
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentIndex = index;
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
          MaterialPageRoute(builder: (context) => const MeditationTimerPage()),
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
}