import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:simple_music_player/core/colors.dart';
import 'package:simple_music_player/music_player_home/cubit/home_cubit.dart';
import 'package:simple_music_player/music_player_home/view/video_player/video_player_home.dart';

import 'music_player/music_player_home.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  getPages(index) {
    switch (index) {
      case 0:
        return const MusicPlayerHome();
      case 1:
        return const VideoPlayerHome();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var homeCubit = BlocProvider.of<HomeCubit>(context);
        return Scaffold(
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: Colors.white),
            ),
            child: GNav(
              gap: 10,
              backgroundColor: CustomColors.greenColor,
              tabBackgroundColor: CustomColors.lightBackgroundColor,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              activeColor: CustomColors.backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              tabMargin: const EdgeInsets.all(10),
              iconSize: 18,
              selectedIndex: homeCubit.selectedIndex,
              onTabChange: homeCubit.onTabChange,
              tabs: [
                GButton(
                  iconColor: CustomColors.titleTextColor,
                  icon: FontAwesomeIcons.music,
                  text: 'Music',
                ),
                GButton(
                  iconColor: CustomColors.titleTextColor,
                  icon: FontAwesomeIcons.video,
                  text: 'Video',
                ),
              ],
            ),
          ),
          body: getPages(homeCubit.selectedIndex),
        );
      },
    );
  }
}
