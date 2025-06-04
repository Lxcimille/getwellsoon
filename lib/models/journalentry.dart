class JournalEntry {
  final String id;
  final String content;
  final DateTime date;
  final String formattedDate;

  JournalEntry({
    required this.id,
    required this.content,
    required this.date,
    required this.formattedDate,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
      'formattedDate': formattedDate,
    };
  }

  // Create from JSON
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      formattedDate: json['formattedDate'],
    );
  }
}