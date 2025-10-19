class Section {
  String title;
  String iconLocation;

  Section(
    this.title,
    this.iconLocation);
}

class ListeningHistory {
  int user_id;
  int tape_id;
  int current_chapter;
  int chapter_progress;

  ListeningHistory(this.tape_id, this.user_id, this.current_chapter, this.chapter_progress);

  factory ListeningHistory.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'tape_id': int tape_id,
        'user_id': int user_id,
        'current_chapter': int current_chapter,
        'chapter_progress': int chapter_progress,
      } =>
        ListeningHistory(tape_id, user_id, current_chapter, chapter_progress),
      _ => throw const FormatException('Failed to parse Listening history.'),
    };
  }
}