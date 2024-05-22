import 'package:clos/custom_app_bar.dart';
import 'package:clos/models.dart';
import 'package:flutter/material.dart';

class AudioBookDownloadScreen extends StatefulWidget {
  const AudioBookDownloadScreen({super.key, required this.audioBook});

  final AudioBook audioBook;

  @override
  State<AudioBookDownloadScreen> createState() => _AudioBookDownloadScreenState();
}

class _AudioBookDownloadScreenState extends State<AudioBookDownloadScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Explore"),
      body: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.867),
        width: 500,
        height: 1000,
       // child: ,
      )
    );
  }
}