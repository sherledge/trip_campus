import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'international_packages_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    InternationalPackagesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF052937),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.home, 0),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.favorite, 1),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.airplane_ticket, 2),
              label: "International",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200), // Reduced duration for a smoother transition
      curve: Curves.easeInOut, // Subtle easing for a more professional look
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(12),
      child: Icon(
        icon,
        color: isSelected ? Color(0xFF052937) : Colors.grey,
      ),
    );
  }
}
