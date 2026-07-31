import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trandtribe/BtmNavBarScreens/HomeScreen.dart';
import 'package:trandtribe/BtmNavBarScreens/MyCartScreen.dart';
import 'package:trandtribe/BtmNavBarScreens/WishlistScreen.dart';
import 'package:trandtribe/BtmNavBarScreens/SettingsScreen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,

        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // To prevent items from shifting
        selectedItemColor: Colors.black, // Selected item color
        unselectedItemColor: Colors.grey, // Unselected item color
        backgroundColor:
            Colors.white, // Background color of the bottom navigation bar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.heart),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SavedScreen(),
    MyCartScreen(),
    SettingsScreen(),
    // ProfileScreen(),
  ];
}
