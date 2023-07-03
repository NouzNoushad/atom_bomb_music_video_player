part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetAudioState extends HomeState {}

class SetMusicPlay extends HomeState{}

class GetMusicPath extends HomeState{}

class ChangePageIndex extends HomeState{}

class GetVideoState extends HomeState{}

class OnTapSearchMusic extends HomeState{}
