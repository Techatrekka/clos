import 'dart:convert';
import 'dart:io';
import 'package:clos/services/common_functions.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:clos/models/models.dart';
import 'package:clos/models/project_notice.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

var networkIP = "192.168.1.5:8080";
var networkURl = "http://$networkIP";

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

//phased out
void uploadListeningHistory(int tapeId, int chapterId, Duration chapterProgress) async {
	 Map<String,String> headers = {
      'Content-type' : 'application/json', 
      'Accept': 'application/json',
    };
	var response = await http.post(Uri.http(networkIP, '/uploadListeningHistory/'), 
    headers: headers,
		body: json.encode(
      {	
        'tape_id': tapeId,
				'user_id': 1,
				'current_chapter': chapterId,
				'chapter_progress': chapterProgress.inSeconds
      }
    )
  );
}

//phased out
Future<ListeningHistory> getListeningHistory(String userId, String tapeId) async {
  var response = await http.get(Uri.parse('$networkURl/getListeningHistory/?&user_id=$userId&tape_id=$tapeId'));
  if (response.statusCode == 200) {
    List<dynamic> result = jsonDecode(response.body);
    return ListeningHistory.fromJson(result.first);
  } else {
    throw Exception('Failed to load album');
  }
}

//phased out
Future<List<ProjectNotice>> getApplicationUpdates() async {
  var response = await http.get(Uri.parse('$networkURl/getApplicationUpdates/'));
  if (response.statusCode == 200) {
    List<dynamic> result = jsonDecode(response.body);
    return result.map((json) => ProjectNotice.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load album');
  }
}