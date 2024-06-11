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
      var id = bookElement.findElements('id').singleOrNull?.innerText;
      var title = bookElement.findElements('title').singleOrNull?.innerText;
      var author = bookElement.findElements('author').singleOrNull?.innerText;
      var synopsis = bookElement.findElements('synopsis').singleOrNull?.innerText;
      var audioFile = bookElement.findElements('audioFile').singleOrNull?.innerText;
      var iconLocation = bookElement.findElements('iconLocation').singleOrNull?.innerText;
      
      return AudioBook.fromPosition(
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
      XmlElement(XmlName('id'), [], [XmlText(element.id),]),
      XmlElement(XmlName('title'), [], [XmlText(element.title),]),
      XmlElement(XmlName('author'), [], [XmlText(element.author),]),
      XmlElement(XmlName('synopsis'), [], [XmlText(element.synopsis),]),
      XmlElement(XmlName('audioFile'), [], [XmlText(element.audioFile),]),
      XmlElement(XmlName('iconLocation'), [], [XmlText(element.iconLocation),]),
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