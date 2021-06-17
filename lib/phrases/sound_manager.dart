import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

class SoundManager {
  static final player = FlutterSoundPlayer();
  static final recorder = FlutterSoundRecorder();

  static bool _initialized = false;
  static bool get initialized => _initialized;

  static Future<void> init() async {
    if (!initialized) {
      _initialized = true;
      await Permission.microphone.request();
      await recorder.openAudioSession();
      await player.openAudioSession();
    }
  }

  static Future<void> stop() async {
    await player.stopPlayer();
    await recorder.stopRecorder();
  }

  static Future<void> dispose() async {
    await stop();
    await player.closeAudioSession();
    await recorder.closeAudioSession();
  }

  static Future<bool> setRecording(
    bool? recording, {
    required String file,
  }) async {
    recording ??= !recorder.isRecording;
    if (recording) {
      await recorder.startRecorder(toFile: file);
    } else {
      await recorder.stopRecorder();
    }
    await Vibration.vibrate(duration: 50);
    return recording;
  }

  static Future<bool> setPlaying(
    bool? playing, {
    required String file,
    void Function()? whenFinished,
  }) async {
    playing ??= !player.isPlaying;
    if (playing) {
      await player.startPlayer(
        fromURI: file,
        whenFinished: whenFinished,
      );
    } else {
      await player.stopPlayer();
    }
    return playing;
  }
}
