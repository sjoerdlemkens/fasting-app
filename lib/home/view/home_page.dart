import 'package:flutter/material.dart';
import 'package:fasting_app/fast/fast.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_app/home/home.dart';

const tabWidgets = {
  HomePageTab.fast: FastTab(),
  HomePageTab.settings: SettingsTab(),
};

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageTab _selectedTab = HomePageTab.fast;

  void _onTabSelected(HomePageTab tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabWidgets[_selectedTab],
      bottomNavigationBar: NavBar(
        selectedTab: _selectedTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
