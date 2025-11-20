import 'package:flutter/material.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_app/home/home.dart';

const homeViewWidgets = {
  HomePageView.fast: FastingView(),
  HomePageView.settings: SettingsView(),
};

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomePageView _selectedView = HomePageView.fast;

  void _onViewSelected(HomePageView view) {
    setState(() {
      _selectedView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: homeViewWidgets[_selectedView],
      bottomNavigationBar: NavBar(
        selectedView: _selectedView,
        onViewSelected: _onViewSelected,
      ),
    );
  }
}
