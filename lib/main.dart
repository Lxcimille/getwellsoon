import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'landing_page.dart';
import 'mood_tracker_journal_menu.dart';
import 'journal_editor.dart';
import 'journal_log.dart';
import 'article_menu.dart';
import 'meditation.dart';
import 'music.dart';
import 'models/journalentry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetWellSoon App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (context) => const RegistrationScreen());
          case '/landingpage':
            return MaterialPageRoute(builder: (context) => const LandingPage());
          case '/mood_tracker_journal':
            return MaterialPageRoute(builder: (context) => const MoodTrackerScreen());
          case '/journal_log':
            return MaterialPageRoute(builder: (context) => const JournalLogPage());
          case 'journal_editor':
            return MaterialPageRoute(builder: (context) => const JournalEditorScreen());
          case '/journal_entry':
            // Handle arguments for journal editor
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => JournalEditorScreen(
                onSave: args?['onSave'],
                existingEntry: args?['existingEntry'],
              ),
            );
          case '/article_menu':
            return MaterialPageRoute(builder: (context) => const ArticlesApp());
          case '/meditation':
            return MaterialPageRoute(builder: (context) => const MeditationTimerPage());
          case '/music':
            return MaterialPageRoute(builder: (context) => const MusicListApp());
          default:
            return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
      },
    );
  }
}