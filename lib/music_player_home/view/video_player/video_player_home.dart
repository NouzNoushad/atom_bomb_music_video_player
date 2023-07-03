import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_music_player/model/videos.dart';
import 'package:simple_music_player/music_player_home/cubit/home_cubit.dart';
import 'package:simple_music_player/music_player_home/view/video_player/videos_page.dart';

import '../../../core/colors.dart';
import '../../../core/string.dart';

class VideoPlayerHome extends StatefulWidget {
  const VideoPlayerHome({super.key});

  @override
  State<VideoPlayerHome> createState() => _VideoPlayerHomeState();
}

class _VideoPlayerHomeState extends State<VideoPlayerHome> {
  late HomeCubit homeCubit;

  @override
  void initState() {
    homeCubit = BlocProvider.of<HomeCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.backgroundColor,
          title: Text(
            '${CustomText.title} Video',
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
            var homeCubit = BlocProvider.of<HomeCubit>(context);
            return ValueListenableBuilder<List<Videos>>(
                valueListenable: homeCubit.videoNotifier,
                builder: (context, videos, child) {
                  if (videos.isEmpty) {
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
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 18),
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          var video = videos[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      VideosPage(video: video)));
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
                                    FontAwesomeIcons.video,
                                    size: 18,
                                    color: CustomColors.titleTextColor,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                      child: Text(
                                    video.name,
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
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                      ),
                    ),
                  );
                });
          },
        ));
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
    List matchVideo = [];
    var homeCubit = BlocProvider.of<HomeCubit>(context);
    matchVideo = homeCubit.videos
        .where(
            (video) => video.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return searchVideoList(matchVideo, homeCubit);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List matchVideo = [];
    var homeCubit = BlocProvider.of<HomeCubit>(context);
    matchVideo = homeCubit.videos
        .where(
            (video) => video.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return searchVideoList(matchVideo, homeCubit);
  }

  Widget searchVideoList(matchVideo, homeCubit) => ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        itemCount: matchVideo.length,
        itemBuilder: (context, index) {
          var video = matchVideo[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideosPage(video: video)));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: CustomColors.backgroundColor),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    FontAwesomeIcons.video,
                    size: 18,
                    color: CustomColors.titleTextColor,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Text(
                    video.name,
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
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
      );
}
