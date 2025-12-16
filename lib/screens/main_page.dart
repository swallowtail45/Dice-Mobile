import 'package:flutter/material.dart';

import 'roller.dart';
import 'library.dart';
import 'profile.dart';
import 'navbar.dart';
import 'home_wrapper.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1; // default Dice

  final List<Widget> _pages = const [
    HomeWrapper(), // index 0
    DiceRollerPage(), // index 1
    LibraryPage(), // index 2
    ProfilePage(), // index 3
  ];

  void _onNavbarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _pages),

          Align(
            alignment: Alignment.bottomCenter,
            child: CustomNavbar(
              selectedIndex: _currentIndex,
              onTap: _onNavbarTapped,
            ),
          ),
        ],
      ),
    );
  }
}
