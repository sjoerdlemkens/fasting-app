import 'package:flutter/material.dart';
import 'package:fasting_app/app/app.dart';
import 'package:fasting_app/home/home.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fasting Tracker',
      theme: FastingTheme.light,
      // darkTheme: FastingTheme.dark,
      home: const HomePage(),
    );
  }
}
