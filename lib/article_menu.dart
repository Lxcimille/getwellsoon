import 'package:flutter/material.dart';
import 'mood_tracker_journal_menu.dart';
import 'landing_page.dart';
import 'meditation.dart';
import 'music.dart';


void main() {
  runApp(const ArticlesApp());
}

class ArticlesApp extends StatelessWidget {
  const ArticlesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Articles',
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: const Color(0xFF2F5497),
      ),
      initialRoute: '/articles',
      routes: {
        '/home': (context) => const LandingPage(),
        '/journal': (context) => const MoodTrackerApp(),
        '/meditation': (context) => const MeditationTimerPage(),
        '/music': (context) => const MusicListApp(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}





class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 1,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2F3B),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 16,
                        height: 1,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2F3B),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 20,
                        height: 1,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2F3B),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                  // Profile picture
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://storage.googleapis.com/a1aa/image/6d1f4efb-9955-44b6-8385-ffc44ad4f15b.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Title and sort button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Articles',
                            style: TextStyle(
                              color: Color(0xFF2F5497),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Sort by',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Articles list
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 80),
                        children: const [
                          ArticleCard(
                            imageUrl: 'https://storage.googleapis.com/a1aa/image/f9cbd776-fd31-42aa-2239-803f1ec8488e.jpg',
                            title: 'Apa itu Depresi? Ketahui Gejalanya!',
                          ),
                          SizedBox(height: 20),
                          ArticleCard(
                            imageUrl: 'https://storage.googleapis.com/a1aa/image/f9cbd776-fd31-42aa-2239-803f1ec8488e.jpg',
                            title: 'Apa itu Depresi? Ketahui Gejalanya!',
                          ),
                          SizedBox(height: 20),
                          ArticleCard(
                            imageUrl: 'https://storage.googleapis.com/a1aa/image/9390b3be-4732-40ef-ce92-f9026e4db302.jpg',
                            title: 'Tips Untuk Menenangkan Diri',
                          ),
                          SizedBox(height: 20),
                          ArticleCard(
                            imageUrl: 'https://storage.googleapis.com/a1aa/image/9390b3be-4732-40ef-ce92-f9026e4db302.jpg',
                            title: 'Tips Untuk Menenangkan Diri',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom navigation bar
      bottomNavigationBar: Container(
        color: const Color(0xFF2F5497),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home button
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
              icon: const Icon(Icons.home, color: Colors.white70, size: 24),
            ),
            
            // Journal button
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/journal'),
              icon: const Icon(Icons.edit, color: Colors.white70, size: 24),
            ),
            
            // Articles button (active)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark, color: Colors.white, size: 24),
                ),
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.white,
                ),
              ],
            ),
            
            // Music button
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/music'),
              icon: const Icon(Icons.music_note, color: Colors.white70, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  
  const ArticleCard({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF2F5497),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}