import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Image TryGetImageFile(String directoryPath, String id) {  
  Directory home = Directory(directoryPath);
  try {
    var image = File("${home.path}/$id/image.png");
    if (image.existsSync()) {
      return Image.file(image);
    }
    return Image.asset("images/clos_logo.png");
  } catch (e) {
    return Image.asset("images/clos_logo.png");
  }
}

dynamic TryGetFutureImageFile(BuildContext context, AsyncSnapshot<File> snapshot) {
  try {
    if (File(snapshot.data!.path).existsSync()) {
    return snapshot.data != null ? Image.file(snapshot.data!) : Image.asset("images/clos_logo.png");
    }
  } catch (e) {
    return Image.asset("images/clos_logo.png");
  }
}

Future<bool> checkAndRequestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }
  return status.isGranted;
}

Future<void> requestPermissions() async {
  await Permission.storage.request();
}