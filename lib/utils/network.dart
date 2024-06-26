import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:clos/utils/common_functions.dart';
import 'package:clos/utils/manifest_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:clos/utils/models.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

var networkURl = "http://192.168.1.2:8080";

//test function
void fetchStrings() async {
  var response = await http.get(Uri.parse('http://192.168.42.192:8080/strings'));
  print(response.body.toString());
}


Future<List<AudioBook>> fetchAudioBookList() async {
  var response = await http.get(Uri.parse('$networkURl/catalog/title'));
  if (response.statusCode == 200) {
    List<dynamic> result = jsonDecode(response.body);
    var c = result.map((json) => AudioBook.fromJson(json)).toList();
    return c;
  } else {
    throw Exception('Failed to load album');
  }
}

Future<AudioBook> fetchAudioBook(String id) async {
  var response = await http.get(Uri.parse('${networkURl}/audio/$id'));
  print(response.body);
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    return AudioBook.fromJson(result);
  } else {
    throw Exception('Failed to load album');
  }
}

//out of use
void fetchAudioFile() async {
  var directory = await getApplicationDocumentsDirectory();
  var filePath = directory.path;
  final taskId = await FlutterDownloader.enqueue(
    url: '$networkURl/audio.mp3',
    fileName: "audio.mp3", // optional: header send with url (auth token etc)
    savedDir: filePath,
    saveInPublicStorage: true,
    showNotification: true, // show download progress in status bar (for Android)
    openFileFromNotification: true, // click on notification to open downloaded file (for Android)
  );
}

// test function
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

// test function
Future<void> saveFileLocally(String filename, List<int> bytes) async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path + filename;
  File file = File(path);
  await file.writeAsBytes(bytes);
  print("File saved at $path");
}


void DownloadAudioFiles(AudioBook book) async {
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
  await Future.delayed(Duration(seconds: 10));
  await extractFileToDisk("${directory.path}/archive-$Id.zip",newdirectory.path);
  await Future.delayed(Duration(seconds: 3));
  File file = File("${directory.path}/archive-$Id.zip");
  file.deleteSync();
}

// test function
Future<void> _requestDownload() async {
  // create prepare folder for download
  final task = await FlutterDownloader.enqueue(
    url: "http://192.168.236.5:8080/downloadAudio/audio.mp3",
    headers: {'auth': 'test_for_sql_encoding'},
    savedDir: "_localPath",
    saveInPublicStorage: false,
  );
}