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
        '/articles': (context) => const ArticlesPage(),
        '/home': (context) => const LandingPage(),
        '/journal': (context) => const MoodTrackerScreen(),
        '/meditation': (context) => const MeditationTimerPage(),
        '/music': (context) => const MusicListApp(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Article model to hold article data
class Article {
  final String id;
  final String title;
  final String author;
  final DateTime datePublished;
  final String imageUrl;
  final String content;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.datePublished,
    required this.imageUrl,
    required this.content,
  });
}

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  int _selectedIndex = 2; // Set to 2 since this is the articles screen

  // Sample articles data - shortened content
  final List<Article> articles = [
    Article(
      id: '1',
      title: 'Apa itu Depresi? Ketahui Gejalanya!',
      author: 'Dr. Sarah Wijaya',
      datePublished: DateTime(2024, 12, 15),
      imageUrl: 'https://storage.googleapis.com/a1aa/image/f9cbd776-fd31-42aa-2239-803f1ec8488e.jpg',
      content: '''Depresi adalah gangguan mood yang serius yang mempengaruhi cara seseorang merasa, berpikir, dan menangani aktivitas sehari-hari. Gejala utama depresi meliputi perasaan sedih yang berlangsung terus-menerus, kehilangan minat dalam aktivitas yang biasanya dinikmati, perubahan nafsu makan, dan gangguan tidur.

Depresi dapat disebabkan oleh kombinasi faktor biologis, psikologis, dan lingkungan. Kondisi ini dapat diobati melalui terapi psikologis, obat-obatan antidepresan jika diperlukan, dan perubahan gaya hidup sehat. Jika Anda mengalami gejala-gejala ini selama lebih dari dua minggu, sangat penting untuk mencari bantuan profesional.''',
    ),
    Article(
      id: '2',
      title: 'Tips Untuk Menenangkan Diri',
      author: 'Prof. Ahmad Rizki',
      datePublished: DateTime(2024, 12, 10),
      imageUrl: 'https://storage.googleapis.com/a1aa/image/9390b3be-4732-40ef-ce92-f9026e4db302.jpg',
      content: '''Dalam kehidupan yang penuh tekanan ini, kemampuan untuk menenangkan diri menjadi keterampilan yang sangat berharga. Beberapa teknik efektif meliputi pernapasan 4-7-8, teknik grounding 5-4-3-2-1, dan meditasi mindfulness.

Aktivitas fisik ringan seperti jalan kaki atau yoga juga membantu. Menciptakan lingkungan yang tenang dengan pencahayaan lembut dan aromaterapi dapat memberikan ketenangan. Ingatlah bahwa menenangkan diri adalah keterampilan yang perlu dipraktikkan secara konsisten.''',
    ),
    Article(
      id: '3',
      title: 'Memahami Kecemasan dan Cara Mengatasinya',
      author: 'Dr. Maya Sari',
      datePublished: DateTime(2024, 12, 8),
      imageUrl: 'https://storage.googleapis.com/a1aa/image/f9cbd776-fd31-42aa-2239-803f1ec8488e.jpg',
      content: '''Kecemasan adalah respons alami tubuh terhadap stres, tetapi ketika menjadi berlebihan dapat mengganggu kehidupan sehari-hari. Gejala meliputi jantung berdebar, berkeringat berlebihan, dan sesak napas.

Strategi mengatasi kecemasan termasuk teknik relaksasi, cognitive behavioral techniques, dan perubahan gaya hidup seperti olahraga teratur. Jika kecemasan mengganggu aktivitas harian, sangat penting untuk mencari bantuan profesional karena kecemasan adalah kondisi yang dapat diobati.''',
    ),
    Article(
      id: '4',
      title: 'Pentingnya Self-Care dalam Kesehatan Mental',
      author: 'Dr. Rina Pratiwi',
      datePublished: DateTime(2024, 12, 5),
      imageUrl: 'https://storage.googleapis.com/a1aa/image/9390b3be-4732-40ef-ce92-f9026e4db302.jpg',
      content: '''Self-care adalah praktik sadar untuk menjaga kesehatan fisik, mental, dan emosional kita. Ini bukan kemewahan, tetapi kebutuhan mendasar untuk kesejahteraan hidup.

Self-care mencakup physical care (tidur cukup, olahraga), emotional care (journaling, gratitude), dan social care (menjaga hubungan sehat). Praktik harian bisa berupa morning stretching, deep breathing, atau aktivitas mingguan seperti digital detox. Ingatlah bahwa self-care adalah investasi terbaik untuk kesehatan diri.''',
    ),
  ];

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
        // Already on articles screen, no navigation needed
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

  String _formatDate(DateTime date) {
    List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu button - Made clickable
                  GestureDetector(
                    onTap: () {
                      // Add menu functionality here
                      print("Menu tapped");
                    },
                    child: Column(
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
                          width: 20,
                          height: 1,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B2F3B),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Profile picture - Made clickable
                  GestureDetector(
                    onTap: () {
                      // Add profile functionality here
                      print("Profile tapped");
                    },
                    child: Container(
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
                            onPressed: () {
                              // Add sort functionality here
                              print("Sort button tapped");
                            },
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
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ArticleCard(
                              article: articles[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArticleDetailPage(article: articles[index]),
                                  ),
                                );
                              },
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
      
      // Bottom navigation bar - Updated with new design
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  
  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                article.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF2F5497),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'By ${article.author}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(article.datePublished),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Article Detail Page
class ArticleDetailPage extends StatefulWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  String _formatDate(DateTime date) {
    List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F5497).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF2F5497),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Article Detail',
                      style: TextStyle(
                        color: Color(0xFF2F5497),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Article content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Article image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.article.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Article title
                    Text(
                      widget.article.title,
                      style: const TextStyle(
                        color: Color(0xFF2F5497),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Author and date
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F5497).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.article.author,
                            style: const TextStyle(
                              color: Color(0xFF2F5497),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatDate(widget.article.datePublished),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Article content
                    Text(
                      widget.article.content,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        height: 1.6,
                        letterSpacing: 0.3,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}