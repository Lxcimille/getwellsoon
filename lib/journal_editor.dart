import 'package:flutter/material.dart';
import 'models/journalentry.dart';

class JournalEditorScreen extends StatefulWidget {
  final Function(JournalEntry)? onSave;
  final JournalEntry? existingEntry;

  const JournalEditorScreen({
    super.key,
    this.onSave,
    this.existingEntry,
  });

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  Color _textColor = Colors.black;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    // If editing existing entry, populate the text field
    if (widget.existingEntry != null) {
      _textController.text = widget.existingEntry!.content;
    }
  }

  void _saveContent() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something before saving')),
      );
      return;
    }

    final entry = JournalEntry(
      id: widget.existingEntry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      content: _textController.text,
      date: DateTime.now(),
      formattedDate: _formatDate(DateTime.now()),
    );

    // Call the callback function if provided
    if (widget.onSave != null) {
      widget.onSave!(entry);
    }

    // Show success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Journal entry saved successfully!')),
    );
    
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${days[date.weekday - 1]} - ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  color: const Color(0xFF3B2B3B),
                ),
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      'https://storage.googleapis.com/a1aa/image/6fbb0013-9efa-4ff3-36bd-71cabbec48ff.jpg'),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Container(
              color: const Color(0xFFFFE5B4),
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF2B5D9F)),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Text(
                              _formatDate(DateTime.now()),
                              style: const TextStyle(
                                color: Color(0xFF2B5D9F),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _saveContent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'SAVE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Start writing...',
                          ),
                          style: TextStyle(
                            fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                            fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                            decoration: _isUnderline
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            color: _textColor,
                            fontSize: _fontSize,
                          ),
                          maxLines: null,
                          expands: true,
                        ),
                      ),
                    ],
                  ),
                  // Formatting toolbar
                  Positioned(
                    right: 16,
                    top: MediaQuery.of(context).size.height * 0.25,
                    child: Container(
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.format_bold,
                              color: _isBold ? const Color(0xFF2B5D9F) : Colors.grey[600],
                            ),
                            onPressed: () => setState(() => _isBold = !_isBold),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.format_italic,
                              color: _isItalic ? const Color(0xFF2B5D9F) : Colors.grey[600],
                            ),
                            onPressed: () => setState(() => _isItalic = !_isItalic),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.format_underline,
                              color: _isUnderline ? const Color(0xFF2B5D9F) : Colors.grey[600],
                            ),
                            onPressed: () => setState(() => _isUnderline = !_isUnderline),
                          ),
                          IconButton(
                            icon: const Icon(Icons.color_lens, color: Color(0xFF2B5D9F)),
                            onPressed: () {
                              setState(() {
                                _textColor = _textColor == Colors.black ? Colors.red : Colors.black;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.text_fields, color: Color(0xFF2B5D9F)),
                            onPressed: () {
                              setState(() {
                                _fontSize = _fontSize == 16.0 ? 20.0 : 16.0;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.image, color: Color(0xFF2B5D9F)),
                            onPressed: () {
                              // Implement image insertion functionality
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom navigation
          Container(
            color: const Color(0xFF2B5D9F),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/landingpage',
                    (route) => false,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 28),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.white, size: 28),
                  onPressed: _saveContent,
                ),
                IconButton(
                  icon: const Icon(Icons.coffee, color: Colors.white, size: 28),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.power_settings_new, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}