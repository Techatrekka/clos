import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:clos/utils/common_functions.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:clos/utils/models.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

var networkURl = "http://192.168.236.89:8080/";

void fetchStrings() async {
  var response = await http.get(Uri.parse('http://192.168.42.192:8080/strings'));
  print(response.body.toString());
}


Future<List<AudioBook>> fetchAudioBookList() async {
  var response = await http.get(Uri.parse('${networkURl}catalog/title'));
  print(response.body);
  if (response.statusCode == 200) {
    List<dynamic> result = jsonDecode(response.body);
    print(result.length);
    return result.map((json) => AudioBook.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}

Future<AudioBook> fetchAudioBook(String id) async {
  var response = await http.get(Uri.parse('${networkURl}audio/$id'));
  print(response.body);
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    return AudioBook.fromJson(result);
  } else {
    throw Exception('Failed to load album');
  }
}

void fetchAudioFile() async {
  var directory = await getApplicationDocumentsDirectory();
  var filePath = directory.path;
  final taskId = await FlutterDownloader.enqueue(
    url: 'http://192.168.42.192:8080/audio.mp3',
    fileName: "audio.mp3", // optional: header send with url (auth token etc)
    savedDir: filePath,
    saveInPublicStorage: true,
    showNotification: true, // show download progress in status bar (for Android)
    openFileFromNotification: true, // click on notification to open downloaded file (for Android)
  );
}

Future<void> attemptSaveFile(String filename, List<int> bytes) async {
  bool hasPermission = await checkAndRequestStoragePermission();
  if (hasPermission) {
    try {
      await saveFileLocally(filename, bytes);
      print("File download and save completed.");
    } catch (e) {
      print("An error occurred while saving the file: $e");
    }
  } else {
    print("Storage permission not granted. Cannot save the file.");
  }
}


Future<void> saveFileLocally(String filename, List<int> bytes) async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path + filename;
  File file = File(path);
  await file.writeAsBytes(bytes);
  print("File saved at $path");
}


Future<void> downloadAudioFiles(String Id) async {
  Directory directory = await getApplicationDocumentsDirectory();
  Directory newdirectory = Directory("${directory.path}/$Id");
  await newdirectory.create();
  print("directory contents");
  print(directory.listSync());
  print("directory contents");
  print(newdirectory.listSync());
  final taskId = await FlutterDownloader.enqueue(
    url: "http://192.168.42.192:8080/download/$Id",
    fileName: "archive.zip", // optional: header send with url (auth token etc)
    savedDir: directory.path,
    saveInPublicStorage: false,
    showNotification: true, // show download progress in status bar (for Android)
    openFileFromNotification: true, // click on notification to open downloaded file (for Android)
  );
  await extractFileToDisk("${directory.path}/archive.zip",newdirectory.path);
  print(directory.listSync());
  print(newdirectory.listSync());
}