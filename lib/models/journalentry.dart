class JournalEntry {
  final String id;
  final String? userId;
  final String content;
  final DateTime date;
  final String formattedDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? imageUrls;

  JournalEntry({
    required this.id,
    this.userId,
    required this.content,
    required this.date,
    required this.formattedDate,
    this.createdAt,
    this.updatedAt,
    this.imageUrls,
  });

  // Backward compatible constructor for existing code
  factory JournalEntry.legacy({
    required String id,
    required String content,
    required DateTime date,
    required String formattedDate,
  }) {
    return JournalEntry(
      id: id,
      content: content,
      date: date,
      formattedDate: formattedDate,
    );
  }

  // Constructor for database operations
  factory JournalEntry.database({
    required String id,
    required String userId,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    List<String>? imageUrls,
  }) {
    final weekdays = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    final formattedDate = '${weekdays[createdAt.weekday % 7]} - ${createdAt.day} ${months[createdAt.month - 1]} ${createdAt.year}';
    
    return JournalEntry(
      id: id,
      userId: userId,
      content: content,
      date: createdAt,
      formattedDate: formattedDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      imageUrls: imageUrls,
    );
  }

  // Convert to JSON for storage (backward compatible)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'formattedDate': formattedDate,
    };
  }

  // Convert to JSON for database operations
  Map<String, dynamic> toDatabaseJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'created_at': (createdAt ?? date).toIso8601String(),
      'updated_at': (updatedAt ?? date).toIso8601String(),
      'image_urls': imageUrls,
    };
  }

  // Create insert JSON (without id, created_at, updated_at)
  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'content': content,
      'image_urls': imageUrls,
    };
  }

  // Create from JSON (backward compatible)
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      formattedDate: json['formattedDate'],
    );
  }

  // Create from database JSON
  factory JournalEntry.fromDatabaseJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['created_at'] as String);
    final updatedAt = DateTime.parse(json['updated_at'] as String);
    
    List<String>? imageUrls;
    if (json['image_urls'] != null) {
      imageUrls = List<String>.from(json['image_urls'] as List);
    }

    return JournalEntry.database(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      createdAt: createdAt,
      updatedAt: updatedAt,
      imageUrls: imageUrls,
    );
  }

  // Helper method to get formatted time
  String get formattedTime {
    final dateToUse = createdAt ?? date;
    return '${dateToUse.hour.toString().padLeft(2, '0')}:${dateToUse.minute.toString().padLeft(2, '0')}';
  }

  // Helper method to get preview text
  String get previewText {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  // Copy with method for updates
  JournalEntry copyWith({
    String? id,
    String? userId,
    String? content,
    DateTime? date,
    String? formattedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imageUrls,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      date: date ?? this.date,
      formattedDate: formattedDate ?? this.formattedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  @override
  String toString() {
    return 'JournalEntry(id: $id, content: ${content.substring(0, content.length > 50 ? 50 : content.length)}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JournalEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}