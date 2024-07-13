// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moode_asking_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$moodAskingHash() => r'9ec489255912bd64fe63a805a068fd2d5334c29d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$MoodAsking
    extends BuildlessAutoDisposeAsyncNotifier<List<DefaultQuote>> {
  late final MoodModal mood;

  FutureOr<List<DefaultQuote>> build(
    MoodModal mood,
  );
}

/// See also [MoodAsking].
@ProviderFor(MoodAsking)
const moodAskingProvider = MoodAskingFamily();

/// See also [MoodAsking].
class MoodAskingFamily extends Family<AsyncValue<List<DefaultQuote>>> {
  /// See also [MoodAsking].
  const MoodAskingFamily();

  /// See also [MoodAsking].
  MoodAskingProvider call(
    MoodModal mood,
  ) {
    return MoodAskingProvider(
      mood,
    );
  }

  @override
  MoodAskingProvider getProviderOverride(
    covariant MoodAskingProvider provider,
  ) {
    return call(
      provider.mood,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'moodAskingProvider';
}

/// See also [MoodAsking].
class MoodAskingProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MoodAsking, List<DefaultQuote>> {
  /// See also [MoodAsking].
  MoodAskingProvider(
    MoodModal mood,
  ) : this._internal(
          () => MoodAsking()..mood = mood,
          from: moodAskingProvider,
          name: r'moodAskingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$moodAskingHash,
          dependencies: MoodAskingFamily._dependencies,
          allTransitiveDependencies:
              MoodAskingFamily._allTransitiveDependencies,
          mood: mood,
        );

  MoodAskingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mood,
  }) : super.internal();

  final MoodModal mood;

  @override
  FutureOr<List<DefaultQuote>> runNotifierBuild(
    covariant MoodAsking notifier,
  ) {
    return notifier.build(
      mood,
    );
  }

  @override
  Override overrideWith(MoodAsking Function() create) {
    return ProviderOverride(
      origin: this,
      override: MoodAskingProvider._internal(
        () => create()..mood = mood,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mood: mood,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MoodAsking, List<DefaultQuote>>
      createElement() {
    return _MoodAskingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MoodAskingProvider && other.mood == mood;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mood.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MoodAskingRef on AutoDisposeAsyncNotifierProviderRef<List<DefaultQuote>> {
  /// The parameter `mood` of this provider.
  MoodModal get mood;
}

class _MoodAskingProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MoodAsking,
        List<DefaultQuote>> with MoodAskingRef {
  _MoodAskingProviderElement(super.provider);

  @override
  MoodModal get mood => (origin as MoodAskingProvider).mood;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
