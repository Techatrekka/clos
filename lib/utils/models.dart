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