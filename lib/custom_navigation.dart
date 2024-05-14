import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomBottomNavigation extends StatefulWidget {

const CustomBottomNavigation({super.key, this.selectedIndex = 0, required this.onTap});

final int selectedIndex;
final void Function(int) onTap;

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  MaterialColor _library = Colors.amber;
  MaterialColor _explore = Colors.green;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print("WidgetsBinding");
    // });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _selectedIcon(widget.selectedIndex);
    });
  }

  void _selectedIcon(int index) {
    switch (index) {
      case 0:
        setState(() {
          _library = Colors.amber;
          _explore = Colors.green;
        });
        break;
      case 1:
        setState(() {
          _library = Colors.green;
          _explore = Colors.amber;
        });
        break;
    }
  }

@override
Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
         BottomNavigationBarItem(
          icon: Icon(
            Icons.library_books,
            color: _library,
          ),
          label: "Library",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: _explore,
            ),
          label: "Explore",
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.green,
      onTap: widget.onTap,
      backgroundColor: Colors.black,
    );
  }
}