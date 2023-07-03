import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_music_player/service/audio_handler.dart';

GetIt getIt = GetIt.instance;

Future<void> serviceLocator() async {
  getIt.registerSingleton<AudioHandler>(
    await initAudioService()
  );
}
