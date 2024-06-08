import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tts_service.g.dart';

const voiceList = [
  'Fred',
  'Kathy',
  'Junior',
];

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  final ValueNotifier<int> currentWordStart = ValueNotifier(0);
  final ValueNotifier<int> currentWordEnd = ValueNotifier(0);

  TtsService() {
    initTts();
  }

  void initTts() async {
    _flutterTts.setProgressHandler((text, start, end, word) {
      currentWordStart.value = start;
      currentWordEnd.value = end;
    });

    await _flutterTts.setVoice({'locale': 'en-US', 'name': 'Fred'});
    await _flutterTts.setSpeechRate(0.5);
  }

  void resetCurrentWord() {
    currentWordStart.value = 0;
    currentWordEnd.value = 0;
  }

  Future<void> speak(String text) async {
    _flutterTts.speak(text);
  }

  Future<void> stop() async {
    _flutterTts.stop();
  }
}

@riverpod
TtsService ttsService(TtsServiceRef ref) {
  return TtsService();
}

// class VoiceQuote extends HookConsumerWidget {
//   VoiceQuote({super.key});
//   final FlutterTts _flutterTts = FlutterTts();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _currentWordStart = useState(0);
//     final _currentWordEnd = useState(0);

//     void setVoice(Map<String, String> voice) {
//       _flutterTts.setVoice(voice);
//     }

//     void initTts() async {
//       _flutterTts.setProgressHandler((text, start, end, word) {
//         _currentWordStart.value = start;
//         _currentWordEnd.value = end;
//         print("Progress: $start, $end, $word");
//       });

//       _flutterTts.setVoice({'locale': 'en-US', 'name': 'Junior'});
//       // _flutterTts.getVoices.then((dataVoices) {
//       //   //loop through all voices and select the one that contains "en"

//       //   try {
//       //     var voicesList = List<Map<String, String>>.from(
//       //         dataVoices.map((e) => e.cast<String, String>()));
//       //     voicesList = voicesList
//       //         .where((voice) => voice["locale"]!.contains("en-US"))
//       //         .toList();
//       //     for (var voice in voicesList) {
//       //       print(voice);
//       //     }
//       //   } catch (e) {
//       //     print(e);
//       //   }
//       // });

//       // _flutterTts.setLanguage('en-US');
//       _flutterTts.setSpeechRate(0.5);
//       // _flutterTts.setVolume(1.0);
//       // _flutterTts.setPitch(1.0);
//     }

//     useEffect(() {
//       initTts();
//       return null;
//     }, []);

//     Widget buildUI() {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             RichText(
//               textAlign: TextAlign.center,
//               text: TextSpan(
//                 style: const TextStyle(
//                   fontSize: 20.0,
//                   color: Colors.black,
//                 ),
//                 children: <TextSpan>[
//                   TextSpan(
//                     text: TTS_INPUT.substring(0, _currentWordStart.value),
//                   ),
//                   if (_currentWordStart.value < _currentWordEnd.value)
//                     TextSpan(
//                       text: TTS_INPUT.substring(
//                           _currentWordStart.value, _currentWordEnd.value),
//                       style: const TextStyle(
//                         backgroundColor: Colors.yellow,
//                       ),
//                     ),
//                   if (_currentWordEnd.value < TTS_INPUT.length)
//                     TextSpan(
//                       text: TTS_INPUT.substring(_currentWordEnd.value),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Scaffold(
//       body: buildUI(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _flutterTts.speak(TTS_INPUT);
//         },
//         child: const Icon(Icons.volume_up),
//       ),
//     );
//   }
// }
