import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_app/home/home.dart';
import 'package:fasting_app/fasting/fasting.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FastingBloc>(
      create: (context) => FastingBloc(
        fastingRepo: context.read<FastingRepository>(),
      ),
      child: HomeView(),
    );
  }
}
