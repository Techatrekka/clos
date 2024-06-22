import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:clos/utils/models.dart';
import 'package:clos/utils/network.dart';
import 'package:clos/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class ItemHolder {
  ItemHolder({this.name, this.task});

  final String? name;
  final TaskInfo? task;
}

class TaskInfo {
  TaskInfo({this.name, this.link});

  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}

class AudioBookDownloadScreen extends StatefulWidget {
  const AudioBookDownloadScreen({super.key, });
  // required this.sectionTitle,
  // required this.tapeId});

  // final String sectionTitle;
  // final String tapeId;

  @override
  State<AudioBookDownloadScreen> createState() => _AudioBookDownloadScreenState();
}

class _AudioBookDownloadScreenState extends State<AudioBookDownloadScreen> {
  final ReceivePort _port = ReceivePort();
  late String _localPath;

  @override
  void initState() {
    super.initState();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    // _showContent = false;
    // _permissionReady = false;
    // _saveInPublicStorage = false;

    _prepare();
  }
  Future<void> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    if (tasks == null) {
      print('No tasks were retrieved from the database.');
      return;
    }

    // _permissionReady = await _checkPermission();
    // if (_permissionReady) {
    await _prepareSaveDir();
    // }

    setState(() {
      // _showContent = true;
    });
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _getSavedDir())!;
    final savedDir = Directory(_localPath);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
  }

  Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;
    externalStorageDirPath =
        (await getDownloadsDirectory())!.absolute.path;

    return externalStorageDirPath;
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;

      print(
        'Callback on UI isolate: '
        'task ($taskId) is in status ($status) and process ($progress)',
      );

      // if (_tasks != null && _tasks!.isNotEmpty) {
      //   final task = _tasks!.firstWhere((task) => task.taskId == taskId);
      //   setState(() {
      //     task
      //       ..status = status
      //       ..progress = progress;
      //   });
      // }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    final AudioBook book = ModalRoute.of(context)!.settings.arguments as AudioBook;

    return Scaffold(
      appBar: const CustomAppBar(title: "sectionTitle"),
      body: Container(
        color: Colors.black87,
        height: 1000,
        width: 500,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row (
              children: [
                Image.asset(
                "images/clos_logo.png",
                height: 200,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Text(
                        "title",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      Text(
                        "author",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                )
              ]
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20),
              child: OutlinedButton(
                onPressed: () => DownloadAudioFiles(book.tapeId),
                child: const Text("Download"),
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20),
              child: const Text(
                "Synopsis",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20),
              color: Colors.black,
              child: const Text(
                "Synopsis",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}