import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final bool isDark;
  final Function(int) onItemTapped;
  final Color backgroundColor; // Arka plan rengi

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.backgroundColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontFamily: "Prompt",
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 6,
      ),
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.homeLg, size: 24),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.search, size: 24),
          label: 'Search',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_outline, size: 24),
          label: 'My Learning',
        ),
        const BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.heart, size: 24),
          label: 'Favorites',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 24),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: isDark ? Colors.white : Colors.black,
      // Seçilen ikon rengi
      unselectedItemColor: Colors.grey,
      // Seçilmeyen ikon rengi
      backgroundColor: isDark ? Colors.black : Colors.white,
      // Arka plan rengi
      onTap: onItemTapped,
    );
  }
}
