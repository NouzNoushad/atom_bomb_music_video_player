import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_music_player/core/colors.dart';
import 'package:simple_music_player/music_player_home/cubit/home_cubit.dart';

import 'music_player_home/view/bottom_nav.dart';
import 'service/music_service.dart';

void main() async {
  await serviceLocator();
  runApp(BlocProvider(
    create: (context) => HomeCubit()..getFilePath(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: CustomColors.primarySwatch,
      ),
      debugShowCheckedModeBanner: false,
      home: const BottomNavigation(),
    );
  }
}
