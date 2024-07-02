// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_player.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioPlayerHash() => r'0f9f941057440935279fb5ed67e9d88ff0d6549a';

/// See also [audioPlayer].
@ProviderFor(audioPlayer)
final audioPlayerProvider = AutoDisposeProvider<AudioPlayer>.internal(
  audioPlayer,
  name: r'audioPlayerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$audioPlayerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AudioPlayerRef = AutoDisposeProviderRef<AudioPlayer>;
String _$fetchAndPlayTTSHash() => r'25042dd23bd956b4f7d8152fc69f033f15aa11ff';

/// See also [FetchAndPlayTTS].
@ProviderFor(FetchAndPlayTTS)
final fetchAndPlayTTSProvider =
    AutoDisposeAsyncNotifierProvider<FetchAndPlayTTS, void>.internal(
  FetchAndPlayTTS.new,
  name: r'fetchAndPlayTTSProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchAndPlayTTSHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FetchAndPlayTTS = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
