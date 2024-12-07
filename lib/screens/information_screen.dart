import 'package:clos/main.dart';
import 'package:clos/screens/audiobook_download_screen.dart';
import 'package:clos/screens/explore_screen.dart';
import 'package:clos/widgets/custom_app_bar.dart';
import 'package:clos/widgets/custom_navigation.dart';
import 'package:clos/widgets/library_list_tile.dart';
import 'package:clos/utils/models.dart';
import 'package:clos/utils/network.dart';
import 'package:flutter/material.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key, required this.title});

  final String title;

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final int _selectedIndex = 2;
  late Future<List<TionscadalEolais>> fograi;
  
  @override
  void initState() {
    fograi = getApplicationUpdates();
    super.initState();
  }

  void _onNavBarItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Library')));
        break;
      case 1:
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (_) => const ExploreScreen(title: 'Explore')));
        break;
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Information"),
      body: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.867),
        child: 
          FutureBuilder<List<TionscadalEolais>> (
          future: fograi,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemBuilder: (context, index) {
                    var currentEntry = snapshot.data!;
                    return ListTile(
                    title: Center (
                      child: Column(
                        children: [
                          Text(
                            currentEntry[index].teideal,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: Color.fromARGB(230, 255, 255, 255),
                            ),
                          ),
                          Text(
                            currentEntry[index].fogra,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            currentEntry[index].teideal,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: Color.fromARGB(230, 255, 255, 255),
                            ),
                          )
                        ],
                      ),
                    ),
                    minVerticalPadding: 30,
                    onTap: () {},
                  );
                }
              );
            } else {
              return const Text("FADHBANNA ANN");
            }
          }),
        ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex : _selectedIndex,
        onTap: _onNavBarItemTapped,
      ),
    );
  }
}