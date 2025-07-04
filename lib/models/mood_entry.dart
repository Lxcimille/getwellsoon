class MoodEntry {
  final String id;
  final String userId;
  final String mood;
  final String? detailedMood;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  MoodEntry({
    required this.id,
    required this.userId,
    required this.mood,
    this.detailedMood,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'mood': mood,
      'detailed_mood': detailedMood,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON (from database)
  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mood: json['mood'] as String,
      detailedMood: json['detailed_mood'] as String?,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Create for insert (without id, created_at, updated_at)
  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'mood': mood,
      'detailed_mood': detailedMood,
      'note': note,
    };
  }

  // Helper method to get formatted date string
  String get formattedDate {
    final weekdays = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${weekdays[createdAt.weekday % 7]}, ${createdAt.day} ${months[createdAt.month - 1]} ${createdAt.year}';
  }

  // Helper method to get time string
  String get formattedTime {
    return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  // Copy with method for updates
  MoodEntry copyWith({
    String? id,
    String? userId,
    String? mood,
    String? detailedMood,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      detailedMood: detailedMood ?? this.detailedMood,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'MoodEntry(id: $id, mood: $mood, detailedMood: $detailedMood, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoodEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 