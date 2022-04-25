import 'package:flutter/material.dart';
import 'package:skate_spots_app/pages/main/add_spot_page.dart';
import 'package:skate_spots_app/pages/main/favorites_page.dart';
import 'package:skate_spots_app/pages/main/home_page.dart';
import 'package:skate_spots_app/pages/main/profile_page.dart';
import 'package:skate_spots_app/pages/main/settings_page.dart';

class MainPage extends StatefulWidget {
  final int currentPage;
  const MainPage({Key? key, required this.currentPage}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPage = 2;

  final _scenes = [
    const PrfilePage(),
    const AddSpotPage(),
    const Home(),
    const FavoritesPage(),
    const SettingsPage()
  ];

  @override
  void initState() {
    super.initState();
    if (_currentPage == -1) _currentPage = widget.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _scenes[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _currentPage,
          onTap: (index) => setState(() => _currentPage = index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add Spot',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Map',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favoirtes',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
                backgroundColor: Colors.green)
          ]),
    );
  }
}
