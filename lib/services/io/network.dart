import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:background_downloader/background_downloader.dart' as bd;
import 'package:clos/services/io/manifest_handler.dart';
import 'package:clos/models/audiobook.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// var networkIP = "192.168.1.5:8080";
// var networkURl = "http://$networkIP";

Future<List<AudioBook>> fetchAudioBookList(String section) async {
  //var response = await http.get(Uri.parse('$networkURl/catalog/$section'));
  const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZncnFxd3FubmhsYmtucmp6YXZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTgzMTUyMTMsImV4cCI6MjAzMzg5MTIxM30.VaRrp6pztt63KIe5sqoGfw-byLPm4TMxyeoBrqY76Gc';
  var response = await http.get(Uri.parse('https://vgrqqwqnnhlbknrjzavn.supabase.co/functions/v1/dynamic-service?is_audiobook=$section'),
   headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization' : 'Bearer $token'});
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = jsonDecode(response.body);
    List<dynamic> result = jsonMap['data'];
    var c = result.map((json) => AudioBook.fromJson(json)).toList();
    return c;
  } else {
    throw Exception('Failed to load album');
  }
}

// void downloadAudioFiles(AudioBook book) async {
//   String Id = book.tapeId;
//   var currentList = await readBookManifest();
//   currentList.add(book);
//   await writeToManifest(currentList);
//   Directory directory = await getApplicationDocumentsDirectory();
//   Directory newdirectory = Directory("${directory.path}/$Id");
//   await newdirectory.create();
//   final taskId = await FlutterDownloader.enqueue(
//     url: "$networkURl/download/$Id",
//     fileName: "archive-$Id.zip", // optional: header send with url (auth token etc)
//     savedDir: directory.path,
//     saveInPublicStorage: false,
//     showNotification: true, // show download progress in status bar (for Android)
//     openFileFromNotification: false, // click on notification to open downloaded file (for Android)
//   );
//   await Future.delayed(const Duration(seconds: 10));
//   await extractFileToDisk("${directory.path}/archive-$Id.zip",newdirectory.path);
//   await Future.delayed(const Duration(seconds: 3));
//   File file = File("${directory.path}/archive-$Id.zip");
//   file.deleteSync();
// }

void downloadAudioFilesv3(AudioBook book) async {
  // Use .download to start a download and wait for it to complete
  String Id = book.tapeId;
  var currentList = await readBookManifest();
  currentList.add(book);
  await writeToManifest(currentList);
  Directory directory = await getApplicationDocumentsDirectory();
  Directory newdirectory = Directory("${directory.path}/$Id");
  await newdirectory.create();
  final task = bd.DownloadTask(
    url: 'https://duchastech-clois-audio.s3.eu-west-1.amazonaws.com/$Id/archive.zip',
    filename: 'archive.zip',
    directory: '',
    updates: bd.Updates.statusAndProgress, // request status and progress updates
    requiresWiFi: true,
    retries: 5,
    allowPause: true,);

  // Start download, and wait for result. Show progress and status changes
  // while downloading
  final result = await bd.FileDownloader().download(task,
      onProgress: (progress) => print('Progress: ${progress * 100}%'),
      onStatus: (status) => print('Status: $status')
  );

  // Act on the result
  switch (result.status) {
    case bd.TaskStatus.complete:
      print('Success!');
      File file = File("${directory.path}/archive.zip");
      Future.delayed(const Duration(seconds: 3));
      if (file.existsSync()) {
        await extractFileToDisk("${directory.path}/archive.zip",newdirectory.path, asyncWrite: true);
        await Future.delayed(const Duration(seconds: 3));
        file.deleteSync();
      }

    case bd.TaskStatus.canceled:
      print('Download was canceled');

    case bd.TaskStatus.paused:
      print('Download was paused');

    default:
      print('Download not successful');
  }
}