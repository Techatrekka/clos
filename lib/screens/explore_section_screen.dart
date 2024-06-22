import 'package:clos/screens/audiobook_download_screen.dart';
import 'package:clos/widgets/custom_app_bar.dart';
import 'package:clos/widgets/library_list_tile.dart';
import 'package:clos/utils/models.dart';
import 'package:clos/utils/network.dart';
import 'package:flutter/material.dart';

class ExploreSectionScreen extends StatefulWidget {
  const ExploreSectionScreen({super.key, required this.title});

  final String title;

  @override
  State<ExploreSectionScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreSectionScreen> {
  late Future<List<AudioBook>> offering;
  
  @override
  void initState() {
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    offering = fetchAudioBookList();
    return Scaffold(
      appBar: const CustomAppBar(title: "Explore"),
      body: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.867),
        width: 500,
        height: 1000,
        child: 
        FutureBuilder<List<AudioBook>> (
          future: offering,
          initialData: [AudioBook.fromPosition("audioFile", "title", "author", "synopsis", "id", "iconLocation")],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  var currentEntry = snapshot.data!;
                  return ListTile(
                    title: Center (
                      child: Column(
                        children: [
                          Text(
                            currentEntry[index].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              color: Color.fromARGB(230, 255, 255, 255),
                            ),
                          ),
                          Text(
                            currentEntry[index].author,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    minVerticalPadding: 30,
                    onTap: () {
                      Navigator.pushNamed(
                      context,
                      '/downloadpage',
                      arguments: currentEntry[index],
                    );
                    },
                  );
                },
              );
            } else {
                return const CircularProgressIndicator();
            }
          },
        )
      ),
    );
  }
}