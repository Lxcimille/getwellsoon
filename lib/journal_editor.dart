import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'landing_page.dart';
import 'mood_tracker_journal_menu.dart';
import 'article_menu.dart';
import 'meditation.dart';
import 'music.dart';
import 'models/journalentry.dart';
import 'services/journal_service.dart';

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
  final ImagePicker _picker = ImagePicker();
  int _selectedIndex = 1; // Set to 1 since this is the journal screen
  bool _isLoading = false;
  List<XFile> _selectedImages = [];
  final JournalService _journalService = JournalService();

  @override
  void initState() {
    super.initState();
    // If editing existing entry, populate the text field
    if (widget.existingEntry != null) {
      _textController.text = widget.existingEntry!.content;
    }
  }

  Future<void> _saveContent() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something before saving')),
      );
      return;
    }

    if (_isLoading) return; // Prevent multiple saves

    setState(() {
      _isLoading = true;
    });

    try {
      List<String> imageUrls = [];
      
      // Upload images if any
      if (_selectedImages.isNotEmpty) {
        imageUrls = await _journalService.uploadMultipleImages(_selectedImages);
      }

      JournalEntry savedEntry;
      
      if (widget.existingEntry != null) {
        // Update existing entry
        savedEntry = await _journalService.updateJournal(
          id: widget.existingEntry!.id,
          content: _textController.text,
          imageUrls: imageUrls.isNotEmpty ? imageUrls : null,
        );
      } else {
        // Create new entry
        savedEntry = await _journalService.saveJournal(
          content: _textController.text,
          imageUrls: imageUrls.isNotEmpty ? imageUrls : null,
        );
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Call the callback function if provided
        if (widget.onSave != null) {
          widget.onSave!(savedEntry);
        }

        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingEntry != null 
              ? 'Journal entry updated successfully!' 
              : 'Journal entry saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save journal entry: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick images: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to take photo: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Pick Multiple Images'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMultipleImages();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ArticlesApp()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MeditationApp()),
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
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF2F5497)),
                  onPressed: () => Navigator.pop(context),
                ),
                // Title
                Text(
                  widget.existingEntry != null ? 'Edit Journal' : 'New Journal',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F5497),
                  ),
                ),
                // Save button
                TextButton(
                  onPressed: _isLoading ? null : _saveContent,
                  child: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF2F5497),
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F5497),
                        ),
                      ),
                ),
              ],
            ),
          ),

          // Formatting toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                // Bold button
                IconButton(
                  icon: Icon(
                    Icons.format_bold,
                    color: _isBold ? const Color(0xFF2F5497) : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isBold = !_isBold;
                    });
                  },
                ),
                // Italic button
                IconButton(
                  icon: Icon(
                    Icons.format_italic,
                    color: _isItalic ? const Color(0xFF2F5497) : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isItalic = !_isItalic;
                    });
                  },
                ),
                // Underline button
                IconButton(
                  icon: Icon(
                    Icons.format_underlined,
                    color: _isUnderline ? const Color(0xFF2F5497) : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isUnderline = !_isUnderline;
                    });
                  },
                ),
                const SizedBox(width: 16),
                // Image button
                IconButton(
                  icon: const Icon(Icons.image, color: Color(0xFF2F5497)),
                  onPressed: _showImageOptions,
                ),
                const Spacer(),
                // Font size slider
                Row(
                  children: [
                    const Icon(Icons.format_size, color: Colors.grey),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 100,
                      child: Slider(
                        value: _fontSize,
                        min: 12,
                        max: 24,
                        divisions: 12,
                        onChanged: (value) {
                          setState(() {
                            _fontSize = value;
                          });
                        },
                        activeColor: const Color(0xFF2F5497),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Selected images display
          if (_selectedImages.isNotEmpty) ...[
            Container(
              height: 100,
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedImages[index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],

          // Text editor
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: _isUnderline ? TextDecoration.underline : TextDecoration.none,
                  color: _textColor,
                ),
                decoration: const InputDecoration(
                  hintText: 'Start writing your journal entry...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}