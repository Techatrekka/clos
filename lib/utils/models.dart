class AudioBook {
  final String tapeId;
  final String title;
  final String author;
  final String synopsis;
  final String isAudiobook;
  final String tags;
  
  const AudioBook( {
    required this.tapeId, 
    required this.title,
    required this.author, 
    required this.synopsis, 
    required this.isAudiobook, 
    required this.tags});

  factory AudioBook.fromPosition(tapeId, title, author, synopsis, isAudiobook, tags) {
    return AudioBook(
      tapeId: tapeId,
      title: title,
      author: author,
      synopsis: synopsis,
      isAudiobook: isAudiobook,
      tags: tags);
  }

  factory AudioBook.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'tape_id': String tapeId,
        'title': String title,
        'author': String author,
        'synopsis': String synopsis,
        'is_audiobook': String isAudiobook,
        'tags': String tags,
      } =>
        AudioBook(
          tapeId: tapeId,
          title: title,
          author: author,
          synopsis: synopsis,
          isAudiobook: isAudiobook,
          tags: tags,
        ),
      _ => throw const FormatException('Failed to load audiobook.'),
    };
  }
}

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

class TionscadalEolais {
  String teideal;
  String fogra;
  DateTime am;

  TionscadalEolais(this.teideal, this.fogra, this.am);

  factory TionscadalEolais.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String teideal,
        'notice': String fogra,
        'time': DateTime am,
      } =>
        TionscadalEolais(teideal, fogra, am),
      _ => throw const FormatException('Failed to parse Updates.'),
    };
  }
}