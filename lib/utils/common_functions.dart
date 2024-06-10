import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Image TryGetImageFile(String file) {
  try {
    var image = File(file);
    if (image.existsSync()) {
      return Image.file(image);
    }
    return Image.asset("images/clos_logo.png");
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