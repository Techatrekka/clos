import 'dart:io';

void deleteFiles(int tapeId, Directory homeDirectory) {
  File folder = File("${homeDirectory.path}/$tapeId");
  folder.deleteSync();
}