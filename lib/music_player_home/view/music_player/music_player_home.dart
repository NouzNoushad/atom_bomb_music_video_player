import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:simple_music_player/core/colors.dart';
import 'package:simple_music_player/model/songs.dart';
import 'package:simple_music_player/music_player_home/view/music_player/songs_bottom_sheet.dart';

import '../../../core/string.dart';
import '../../../model/progress_bar.dart';
import '../../cubit/home_cubit.dart';

class MusicPlayerHome extends StatefulWidget {
  const MusicPlayerHome({super.key});

  @override
  State<MusicPlayerHome> createState() => _MusicPlayerHomeState();
}

class _MusicPlayerHomeState extends State<MusicPlayerHome>
    with SingleTickerProviderStateMixin {
  late HomeCubit homeCubit;

  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    homeCubit.rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();

    super.initState();
  }

  @override
  void dispose() {
    // homeCubit.disposeMusic();
    homeCubit.rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        title: Text(
          '${CustomText.title} Music',
          style: TextStyle(
            color: CustomColors.titleTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        titleTextStyle: TextStyle(
          color: CustomColors.titleTextColor,
          fontSize: 18,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 18,
              color: CustomColors.whiteColor,
            ),
          ),
        ],
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          // HomeCubit homeCubit = HomeCubit.getContext(context);
          return ValueListenableBuilder(
              valueListenable: homeCubit.playlistNotifier,
              builder: (context, snapshot, child) {
                if (snapshot.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: CustomColors.greenColor,
                      color: CustomColors.whiteColor,
                    ),
                  );
                }
                return SafeArea(
                  child: Container(
                    color: CustomColors.lightBackgroundColor,
                    child: Stack(
                      children: [
                        ListView.separated(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 80),
                            itemBuilder: (context, index) {
                              var songs = snapshot[index];
                              return GestureDetector(
                                onTap: () {
                                  // print(
                                  //     '//////////index and song, $index $songs');
                                  homeCubit.updateSelectedSong(songs, index);
                                  // print(
                                  //     'selectedSong, ${homeCubit.selectedSong}');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: CustomColors.backgroundColor),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 22),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.music,
                                        size: 18,
                                        color: CustomColors.titleTextColor,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: Text(
                                        songs,
                                        style: TextStyle(
                                          color: CustomColors.textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 6,
                                ),
                            itemCount: snapshot.length),
                        Positioned(
                          bottom: 0,
                          child: ValueListenableBuilder(
                              valueListenable:
                                  homeCubit.currentSongTitleNotifier,
                              builder: (context, title, child) {
                                return GestureDetector(
                                  onTap: () {
                                    BottomSheetSong.showSongBottomSheet(
                                        context);
                                  },
                                  child: Container(
                                    height: size.height * 0.1,
                                    width: size.width - 20,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: CustomColors.greenColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        border: Border.all(
                                            width: 3, color: Colors.white)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.music,
                                          size: 18,
                                          color: CustomColors.titleTextColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: title.length > 5
                                              ? Marquee(
                                                  blankSpace: 50,
                                                  text: title,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: CustomColors
                                                          .textColor),
                                                )
                                              : Text(title,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: CustomColors
                                                          .textColor)),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ValueListenableBuilder<ButtonBarState>(
                                            valueListenable:
                                                homeCubit.buttonNotifier,
                                            builder: (context, value, child) {
                                              switch (value) {
                                                case ButtonBarState.playing:
                                                  return GestureDetector(
                                                    onTap: homeCubit.pauseMusic,
                                                    child: const CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          CustomColors
                                                              .whiteColor,
                                                      child: Icon(
                                                        Icons.pause,
                                                        color: CustomColors
                                                            .greenColor,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  );
                                                case ButtonBarState.loading:
                                                case ButtonBarState.paused:
                                                  return GestureDetector(
                                                    onTap: homeCubit.playMusic,
                                                    child: const CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          CustomColors
                                                              .whiteColor,
                                                      child: Icon(
                                                        Icons.play_arrow,
                                                        color: CustomColors
                                                            .greenColor,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  );
                                                default:
                                                  return Container();
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(FontAwesomeIcons.xmark, size: 18),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(FontAwesomeIcons.arrowLeft, size: 18),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List matchMusic = [];
    var homeCubit = BlocProvider.of<HomeCubit>(context);
    matchMusic = homeCubit.songs
        .where((song) => song.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return searchMusicList(matchMusic, homeCubit);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List matchMusic = [];
    var homeCubit = BlocProvider.of<HomeCubit>(context);
    matchMusic = homeCubit.songs
        .where((song) => song.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return searchMusicList(matchMusic, homeCubit);
  }

  Widget searchMusicList(matchMusic, homeCubit) => ListView.separated(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 80),
      itemBuilder: (context, index) {
        Songs songs = matchMusic[index];
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: CustomColors.backgroundColor),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                FontAwesomeIcons.music,
                size: 18,
                color: CustomColors.titleTextColor,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Text(
                songs.name,
                style: TextStyle(
                  color: CustomColors.textColor,
                  fontWeight: FontWeight.w600,
                ),
              )),
              ValueListenableBuilder<ButtonBarState>(
                  valueListenable: homeCubit.buttonNotifier,
                  builder: (context, value, child) {
                    switch (value) {
                      case ButtonBarState.loading:
                      case ButtonBarState.paused:
                        return GestureDetector(
                          onTap: () => homeCubit.onTapSearchMusic(songs),
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: CustomColors.whiteColor,
                            child: Icon(
                              Icons.play_arrow,
                              color: CustomColors.greenColor,
                              size: 30,
                            ),
                          ),
                        );
                      case ButtonBarState.playing:
                        return songs.name == homeCubit.selectedSearchSong
                            ? GestureDetector(
                                onTap: homeCubit.pauseMusic,
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: CustomColors.whiteColor,
                                  child: Icon(
                                    Icons.pause,
                                    color: CustomColors.greenColor,
                                    size: 30,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () => homeCubit.onTapSearchMusic(songs),
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: CustomColors.whiteColor,
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: CustomColors.greenColor,
                                    size: 30,
                                  ),
                                ),
                              );
                      default:
                        return Container();
                    }
                  }),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
            height: 6,
          ),
      itemCount: matchMusic.length);
}
