// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_API_KEY', obfuscate: true)
  static String googleApiKey = _Env.googleApiKey;
}
