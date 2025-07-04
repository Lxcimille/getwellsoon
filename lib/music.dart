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
        '/journal_tracker': (context) => const MoodTrackerScreen(),
        '/article': (context) => const ArticlesPage(),
        '/meditation': (context) => const MeditationTimerPage(),
        '/music': (context) => const MusicListScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class Music {
  final String id;
  final String title;
  final String artist;
  final String duration;
  final String albumArt;
  final String audioUrl;

  Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.albumArt,
    required this.audioUrl,
  });

  factory Music.fromMap(Map<String, dynamic> map) {
    return Music(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      duration: map['duration'] ?? '',
      albumArt: map['album_art'] ?? '',
      audioUrl: map['audio_url'] ?? '',
    );
  }
}

class MusicListScreen extends StatefulWidget {
  const MusicListScreen({super.key});

  @override
  _MusicListScreenState createState() => _MusicListScreenState();
}

class _MusicListScreenState extends State<MusicListScreen> {
  int _selectedIndex = 4; // Current screen is music (index 4)
  List<Music> _musicList = [];
  bool _isLoading = true;
  bool _isEmpty = false;
  Music? _currentlyPlaying;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadMusicFromSupabase();
  }

  Future<void> _loadMusicFromSupabase() async {
    try {
      setState(() {
        _isLoading = true;
        _isEmpty = false;
      });

      // Simulated Supabase query format
      // In real implementation, you would use:
      // final response = await Supabase.instance.client
      //     .from('music')
      //     .select('id, title, artist, duration, album_art, audio_url');
      
      // For demonstration, simulating empty state and populated state
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      
      // Uncomment the line below to test empty state
      // final List<Map<String, dynamic>> data = [];
      
      // Mock data for demonstration
      final List<Map<String, dynamic>> data = [
        {
          'id': '1',
          'title': 'Rain Sounds During The Night',
          'artist': 'GWS Official',
          'duration': '2:20',
          'album_art': 'https://storage.googleapis.com/a1aa/image/94401e9c-6ac1-40d6-0ec1-a270e13b273f.jpg',
          'audio_url': 'https://example.com/audio1.mp3',
        },
        {
          'id': '2',
          'title': 'Peaceful Forest Sounds',
          'artist': 'Nature Sounds',
          'duration': '3:45',
          'album_art': 'https://storage.googleapis.com/a1aa/image/94401e9c-6ac1-40d6-0ec1-a270e13b273f.jpg',
          'audio_url': 'https://example.com/audio2.mp3',
        },
        // Add more mock data as needed
      ];

      if (data.isEmpty) {
        setState(() {
          _isEmpty = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _musicList = data.map((item) => Music.fromMap(item)).toList();
          _isEmpty = false;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isEmpty = true;
        _isLoading = false;
      });
      print('Error loading music: $error');
    }
  }

  void _onNavItemTapped(int index) {
    if (index == _selectedIndex) return; // Don't navigate if already on current screen

    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page based on the selected index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/landingpage');
        break;
      case 1:
        Navigator.pushNamed(context, '/journal_tracker');
        break;
      case 2:
        Navigator.pushNamed(context, '/article');
        break;
      case 3:
        Navigator.pushNamed(context, '/meditation');
        break;
      case 4:
        // Already on music screen, no navigation needed
        break;
    }
  }

  void _playMusic(Music music) {
    setState(() {
      _currentlyPlaying = music;
      _isPlaying = true;
    });
    
    // Here you would integrate with audio player package like audioplayers
    // AudioPlayer().play(UrlSource(music.audioUrl));
    print('Playing: ${music.title} by ${music.artist}');
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    
    // Here you would pause/resume the audio player
    print(_isPlaying ? 'Resumed' : 'Paused');
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
    bool isSelected = _selectedIndex == index;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isSelected ? Colors.white : Colors.white70,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          assetPath,
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default icons if custom images fail to load
            IconData fallbackIcon;
            switch (index) {
              case 0:
                fallbackIcon = Icons.home;
                break;
              case 1:
                fallbackIcon = Icons.book;
                break;
              case 2:
                fallbackIcon = Icons.article;
                break;
              case 3:
                fallbackIcon = Icons.self_improvement;
                break;
              case 4:
                fallbackIcon = Icons.music_note;
                break;
              default:
                fallbackIcon = Icons.circle;
            }
            return Icon(
              fallbackIcon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 24,
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Music Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your music library is empty.\nAdd some music to get started!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadMusicFromSupabase,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F5496),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Refresh',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2F5496)),
      ),
    );
  }

  Widget _buildMusicPlayer() {
    if (_currentlyPlaying == null) return const SizedBox.shrink();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2F5496),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Album art
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(_currentlyPlaying!.albumArt),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentlyPlaying!.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _currentlyPlaying!.artist,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Play/Pause button
            IconButton(
              onPressed: _togglePlayPause,
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                    
                    // Music list content
                    Expanded(
                      child: _isLoading
                          ? _buildLoadingState()
                          : _isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  itemCount: _musicList.length,
                                  itemBuilder: (context, index) {
                                    final music = _musicList[index];
                                    final isCurrentlyPlaying = _currentlyPlaying?.id == music.id;
                                    
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: isCurrentlyPlaying 
                                            ? const Color(0xFF2F5496).withOpacity(0.8)
                                            : const Color(0xFF2F5496),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(12),
                                          onTap: () => _playMusic(music),
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
                                                    image: DecorationImage(
                                                      image: NetworkImage(music.albumArt),
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
                                                        music.title,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        music.artist,
                                                        style: TextStyle(
                                                          color: Colors.white.withOpacity(0.7),
                                                          fontSize: 10,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                
                                                // Play indicator and duration
                                                Column(
                                                  children: [
                                                    if (isCurrentlyPlaying)
                                                      Icon(
                                                        _isPlaying ? Icons.pause : Icons.play_arrow,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      music.duration,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
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
            ),
          ],
        ),
      ),
      
      // Bottom music player
      bottomSheet: _buildMusicPlayer(),
      
      // Bottom navigation bar
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}