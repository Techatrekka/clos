class AudioBook {
  final String audioFile;
  final String title;
  final String author;
  final String synopsis;
  final String id;
  final String iconLocation;
  
  const AudioBook( {
    required this.audioFile, 
    required this.title,
    required this.author, 
    required this.synopsis, 
    required this.id, 
    required this.iconLocation});

  factory AudioBook.fromPosition(audioFile, title, author, synopsis, id, iconLocation) {
    return AudioBook(
      audioFile: audioFile,
      title: title,
      author: author,
      synopsis: synopsis,
      id: id,
      iconLocation: iconLocation);
  }

  factory AudioBook.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'audioFile': String audioFile,
        'title': String title,
        'author': String author,
        'synopsis': String synopsis,
        'id': String id,
        'iconLocation': String iconLocation,
      } =>
        AudioBook(
          audioFile: audioFile,
          title: title,
          author: author,
          synopsis: synopsis,
          id: id,
          iconLocation: iconLocation,
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