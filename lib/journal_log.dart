import 'package:flutter/material.dart';
import 'models/journalentry.dart';

class JournalLogPage extends StatefulWidget {
  const JournalLogPage({super.key});

  @override
  State<JournalLogPage> createState() => _JournalLogPageState();
}

class _JournalLogPageState extends State<JournalLogPage> {
  List<JournalEntry> journalEntries = [];

  void _addJournalEntry(JournalEntry entry) {
    setState(() {
      // Check if we're updating an existing entry
      int existingIndex = journalEntries.indexWhere((e) => e.id == entry.id);
      if (existingIndex != -1) {
        journalEntries[existingIndex] = entry;
      } else {
        journalEntries.add(entry);
      }
    });
  }

  void _navigateToEditor() async {
    await Navigator.pushNamed(
      context,
      '/journal_editor',
      arguments: {
        'onSave': _addJournalEntry,
      },
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

      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2F5497),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/landingpage',
                  (route) => false,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: _navigateToEditor,
              ),
              IconButton(
                icon: const Icon(Icons.menu_book, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.local_cafe, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.power_settings_new, color: Colors.white),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                ),
              ),
            ],
          ),
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
                    'Journal Log',
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

            // Journal Entries or Empty Message
            Expanded(
              child: journalEntries.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Record your journal by pressing the '' button!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: journalEntries.length,
                      itemBuilder: (context, index) {
                        final entry = journalEntries[index];
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
                                  'onSave': _addJournalEntry,
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
