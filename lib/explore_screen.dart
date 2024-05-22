import 'package:clos/custom_app_bar.dart';
import 'package:clos/custom_navigation.dart';
import 'package:clos/library_list_tile.dart';
import 'package:clos/main.dart';
import 'package:clos/models.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key, required this.title});

  final String title;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final int _selectedIndex = 1;
  final List<String> options = ["List.empty()","List.empty()","List.empty()"];
  final List<Section> headings = [
    Section("title", "images/clos_logo.png"),
    Section("title", "images/clos_logo.png"),
    Section("title", "images/clos_logo.png"),
    Section("title", "images/clos_logo.png"),];
  // late Future<List<AudioBook>> offering;
  
  // @override
  // void initState() {
  //   super.initState();
  //     offering = fetchAudioBookList();
  // }

  void _onNavBarItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Library')));
        break;
    }
  }

  void _onOptionTileTouched() {
    print("object");
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Explore"),
      body: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.867),
        width: 500,
        height: 1000,
        child: ListView.builder(
          padding: const EdgeInsets.all(25),
          clipBehavior: Clip.hardEdge,
          scrollDirection: Axis.vertical,
          itemCount: headings.length,
          itemBuilder: (context, index) {
            final heading = headings[index];
            return sectionTile(heading.title, heading.iconLocation, _onOptionTileTouched);
          },
        ),
        // FutureBuilder<List<AudioBook>> (
        //   future: offering,
        //   initialData: [AudioBook.fromPosition("audioFile", "title", "author", "synopsis", "id", "iconLocation")],
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //     return ListView.builder(
        //         itemCount: snapshot.data?.length ?? 0,
        //         itemBuilder: (context, index) {
        //           var currentEntry = snapshot.data!;
        //           return optionTile(
        //             currentEntry[index].audioFile, currentEntry[index].title, _onOptionTileTouched
        //           );
        //         },
        //     );
        //   } else {
        //       return const CircularProgressIndicator();
        //   }
            // if (snapshot.hasData) {
            //   return Text(snapshot.data!.title, style: TextStyle(color: Colors.white),);
            // } else if (snapshot.hasError) {
            //   return Text('${snapshot.error}', style: TextStyle(color: Colors.white),);
            // }
            // // By default, show a loading spinner.
            // return const CircularProgressIndicator();
          // },
        // )
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex : _selectedIndex,
        onTap: _onNavBarItemTapped,
      ),
    );
  }
}