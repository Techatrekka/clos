import 'dart:io';
import 'package:clos/utils/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

Future<List<AudioBook>> readBookManifest() async {
  Directory directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/manifest.xml");
  late List<AudioBook> books;
  try {
    final readDoc = file.readAsStringSync();
    final doc = XmlDocument.parse(readDoc);
    
    books = doc.findAllElements('book').map((XmlElement bookElement) {
      var tapeId = bookElement.findElements('tape_id').singleOrNull?.innerText;
      var title = bookElement.findElements('title').singleOrNull?.innerText;
      var author = bookElement.findElements('author').singleOrNull?.innerText;
      var synopsis = bookElement.findElements('synopsis').singleOrNull?.innerText;
      var isAudiobook = bookElement.findElements('is_audiobook').singleOrNull?.innerText;
      var tags = bookElement.findElements('tags').singleOrNull?.innerText;
      
      return AudioBook.fromPosition(
        tapeId ?? "", 
        title ?? "", 
        author ?? "", 
        synopsis ?? "", 
        isAudiobook ?? "", 
        tags ?? "");
    }).toList();
  } catch (e) {
    return [];
  }
  return books;
}

Future<void> writeToManifest(List<AudioBook> curretBooks) async {
  var directory = await getApplicationDocumentsDirectory();
  var filePath = '${directory.path}/manifest.xml';
  var existingManifest = File(filePath);
  if (existingManifest.existsSync()) {
    existingManifest.deleteSync();
  }
  final document = XmlDocument([
    XmlProcessing('xml', 'version="1.0"')
  ]);
  final library = XmlElement(XmlName('library'));
  for (var element in curretBooks) { 
    final book = XmlElement(XmlName("book"), 
      [], [
      XmlElement(XmlName('tape_id'), [], [XmlText(element.tapeId),]),
      XmlElement(XmlName('title'), [], [XmlText(element.title),]),
      XmlElement(XmlName('author'), [], [XmlText(element.author),]),
      XmlElement(XmlName('synopsis'), [], [XmlText(element.synopsis),]),
      XmlElement(XmlName('is_audiobook'), [], [XmlText(element.isAudiobook),]),
      XmlElement(XmlName('tags'), [], [XmlText(element.tags),]),
      ]);
    library.children.add(book);
  }
  document.children.add(library);

  File(filePath).writeAsStringSync(document.toXmlString());
  // this is a debug that will be important as it will let you know if there are permissions/other problems
  print('XML file created successfully at: $filePath');
}

void placeAudioFile(File audio, String id) async {
  var directory = await getApplicationDocumentsDirectory();
  var filePath = '${directory.path}/$id';
  audio.copy(filePath);
  audio.create(recursive: true, exclusive: false);
}

void createManifestWhereNoneDetected() async {
  var directory = await getApplicationDocumentsDirectory();
  var exemptFolders = {"flutter_assets"};
  var files = await directory.list().toList();
  print(files.first.path.toString().split("/").last);
}