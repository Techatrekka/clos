import 'dart:io';

import 'package:clos/ui/screens/download_screen/audiobook_download_screen.dart';
import 'package:clos/services/service_locator.dart';
import 'package:clos/ui/screens/home_screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';


Future<void> main() async {
  await setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(
    debug: true, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const LoadingScreen(title: 'Loading'),
      routes: {
        // '/': (context) => HomePage(),
        '/downloadpage': (context) => const AudioBookDownloadScreen(),
        // '/playerpage': (context) => PlayerScreen(),
      },
    );
  }
}
