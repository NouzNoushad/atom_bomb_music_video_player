import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_music_player/model/videos.dart';

import '../../model/progress_bar.dart';
import '../../model/songs.dart';
import '../../service/music_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  List<Songs> songs = [];
  List<Videos> videos = [];
  String selectedSong = '';
  int selectedIndex = 0;

  Future<void> getFilePath() async {
    List songsList = [];
    List videoList = [];
    PermissionStatus permissionStatus = await Permission.audio.request();
    if (permissionStatus.isGranted) {
      var path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      List<FileSystemEntity> files =
          Directory(path).listSync(recursive: true, followLinks: false);
      // print(files);
      for (FileSystemEntity entity in files) {
        String path = entity.path;
        // print('//////path, $path');
        if (path.endsWith('.mp3')) songsList.add(entity);
        if (path.endsWith('.mp4')) videoList.add(entity);
      }
      // print(songs);
      print(
          '/////////***********^^^^^^^^^^^^^^^^^>>>>>>>>>>>>>>>> Video Listsssss, ${videoList.length}');
      for (var song in songsList) {
        File songPath = song;
        String songName =
            song.toString().split(Platform.pathSeparator).last.split('.').first;
        // songName.split('.').first;
        Songs arrangeSongs =
            Songs(id: songsList.indexOf(song), name: songName, path: songPath);
        // print(
        //     '//////////Songs ------>>>>>>>> Song INdexxxxxxxxxxxxxx ${songsList.indexOf(song)}');
        songs.add(arrangeSongs);
      }

      for (var video in videoList) {
        File videoPath = video;
        String videoName = video
            .toString()
            .split(Platform.pathSeparator)
            .last
            .split('.')
            .first;
        Videos arrangeVideos = Videos(
            id: videoList.indexOf(video), name: videoName, path: videoPath);
        videos.add(arrangeVideos);
      }
      print('//////////Videos ------>>>>>>>>> ${videos.length}');

      emit(GetAudioState());
    }
    // initSong();
    setFilePath();
    loadVideos();
    // return songs;
  }

  onTabChange(index) {
    selectedIndex = index;
    emit(ChangePageIndex());
  }

  //////////////   --------------------- Video ---------------------   //////////////
  // final videoController = StreamController<List<Videos>>.broadcast();
  // StreamSink<List<Videos>> get videoSink => videoController.sink;
  // Stream<List<Videos>> get videoStream => videoController.stream;

  // loadVideos() {
  //   videoSink.add(videos);
  //   emit(GetVideoState());
  // }

  final videoNotifier = ValueNotifier<List<Videos>>([]);

  loadVideos() {
    videoNotifier.value = videos;
    emit(GetVideoState());
  }

  //////////////   --------------------- Music ---------------------   //////////////

  // initSong() async {
  //   selectedSong.name != ''
  //       ? await player.setFilePath(selectedSong.path!.path)
  //       : await player.setFilePath(songs.first.path!.path);
  //   print('///////------------->>>>>>>> Duration, ${selectedSong.path}');
  //   print('///////------------->>>>>>>> Duration, ${songs.first.path!.path}');
  // }

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  AudioPlayer player = AudioPlayer();
  late AnimationController rotationController;
  double selectedValue = 10;
  String selectedSearchSong = '';

  onMusicPlay(value) {
    selectedValue = value;
    emit(SetMusicPlay());
  }

  final progressNotifier = ValueNotifier<ProgressBarState>(ProgressBarState(
    progress: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  ));
  final buttonNotifier = ValueNotifier<ButtonBarState>(ButtonBarState.paused);
  final repeatButtonNotifier = ValueNotifier<RepeatState>(RepeatState.off);
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  final audioHandler = getIt<AudioHandler>();

  nextState() {
    final next =
        (repeatButtonNotifier.value.index + 1) % RepeatState.values.length;
    repeatButtonNotifier.value = RepeatState.values[next];
  }

  setFilePath() async {
    print('/////////=============>>>>>>>>>>>playing song');
    await loadPlaylist();

    listenToChangesInPlaylist();

    listenToPlayerState();

    listenToPosition();

    listenToBufferedPosition();

    listenToTotalDuration();

    listenToChangesInSong();

    emit(GetMusicPath());
  }

  Future<void> loadPlaylist() async {
    final mediaItems = songs
        .map((song) => MediaItem(
              id: song.name,
              title: song.name,
              extras: {'file': song.path?.path},
            ))
        .toList();
    audioHandler.addQueueItems(mediaItems);
  }

  listenToChangesInPlaylist() {
    audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongTitleNotifier.value = '';
      } else {
        final newList = playlist.map((item) => item.title).toList();
        playlistNotifier.value = newList;
      }
      updateSkipButtons();
    });
  }

  updateSkipButtons() {
    final mediaItem = audioHandler.mediaItem.value;
    final playlist = audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  listenToPlayerState() async {
    audioHandler.playbackState.listen((event) {
      final isPlaying = event.playing;
      final processingState = event.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        buttonNotifier.value = ButtonBarState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonBarState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        buttonNotifier.value = ButtonBarState.playing;
      } else {
        audioHandler.seek(Duration.zero);
        rotationController.reset();
        audioHandler.pause();
      }
    });
  }

  listenToPosition() async {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        progress: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  listenToBufferedPosition() async {
    audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        progress: oldState.progress,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  listenToTotalDuration() async {
    audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        progress: oldState.progress,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  listenToChangesInSong() async {
    audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      mediaItem?.extras?['file'];
      updateSkipButtons();
    });
  }

  updateSelectedSong(songs, index) {
    audioHandler.skipToQueueItem(index);
    currentSongTitleNotifier.value = songs;
    print(
        '///////////////=================>>>>>>>>>>> selected song index:$index, current:${currentSongTitleNotifier.value} title:$songs');
    emit(GetAudioState());
  }

  onTapSearchMusic(songs) {
    selectedSearchSong = songs.name;
    updateSelectedSong(songs.name, songs.id);
    playMusic();
    emit(OnTapSearchMusic());
  }

  playMusic() {
    audioHandler.play();
    rotationController.repeat();
  }

  pauseMusic() {
    audioHandler.pause();
    rotationController.reset();
  }

  seekMusic(position) {
    audioHandler.seek(position);
  }

  previousMusic() {
    audioHandler.skipToPrevious();
  }

  nextMusic() {
    audioHandler.skipToNext();
  }

  repeatMusic() {
    nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  shuffleMusic() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  void disposeMusic() {
    audioHandler.customAction('dispose');
  }

  void stopMusic() {
    audioHandler.stop();
  }

  @override
  Future<void> close() {
    // player.dispose();
    rotationController.dispose();
    return super.close();
  }
}
