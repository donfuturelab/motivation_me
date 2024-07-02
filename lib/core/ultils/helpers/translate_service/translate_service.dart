import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String?> translateService(
    {required String tsLanguage, required String text}) async {
  final url =
      'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=$tsLanguage&dt=t&q=${Uri.encodeComponent(text)}';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonRespone = jsonDecode(response.body);
    return jsonRespone[0][0][0];
  } else {
    throw Exception('Failed to load translate service');
  }
}
