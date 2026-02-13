class Poem {
  final int id;
  final String title;
  final String content;
  final String? author;
  final String? theme;
  final String? rhymeScheme;
  final String? senderId;
  final String? targetUserId;
  final bool isPublic;
  final DateTime? createdAt;
  final DateTime? unlockedAt;

  const Poem({
    required this.id,
    required this.title,
    required this.content,
    this.author,
    this.theme,
    this.rhymeScheme,
    this.senderId,
    this.targetUserId,
    this.isPublic = true,
    this.createdAt,
    this.unlockedAt,
  });

  factory Poem.fromJson(Map<String, dynamic> json) {
    // Handle the <br> tags from the JSON source
    String rawContent = json['text'] ?? json['content'] ?? '';
    String cleanContent = rawContent.replaceAll('<br>', '\n');

    return Poem(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? 'Untitled',
      content: cleanContent,
      author: json['author'],
      theme: json['theme'],
      rhymeScheme: json['rhyme_scheme'],
      senderId: json['sender_id'],
      targetUserId: json['target_user_id'],
      isPublic: json['is_public'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.tryParse(json['unlocked_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'theme': theme,
      'rhyme_scheme': rhymeScheme,
      'sender_id': senderId,
      'target_user_id': targetUserId,
      'is_public': isPublic,
      'created_at': createdAt?.toIso8601String(),
      'unlocked_at': unlockedAt?.toIso8601String(),
    };
  }

  Poem copyWith({
    int? id,
    String? title,
    String? content,
    String? author,
    String? theme,
    String? rhymeScheme,
    String? senderId,
    String? targetUserId,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? unlockedAt,
  }) {
    return Poem(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      theme: theme ?? this.theme,
      rhymeScheme: rhymeScheme ?? this.rhymeScheme,
      senderId: senderId ?? this.senderId,
      targetUserId: targetUserId ?? this.targetUserId,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  String toString() => 'Poem(id: $id, title: $title)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Poem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
