class ProgressBarState {
  final Duration? progress;
  final Duration? total;
  final Duration? buffered;

  ProgressBarState({
    this.progress,
    this.buffered,
    this.total,
  });
}

enum ButtonBarState { loading, paused, playing }

enum RepeatState {
  off,
  repeatSong,
  repeatPlaylist,
}