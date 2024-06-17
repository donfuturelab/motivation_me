import 'dart:typed_data';

import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../tts_service/fetch_gg_tts.dart';

part 'audio_player.g.dart';

@riverpod
AudioPlayer audioPlayer(AudioPlayerRef ref) {
  print('audio player init');
  return AudioPlayer();
}

@riverpod
class FetchAndPlayTTS extends _$FetchAndPlayTTS {
  @override
  FutureOr<void> build() async {
    return null;
  }

  Future<void> playSpeak(AudioPlayer player, String text) async {
    // final player = ref.watch(audioPlayerProvider);
    // final player = AudioPlayer();
    final audioBytes = await fetchTTS(text);
    await player.setAudioSource(StreamCustomSource(audioBytes));
    await player.play();
    print('success play');
  }

  // function to stop the audio
  Future<void> stopSpeak(AudioPlayer player) async {
    // await ref.watch(audioPlayerProvider).stop();
    await player.stop();
    print('stop audio');
  }
}

class StreamCustomSource extends StreamAudioSource {
  final Uint8List audioBytes;
  StreamCustomSource(this.audioBytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    return StreamAudioResponse(
        sourceLength: audioBytes.length,
        contentLength: audioBytes.length - 0,
        offset: 0,
        stream: Stream.value(audioBytes.sublist(0, audioBytes.length)),
        contentType: 'audio/mpeg');
  }
}
