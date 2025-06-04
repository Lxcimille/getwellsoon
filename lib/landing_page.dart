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
      initialRoute: '/home',
      routes: {
        '/home': (context) => const LandingPage(),
        '/mood_tracker': (context) => const MoodTrackerApp(),
        '/article': (context) => const ArticlesApp(),
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
      bottomNavigationBar: _buildBottomNavBar(),
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
              Navigator.pushNamed(context, '/mood_tracker');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Journal Log'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/mood_tracker');
            },
          ),
          ListTile(
            leading: const Icon(Icons.self_improvement),
            title: const Text('Meditation'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/meditation');
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Music'),
            onTap: () {
              Navigator.pop(context);
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
            Navigator.pushNamed(context, '/article');
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4F7ABF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/mood_tracker');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Selasa, 11 Maret 2025 · 18:40',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E549A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Mood saat ini: Senang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
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
              Navigator.pushNamed(context, '/mood_tracker');
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
        Navigator.pushNamed(context, '/article');
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

  Widget _buildBottomNavBar() {
    return Container(
      height: 60,
      color: const Color(0xFF2E549A),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0 ? Colors.white : Colors.white70,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/home', 
                    (route) => false,
                  );
                },
              ),
              if (_currentIndex == 0)
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.white,
                ),
            ],
          ),
          
          // Journal button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: _currentIndex == 1 ? Colors.white : Colors.white70,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                  Navigator.pushNamed(
                    context,
                    '/mood_tracker',
                  );
                },
              ),
              if (_currentIndex == 1)
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.white,
                ),
            ],
          ),
          
          // Articles button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: _currentIndex == 2 ? Colors.white : Colors.white70,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                  Navigator.pushNamed(
                    context,
                    '/article',
                  );
                },
              ),
              if (_currentIndex == 2)
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.white,
                ),
            ],
          ),
          
          // Meditation button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.self_improvement,
                  color: _currentIndex == 3 ? Colors.white : Colors.white70,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                  Navigator.pushNamed(
                    context,
                    '/meditation',
                  );
                },
              ),
              if (_currentIndex == 3)
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.white,
                ),
            ],
          ),
          
          // Music button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.music_note,
                  color: _currentIndex == 4 ? Colors.white : Colors.white70,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 4;
                  });
                  Navigator.pushNamed(
                    context,
                    '/music',
                  );
                },
              ),
              if (_currentIndex == 4)
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.white,
                ),
            ],
          ),
        ],
      ),
    );
  }
}