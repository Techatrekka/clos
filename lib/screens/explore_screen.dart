import 'package:clos/screens/explore_section_screen.dart';
import 'package:clos/widgets/custom_app_bar.dart';
import 'package:clos/widgets/custom_navigation.dart';
import 'package:clos/widgets/library_list_tile.dart';
import 'package:clos/main.dart';
import 'package:clos/utils/models.dart';
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
    Section("ClosLeabhair ag teideal", "images/clos_logo.png"),
    Section("Closleabhair ag t-Údar", "images/clos_logo.png"),
    Section("Seanachaí", "images/clos_logo.png"),];

  void _onNavBarItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Library')));
        break;
    }
  }

  void _onSectionTileTouched() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const ExploreSectionScreen(title: "title",))
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Explore"),
      body:  Container(
        color: const Color.fromRGBO(0, 0, 0, 0.867),
        child: ListView(
          children: [
            sectionTile(headings[0].title, headings[0].iconLocation, _onSectionTileTouched),
            sectionTile(headings[1].title, headings[1].iconLocation, _onSectionTileTouched),
            sectionTile(headings[2].title, headings[2].iconLocation, _onSectionTileTouched),
            sectionTile(headings[3].title, headings[3].iconLocation, _onSectionTileTouched),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex : _selectedIndex,
        onTap: _onNavBarItemTapped,
      ),
    );
  }
}