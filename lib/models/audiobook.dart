import 'dart:convert';

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
    // return switch (json) {
    //   {
    //     'tape_id': dynamic tape_id,
    //     'title': String title,
    //     'author': String author,
    //     'synopsis': String synopsis,
    //     'is_audiobook': dynamic isAudiobook,
    //     'tags': dynamic tags,
    //   } =>
    //     AudioBook(
    //       tapeId: '$tape_id',
    //       title: title.toString() ?? "",
    //       author: author.toString() ?? "",
    //       synopsis: synopsis.toString() ?? "",
    //       tags: String.fromCharCodes(tags) ?? "",
    //       isAudiobook: isAudiobook.toString() ?? "",
    //     ),
    //   _ => throw const FormatException('Failed to load audiobook.'),
    // };
    return AudioBook(tapeId: json['tape_id'].toString(), title: json['title'].toString(), 
      author: json['author'].toString() ?? "", synopsis: json['synopsis'].toString() ?? "",
      isAudiobook: json['isAudiobook'].toString(), tags: json['tags'].toString() ?? "");
  }
}