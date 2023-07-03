import 'dart:math';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:simple_music_player/music_player_home/cubit/home_cubit.dart';

import '../../../core/colors.dart';
import '../../../core/string.dart';
import '../../../model/progress_bar.dart';

class BottomSheetSong {
  static showSongBottomSheet(context) {
    var homeCubit = BlocProvider.of<HomeCubit>(context);
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: CustomColors.lightBackgroundColor,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: ValueListenableBuilder(
              valueListenable: homeCubit.currentSongTitleNotifier,
              builder: (context, title, child) {
                return Column(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: CustomColors.blackColor,
                            ),
                          ),
                          Flexible(
                            child: title.length > 5
                                ? Marquee(
                                    blankSpace: 50,
                                    text: title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            CustomColors.titleTextColor),
                                  )
                                : Text(title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            CustomColors.titleTextColor)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    flex: 7,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: AnimatedBuilder(
                              animation: homeCubit.rotationController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle:
                                      homeCubit.rotationController.value *
                                          2 *
                                          pi,
                                  child: CircleAvatar(
                                    radius: 150,
                                    backgroundColor:
                                        CustomColors.blackColor,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          CustomColors.whiteLightColor,
                                      radius: 100,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            bottom: 20,
                                            left: 20,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(
                                                      10.0),
                                              child: ArcText(
                                                radius: 120,
                                                text: title,
                                                placement:
                                                    Placement.outside,
                                                startAngle: 6,
                                                textStyle: const TextStyle(
                                                    color: CustomColors
                                                        .whiteColor,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          const CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                CustomColors.whiteColor,
                                            child: CircleAvatar(
                                              radius: 6,
                                              backgroundColor:
                                                  CustomColors.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Transform(
                            transform: Matrix4.rotationZ(-5.6),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.20,
                              // color: Colors.yellow,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 134,
                                    left: 10,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          CustomColors.greenColor,
                                      radius: 8,
                                      child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor:
                                            CustomColors.titleTextColor,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 15,
                                    child: Container(
                                      height: 130,
                                      width: 4,
                                      decoration: BoxDecoration(
                                        color: CustomColors.greenColor,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor:
                                        CustomColors.greenColor,
                                    radius: 18,
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor:
                                          CustomColors.titleTextColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: ValueListenableBuilder<ProgressBarState>(
                              valueListenable: homeCubit.progressNotifier,
                              builder: (context, value, child) {
                                return ProgressBar(
                                    progress: value.progress!,
                                    total: value.total!,
                                    buffered: value.buffered,
                                    onSeek: homeCubit.seekMusic,
                                    thumbRadius: 4,
                                    timeLabelPadding: 6);
                              }),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder<bool>(
                                  valueListenable: homeCubit
                                      .isShuffleModeEnabledNotifier,
                                  builder: (context, isEnabled, child) {
                                    return GestureDetector(
                                      onTap: homeCubit.shuffleMusic,
                                      child: Icon(
                                        Icons.shuffle,
                                        color: isEnabled
                                            ? CustomColors.greenColor
                                            : CustomColors.lightColor,
                                        size: 25,
                                      ),
                                    );
                                  }),
                              const Text(
                                CustomText.title,
                                style: TextStyle(
                                    color: CustomColors.backgroundColor),
                              ),
                              ValueListenableBuilder<RepeatState>(
                                  valueListenable:
                                      homeCubit.repeatButtonNotifier,
                                  builder: (context, value, child) {
                                    Icon icon;
                                    switch (value) {
                                      case RepeatState.off:
                                        icon = Icon(Icons.repeat,
                                            color:
                                                CustomColors.lightColor,
                                            size: 25);
                                        break;
                                      case RepeatState.repeatSong:
                                        icon = const Icon(
                                            Icons.repeat_one,
                                            color:
                                                CustomColors.greenColor,
                                            size: 25);
                                        break;
                                      case RepeatState.repeatPlaylist:
                                        icon = const Icon(Icons.repeat,
                                            color:
                                                CustomColors.greenColor,
                                            size: 25);
                                        break;
                                    }
                                    return GestureDetector(
                                      onTap: homeCubit.repeatMusic,
                                      child: icon,
                                    );
                                  })
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder<bool>(
                                  valueListenable:
                                      homeCubit.isFirstSongNotifier,
                                  builder: (context, isFirst, child) {
                                    return GestureDetector(
                                      onTap: isFirst
                                          ? null
                                          : homeCubit.previousMusic,
                                      child: const Icon(
                                        Icons.skip_previous,
                                        color: CustomColors.greenColor,
                                        size: 40,
                                      ),
                                    );
                                  }),
                              ValueListenableBuilder<ButtonBarState>(
                                  valueListenable:
                                      homeCubit.buttonNotifier,
                                  builder: (context, value, child) {
                                    switch (value) {
                                      case ButtonBarState.playing:
                                        return GestureDetector(
                                          onTap: homeCubit.pauseMusic,
                                          child: const CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                CustomColors.whiteColor,
                                            child: Icon(
                                              Icons.pause,
                                              color:
                                                  CustomColors.greenColor,
                                              size: 40,
                                            ),
                                          ),
                                        );
                                      case ButtonBarState.loading:
                                      case ButtonBarState.paused:
                                        return GestureDetector(
                                          onTap: homeCubit.playMusic,
                                          child: const CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                CustomColors.whiteColor,
                                            child: Icon(
                                              Icons.play_arrow,
                                              color:
                                                  CustomColors.greenColor,
                                              size: 40,
                                            ),
                                          ),
                                        );
                                      default:
                                        return Container();
                                    }
                                  }),
                              ValueListenableBuilder(
                                  valueListenable:
                                      homeCubit.isLastSongNotifier,
                                  builder: (context, isLast, child) {
                                    return GestureDetector(
                                      onTap: isLast
                                          ? null
                                          : homeCubit.nextMusic,
                                      child: const Icon(Icons.skip_next,
                                          color: CustomColors.greenColor,
                                          size: 40),
                                    );
                                  })
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  )
                ]);
              }),
        ));
  }
}
