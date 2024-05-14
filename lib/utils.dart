import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

class AudioBook {
  String audioFile;
  String title;
  String author;
  String synopsis;
  String id;
  String iconLocation;
  
  AudioBook(this.audioFile, this.title, this.author, this.synopsis, this.id, this.iconLocation);
}

Future<List<AudioBook>> readBookManifest(String filePath) async {
  final file = File(filePath);
  var books = null;
  try {
    final readDoc = file.readAsStringSync();
    final doc = XmlDocument.parse(readDoc);
    
    books = doc.findAllElements('book').map((XmlElement bookElement) {
      var id = bookElement.findElements('id').singleOrNull?.innerText;
      var title = bookElement.findElements('title').singleOrNull?.innerText;
      var author = bookElement.findElements('author').singleOrNull?.innerText;
      var synopsis = bookElement.findElements('synopsis').singleOrNull?.innerText;
      var audioFile = bookElement.findElements('audioFile').singleOrNull?.innerText;
      var iconLocation = bookElement.findElements('iconLocation').singleOrNull?.innerText;
      
      return AudioBook(
        audioFile ?? "", 
        title ?? "", 
        author ?? "", 
        synopsis ?? "", 
        id ?? "", 
        iconLocation ?? "");
    }).toList();
  } catch (e) {
    print('Error occurred while parsing XML: $e');
  }
  return books ?? List.empty();
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
      XmlElement(XmlName('id'), [], [XmlText(element.id),]),
      XmlElement(XmlName('title'), [], [XmlText(element.title),]),
      XmlElement(XmlName('author'), [], [XmlText(element.author),]),
      XmlElement(XmlName('synopsis'), [], [XmlText(element.synopsis),]),
      XmlElement(XmlName('audioFile'), [], [XmlText(element.audioFile),]),
      ]);
    library.children.add(book);
  }
  document.children.add(library);

  File(filePath).writeAsStringSync(document.toXmlString());
  print('XML file created successfully at: $filePath');
}