import 'package:fasting_app/home/home.dart';
import 'package:flutter/material.dart';

const navBarItems = {
  HomePageTab.fast: NavigationDestination(
    icon: Icon(Icons.schedule),
    label: 'Fast',
  ),
  HomePageTab.settings: NavigationDestination(
    icon: Icon(Icons.settings),
    label: 'Settings',
  ),
};

class NavBar extends StatelessWidget {
  final HomePageTab selectedTab;
  final Function(HomePageTab tab) onTabSelected;

  const NavBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  void _onItemSelected(int index) {
    final tab = HomePageTab.values[index];
    onTabSelected(tab);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: HomePageTab.values.indexOf(selectedTab),
      onDestinationSelected: _onItemSelected,
      destinations: navBarItems.values.toList(),
    );
  }
}
