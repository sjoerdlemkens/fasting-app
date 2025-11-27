import 'package:fasting_app/home/home.dart';
import 'package:flutter/material.dart';

const navBarItems = {
  HomePageView.fast: NavigationDestination(
    icon: Icon(Icons.schedule),
    label: 'Fast',
  ),
  HomePageView.history: NavigationDestination(
    icon: Icon(Icons.history),
    label: 'History',
  ),
  HomePageView.settings: NavigationDestination(
    icon: Icon(Icons.settings),
    label: 'Settings',
  ),
};

class NavBar extends StatelessWidget {
  final HomePageView selectedView;
  final Function(HomePageView view) onViewSelected;

  const NavBar({
    super.key,
    required this.selectedView,
    required this.onViewSelected,
  });

  void _onItemSelected(int index) {
    final view = HomePageView.values[index];
    onViewSelected(view);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: HomePageView.values.indexOf(selectedView),
      onDestinationSelected: _onItemSelected,
      destinations: navBarItems.values.toList(),
    );
  }
}
