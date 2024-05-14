import 'package:clos/custom_app_bar.dart';
import 'package:clos/custom_navigation.dart';
import 'package:clos/library_list_tile.dart';
import 'package:clos/explore.dart';
import 'package:clos/utils.dart';
import 'package:flutter/material.dart';


void main() {
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
  final List<AudioBook> books = [(AudioBook("audioFile", "title", "author", "synopsis", "id", "images/clos_logo.png")),
  (AudioBook("audioFile", "title", "author", "synopsis", "id", "images/clos_logo.png")),
  (AudioBook("audioFile", "title", "author", "synopsis", "id", "images/clos_logo.png"))];

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

  // void 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Library"),
      body: Container(
        color: Colors.black87,
        child: ListView.builder(
          padding: const EdgeInsets.all(25),
          clipBehavior: Clip.hardEdge,
          scrollDirection: Axis.vertical,
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return homeTile(book.title, book.author, book.iconLocation);
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex, 
        onTap: _onNavBarItemTapped,
      ),
    );
  }
}