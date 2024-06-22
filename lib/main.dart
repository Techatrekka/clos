import 'dart:io';

import 'package:clos/screens/audiobook_download_screen.dart';
import 'package:clos/screens/audioplayer_screen.dart';
import 'package:clos/utils/manifest_handler.dart';
import 'package:clos/widgets/custom_app_bar.dart';
import 'package:clos/widgets/custom_navigation.dart';
import 'package:clos/widgets/library_list_tile.dart';
import 'package:clos/screens/explore_screen.dart';
import 'package:clos/utils/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(
    debug: true, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );
  late List<AudioBook> books = [(AudioBook.fromPosition("1", "Is Gearr", "Marian Keyes", "synopsis", "true", "/data/user/0/com.example.clos/app_flutter/1/image.png")),
    (AudioBook.fromPosition("2", "title", "author", "synopsis", "true", "/data/user/0/com.example.clos/app_flutter/1/age.png")),
    (AudioBook.fromPosition("3", "title", "author", "synopsis", "false", "/data/user/0/com.example.clos/app_flutter/1/image.png"))];
  await writeToManifest(books);
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
      home: const MyHomePage(title: 'Library'),
      routes: {
        // '/': (context) => HomePage(),
        '/downloadpage': (context) => AudioBookDownloadScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _selectedIndex = 0;
  late Future<List<AudioBook>> books ;
  late String icon = "/data/user/0/com.example.clos/app_flutter/1/image.png";
  Directory home = Directory("/data/user/0/com.example.clos/app_flutter/");

  @override
  void initState() {
    super.initState();
    books = readBookManifest();
    // downloadAudioFiles("1");
   // fetchAudioBook("1");
   init();
  }

  void init() async {
    home = await getApplicationDocumentsDirectory();
    // icon = await _getImageString();
  }

  // test function
  Future<String> _getImageString() async {
    // Directory directory = await getApplicationDocumentsDirectory();
    //Directory newdirectory = Directory("${directory.path}/1");
    // print("directory contents");
    // print(directory.listSync());
    // print("directory contents");
    // print(newdirectory.listSync());
    try {
      var getFolder = await getApplicationDocumentsDirectory();
      // print("${getFolder.path}/1/image.png");
      return "${getFolder.path}/1/image.png";
    } catch (e) {
      return "Image.asset(images/clos_logo.png";
    }
  }

  void _onNavBarItemTapped(int index) {
    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (_) => const ExploreScreen(title: 'Explore'),
          ),
        );
        break;
    }
  }

  void _onImageTileTapped() {
    var audiobook = AudioBook.fromPosition("1", "title", "author", "synopsis", "true", "");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(audiobook: audiobook,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Library"),
      body: Container(
        color: Colors.black87,
        child: FutureBuilder<List<AudioBook>>(
          future: books,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is still loading
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If the future completed with an error
              return Text('Error: ${snapshot.error}');
            } else {
              // If the future completed with a result
              // return Text('Result: ${snapshot.data}');
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final book = snapshot.data![index];
                  return imageTile(book.title, book.author, home.path, book.tapeId, _onImageTileTapped);
                }
              );
            }
          }
        )
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex, 
        onTap: _onNavBarItemTapped,
      ),
    );
  }
}