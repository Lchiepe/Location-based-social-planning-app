import 'package:flutter/material.dart';

import 'map_screen.dart';
import 'home_screen.dart';

class NavScreen extends StatefulWidget {

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {

  final List<Widget> _screens = [
    HomeScreen(key: PageStorageKey('homeScreen')),
    Scaffold(),
    MapPage(key: PageStorageKey('myMaps')),
    Scaffold(),
    Scaffold(),

  ];

  final Map<String, IconData> _Icon =const{
    'Home' : Icons.home,
    'Friends': Icons.contactless,
    'MyMap' : Icons.map,
    'Games(coming soon)' : Icons.games,
  };

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          items: _Icon.map((title,icon) => MapEntry(
              title,
              BottomNavigationBarItem(
                icon: Icon(icon, size: 30.0),
                label: title,
                backgroundColor: Colors.black54,
              )))
              .values
              .toList(),
          currentIndex: _currentIndex,
          selectedItemColor: Colors.deepPurpleAccent,
          selectedFontSize: 11.0,
          unselectedItemColor: Colors.grey,
          unselectedFontSize: 11.0,
          onTap: (index) => setState(()=> _currentIndex = index),
        ),
    );
  }
}