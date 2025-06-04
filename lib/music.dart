import 'package:flutter/material.dart';
import 'article_menu.dart';
import 'landing_page.dart';
import 'mood_tracker_journal_menu.dart';
import 'meditation.dart';

void main() {
  runApp(const MusicListApp());
}

class MusicListApp extends StatelessWidget {
  const MusicListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music List',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF2F5496),
      ),
      initialRoute: '/music',
      routes: {
        '/landingpage': (context) => const LandingPage(),
        '/journal': (context) => const MoodTrackerApp(),
        '/articles': (context) => const ArticlesPage(),
        '/meditation': (context) => const MeditationTimerPage(),
        '/music': (context) => const MusicListScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}



class MusicListScreen extends StatelessWidget {
  const MusicListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu button
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2E4F),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 24,
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2E4F),
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
                          'https://storage.googleapis.com/a1aa/image/2813bed9-e413-4c90-e988-eeb80a6e5ddb.jpg'),
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Music List',
                      style: TextStyle(
                        color: const Color(0xFF2F5496),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Music list
                    Expanded(
                      child: ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2F5496),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  // Album art
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: const DecorationImage(
                                        image: NetworkImage(
                                          'https://storage.googleapis.com/a1aa/image/94401e9c-6ac1-40d6-0ec1-a270e13b273f.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  
                                  // Song info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rain Sounds During The Night',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'GWS Official',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontSize: 10,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Duration
                                  Text(
                                    '2:20',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
        color: const Color(0xFF2F5496),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home button
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                  icon: const Icon(Icons.home, color: Colors.white70, size: 30),
                ),
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.transparent,
                ),
              ],
            ),
            
            // Journal button
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/journal'),
                  icon: const Icon(Icons.edit, color: Colors.white70, size: 30),
                ),
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.transparent,
                ),
              ],
            ),
            
            // Articles button
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/articles'),
                  icon: const Icon(Icons.bookmark, color: Colors.white70, size: 30),
                ),
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.transparent,
                ),
              ],
            ),
            
            // Meditation button
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/meditation'),
                  icon: const Icon(Icons.local_cafe, color: Colors.white70, size: 30),
                ),
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.transparent,
                ),
              ],
            ),
            
            // Music button (active)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.music_note, color: Colors.white, size: 30),
                ),
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}