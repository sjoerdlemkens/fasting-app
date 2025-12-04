import 'package:flutter/material.dart';
import 'package:fasting_app/history/history.dart';
import 'package:fasting_app/fasting/fasting.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_app/home/home.dart';

const _homeViewWidgets = {
  HomePageView.fast: FastingView(),
  HomePageView.history: HistoryView(),
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
  Widget build(BuildContext context) => Scaffold(
        appBar: HomeAppBar(_selectedView),
        body: _homeViewWidgets[_selectedView],
        bottomNavigationBar: HomeNavBar(
          selectedView: _selectedView,
          onViewSelected: _onViewSelected,
        ),
      );
}
