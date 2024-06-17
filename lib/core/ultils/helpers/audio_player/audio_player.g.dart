// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_player.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioPlayerHash() => r'c9b8c659bf54fb74ed9b9dbe8b49a63db625445e';

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
String _$fetchAndPlayTTSHash() => r'a00d44183eb8572dab4987c975a39bf8445474fc';

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
