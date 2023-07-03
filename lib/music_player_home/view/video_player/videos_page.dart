import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_music_player/core/colors.dart';
import 'package:simple_music_player/music_player_home/cubit/home_cubit.dart';

import '../../../model/videos.dart';

class VideosPage extends StatefulWidget {
  final Videos video;
  const VideosPage({super.key, required this.video});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  Widget? playerWidget;

  late BetterPlayerController betterPlayerController;
  late HomeCubit homeCubit;

  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.stopMusic();

    betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          aspectRatio: 18 / 9,
          fit: BoxFit.contain,
          expandToFill: false,
        ),
        betterPlayerDataSource: BetterPlayerDataSource(
            BetterPlayerDataSourceType.file, widget.video.path!.path));

    playerWidget = BetterPlayer(controller: betterPlayerController);

    super.initState();
  }

  @override
  dispose() {
    betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: CustomColors.blackColor,
      body: Center(
        child: AspectRatio(
            aspectRatio: 16 / 9, child: playerWidget ?? Container()),
      ),
    );
  }
}
