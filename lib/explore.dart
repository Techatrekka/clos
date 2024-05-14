import 'package:clos/custom_app_bar.dart';
import 'package:clos/custom_navigation.dart';
import 'package:clos/library_list_tile.dart';
import 'package:clos/main.dart';
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

  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Explore"),
      body: Container(
        color: Colors.black87,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(25),
          clipBehavior: Clip.hardEdge,
          itemCount: options.length,
          itemBuilder: (context, index) {
            final book = options[index];
            return optionTile(book, book, _onOptionTileTouched);
          }
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex : _selectedIndex,
        onTap: _onNavBarItemTapped,),
    );
  }
}