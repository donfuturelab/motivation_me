import 'package:http/http.dart' as http;
import 'dart:typed_data';

Future<Uint8List> fetchTTS(String text) async {
  final url =
      'https://translate.google.com/translate_tts?ie=UTF-8&q=${Uri.encodeComponent(text)}&tl=en&client=tw-ob';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load tts');
  }
}




// Future<Map<String, dynamic>> fetchGgTts(String text) async {
//   final apiKey = Evn.googleApiKey;
//   const url = 'https://texttospeech.googleapis.com/v1/text:synthesize';
//   final response = await http.post(Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=utf-8',
//       },
//       body: jsonEncode({
//         'input': {'text': text},
//         'voice': {
//           'languageCode': 'en-US',
//           'name': 'en-US-Standard-D',
//         }
//       }));
// }
