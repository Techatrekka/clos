import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:clos/services/io/manifest_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:clos/models/audiobook.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

var networkIP = "192.168.1.5:8080";
var networkURl = "http://$networkIP";

Future<List<AudioBook>> fetchAudioBookList(String section) async {
  //var response = await http.get(Uri.parse('$networkURl/catalog/$section'));
  const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZncnFxd3FubmhsYmtucmp6YXZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTgzMTUyMTMsImV4cCI6MjAzMzg5MTIxM30.VaRrp6pztt63KIe5sqoGfw-byLPm4TMxyeoBrqY76Gc';
  var response = await http.get(Uri.parse('https://vgrqqwqnnhlbknrjzavn.supabase.co/functions/v1/dynamic-service'),
   headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization' : 'Bearer $token'});
  print(response.body);
  print(response.statusCode);
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    List<dynamic> result = jsonMap['data'];
    print(result.first);
    var c = result.map((json) => AudioBook.fromJson(json)).toList();
    print(c.length);
    return c;
  } else {
    throw Exception('Failed to load album');
  }
}

Future<AudioBook> fetchAudioBook(String id) async {
  var response = await http.get(Uri.parse('$networkURl/audio/$id'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> result = jsonDecode(response.body);
    return AudioBook.fromJson(result['data']);
  } else {
    throw Exception('Failed to load album');
  }
}

void downloadAudioFiles(AudioBook book) async {
  String Id = book.tapeId;
  var currentList = await readBookManifest();
  currentList.add(book);
  await writeToManifest(currentList);
  Directory directory = await getApplicationDocumentsDirectory();
  Directory newdirectory = Directory("${directory.path}/$Id");
  await newdirectory.create();
  final taskId = await FlutterDownloader.enqueue(
    url: "$networkURl/download/$Id",
    fileName: "archive-$Id.zip", // optional: header send with url (auth token etc)
    savedDir: directory.path,
    saveInPublicStorage: false,
    showNotification: false, // show download progress in status bar (for Android)
    openFileFromNotification: false, // click on notification to open downloaded file (for Android)
  );
  await Future.delayed(const Duration(seconds: 10));
  await extractFileToDisk("${directory.path}/archive-$Id.zip",newdirectory.path);
  await Future.delayed(const Duration(seconds: 3));
  File file = File("${directory.path}/archive-$Id.zip");
  file.deleteSync();
}
