import 'dart:io';

import 'package:clos/ui/screens/download_screen/audiobook_download_screen.dart';
import 'package:clos/ui/screens/player_screen/audioplayer_screen.dart';
import 'package:clos/ui/screens/home_screen/information_screen.dart';
import 'package:clos/services/service_locator.dart';
import 'package:clos/services/common_functions.dart';
import 'package:clos/services/io/manifest_handler.dart';
import 'package:clos/ui/widgets/custom_app_bar.dart';
import 'package:clos/ui/widgets/custom_navigation.dart';
import 'package:clos/ui/screens/home_screen/explore_screen.dart';
import 'package:clos/models/audiobook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';


Future<void> main() async {
  await setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(
    debug: true, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );
  // late List<AudioBook> books = [(AudioBook.fromPosition("1", "Is Gearr", "Marian Keyes", "synopsis", "true", "/data/user/0/com.example.clos/app_flutter/1/image.png")),
  //   (AudioBook.fromPosition("2", "title", "author", "synopsis", "true", "/data/user/0/com.example.clos/app_flutter/1/age.png")),
  //   (AudioBook.fromPosition("3", "title", "author", "synopsis", "false", "/data/user/0/com.example.clos/app_flutter/1/image.png"))];
  // await writeToManifest(books);
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
        '/downloadpage': (context) => const AudioBookDownloadScreen(),
        // '/playerpage': (context) => PlayerScreen(),
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
  bool deleteMode = false;
  late Future<List<AudioBook>> books;
  Directory home = Directory("/data/user/0/com.example.clos/app_flutter/");
  int index = 0; // Selects the customization.
  static const List<(Color?, Color? background, ShapeBorder?)> customizations =
      <(Color?, Color?, ShapeBorder?)>[
        (null, null, null), // The FAB uses its default for null parameters.
        (null, Colors.red, null),
  ];

  @override
  void initState() {
    super.initState();
    books = readBookManifest();
    init();
    // createManifestWhereNoneDetected();
  }

  void init() async {
    home = await getApplicationDocumentsDirectory();
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
      case 2:
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const InformationScreen(title: 'Information')));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Library"),
      body: Container(
        height: 1500,
        width: 1500,
        color: Colors.black87,
        child: FutureBuilder<List<AudioBook>>(
          future: books,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is still loading
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If the future completed with an error
              // return Text('Error: ${snapshot.error}');
              return 
                const Flex(
                  direction: Axis.vertical,
                  children: [ Expanded(child: 
                    Text(
                      "Please add to Library",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Color.fromARGB(230, 255, 255, 255),
                        ),
                      )
                    )
                  ],
                );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final book = snapshot.data![index];
                  return ListTile(
                    title: Center (
                      child: Column(
                        children: [
                          Visibility(
                            visible: deleteMode,
                            child: IconButton(
                              color:  Colors.red,
                              onPressed: () {
                                // final folder = Directory("${home.path}/${book.tapeId}");
                                // folder.deleteSync(recursive: true);
                                refreshManifest();
                              }, 
                              icon: const Icon(Icons.delete)),
                            ),
                          TryGetImageFile(home.path, book.tapeId),
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: Color.fromARGB(230, 255, 255, 255),
                            ),
                          ),
                          Text(
                            book.author,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    minVerticalPadding: 10,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlayerScreen(tapeId: book.tapeId,)));
                    },
                  );
                }
              );
            }
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          refreshManifest();
          deleteMode = !deleteMode;
          setState(() {
            index = (index + 1) % customizations.length;
          });
        },
        foregroundColor: customizations[index].$1,
        backgroundColor: customizations[index].$2,
        child: const Icon(Icons.delete),),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex, 
        onTap: _onNavBarItemTapped,
      ),
    );
  }
}