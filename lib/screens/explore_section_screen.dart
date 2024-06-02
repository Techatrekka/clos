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
  final List<String> options = ["List.empty()","List.empty()","List.empty()"];
  late Future<List<AudioBook>> offering;
  
  @override
  void initState() {
    super.initState();
      offering = fetchAudioBookList();
  }

  void _onOptionTileTouched() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const AudioBookDownloadScreen(sectionTitle: 'Library')));
  }

 @override
  Widget build(BuildContext context) {
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
                  return optionTile(
                    currentEntry[index].audioFile, currentEntry[index].title, _onOptionTileTouched
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