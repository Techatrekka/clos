import 'package:clos/ui/screens/home_screen/home_page.dart';
import 'package:clos/models/audiobook.dart';
import 'package:flutter/material.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key, required this.title});

  final String title;

  @override
  State<LoadingScreen> createState() => _MyLoadingScreenState();
}

class _MyLoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  final int _selectedIndex = 0;
  bool deleteMode = false;
  late Future<List<AudioBook>> books;
  int index = 0; // Selects the customization.
  static const List<(Color?, Color? background, ShapeBorder?)> customizations =
      <(Color?, Color?, ShapeBorder?)>[
        (null, null, null), // The FAB uses its default for null parameters.
        (null, Colors.red, null),
  ];
  late AnimationController motionController;
  late Animation motionAnimation;
  double size = 20;

  void initState() {
     super.initState();
 
     motionController = AnimationController(
       duration: Duration(seconds: 1),
       vsync: this,
       lowerBound: 0.5,
     );
 
     motionAnimation = CurvedAnimation(
       parent: motionController,
       curve: Curves.ease,
     );
 
     motionController.forward();
     motionController.addStatusListener((status) {
       setState(() {
         if (status == AnimationStatus.completed) {
           motionController.reverse();
         } else if (status == AnimationStatus.dismissed) {
           motionController.forward();
         }
       });
     });
 
     motionController.addListener(() {
       setState(() {
         size = motionController.value * 250;
       });
     });
     init();
     // motionController.repeat();
   }

  void init() async {
    await Future.delayed(const Duration(milliseconds: 2000), (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'Library',)));
            });
  }

  void _onNavBarItemTapped(int index) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (_) => const MyHomePage(title: 'Library'),
      ),
    );
  }

  @override
   void dispose() {
     motionController.dispose();
     super.dispose();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         //A bonus For you
         centerTitle: true,
         title: Text(widget.title, selectionColor: Colors.green,),
         backgroundColor: Colors.black87,
       ),
       backgroundColor: Colors.black87,
       body: Padding(
         padding: const EdgeInsets.only(top: 200, left: 8, right: 8),
         child: Column(
           children: <Widget>[
             Center(
               child: Container(
                 child: Stack(children: <Widget>[
                   Center(
                     child: new Container(
                       child: Image.asset('images/clos_logo.png'),
                       height: size,
                     ),
                   ),
                 ]),
                 height: 200,
               ),
             ),
           ],
         ),
       ), // This trailing comma makes auto-formatting nicer for build methods.
     );
  }
}