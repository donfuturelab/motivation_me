// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeControllerHash() => r'93bc99104a7894ce869565c81579bfae69cb9430';

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

abstract class _$HomeController
    extends BuildlessAutoDisposeAsyncNotifier<List<DefaultQuote>> {
  late final int? quoteId;

  FutureOr<List<DefaultQuote>> build({
    int? quoteId,
  });
}

/// See also [HomeController].
@ProviderFor(HomeController)
const homeControllerProvider = HomeControllerFamily();

/// See also [HomeController].
class HomeControllerFamily extends Family<AsyncValue<List<DefaultQuote>>> {
  /// See also [HomeController].
  const HomeControllerFamily();

  /// See also [HomeController].
  HomeControllerProvider call({
    int? quoteId,
  }) {
    return HomeControllerProvider(
      quoteId: quoteId,
    );
  }

  @override
  HomeControllerProvider getProviderOverride(
    covariant HomeControllerProvider provider,
  ) {
    return call(
      quoteId: provider.quoteId,
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
  String? get name => r'homeControllerProvider';
}

/// See also [HomeController].
class HomeControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    HomeController, List<DefaultQuote>> {
  /// See also [HomeController].
  HomeControllerProvider({
    int? quoteId,
  }) : this._internal(
          () => HomeController()..quoteId = quoteId,
          from: homeControllerProvider,
          name: r'homeControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$homeControllerHash,
          dependencies: HomeControllerFamily._dependencies,
          allTransitiveDependencies:
              HomeControllerFamily._allTransitiveDependencies,
          quoteId: quoteId,
        );

  HomeControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.quoteId,
  }) : super.internal();

  final int? quoteId;

  @override
  FutureOr<List<DefaultQuote>> runNotifierBuild(
    covariant HomeController notifier,
  ) {
    return notifier.build(
      quoteId: quoteId,
    );
  }

  @override
  Override overrideWith(HomeController Function() create) {
    return ProviderOverride(
      origin: this,
      override: HomeControllerProvider._internal(
        () => create()..quoteId = quoteId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        quoteId: quoteId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<HomeController, List<DefaultQuote>>
      createElement() {
    return _HomeControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeControllerProvider && other.quoteId == quoteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quoteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin HomeControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<DefaultQuote>> {
  /// The parameter `quoteId` of this provider.
  int? get quoteId;
}

class _HomeControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<HomeController,
        List<DefaultQuote>> with HomeControllerRef {
  _HomeControllerProviderElement(super.provider);

  @override
  int? get quoteId => (origin as HomeControllerProvider).quoteId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
