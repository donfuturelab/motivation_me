import 'package:equatable/equatable.dart';
import 'package:motivation_me/features/paywall/subscription_provider.dart';
import 'package:motivation_me/features/themes/selected_theme_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/enums/theme.dart';
import '../../models/theme/quote_theme.dart';
import '../../models/theme/selected_theme.dart';
import '../../repositories/themes_repository.dart';

part 'themes_controller.g.dart';

@riverpod
class ThemesController extends _$ThemesController {
  @override
  Future<ThemesState> build() async {
    final setSelectedThemesIDs =
        await ref.watch(selectedThemesProvider.notifier).getSelectedThemesIDs();
    // final selectedThemes = ref.watch(selectedThemesProvider);

    final isSubscribed = await ref.watch(subscriptionProvider.future);

    final freeThemes =
        await getFreeThemes(isSelectedThemeIDs: setSelectedThemesIDs);

    final themesByCategories =
        await getThemesByCategories(isSelectedThemeIDs: setSelectedThemesIDs);
    return ThemesState(
      freeThemes: freeThemes,
      categoryThemes: themesByCategories,
      // selectedThemes: selectedThemes,
      isSubscribed: isSubscribed,
    );
  }

  // void onInit() async {
  //   await _getAllThemes();
  //   super.onInit();
  // }

  // Future<void> _getAllThemes() async {
  //   _selectedThemes.addAll(themes);
  //   _freeThemes.addAll(await themesRepo.getFreeThemes(
  //       isSelectedThemeIDs: _setSelectedThemesIDs));
  //   themeByCategories.addAll(
  //       await getThemesByCategories(isSelectedThemeIDs: _setSelectedThemesIDs));
  //   _isLoading.value = false;
  // }

  Future<List<QuoteTheme>> getFreeThemes({required isSelectedThemeIDs}) async {
    final themesRepo = ref.read(themesRepositoryProvider);
    return await themesRepo.getFreeThemes(
        isSelectedThemeIDs: isSelectedThemeIDs);
  }

  Future<Map<String, List<QuoteTheme>>> getThemesByCategories(
      {required isSelectedThemeIDs}) async {
    final themesRepo = ref.read(themesRepositoryProvider);
    final Map<String, List<QuoteTheme>> themesByCategory = {};
    for (final category in themeCategorySections) {
      themesByCategory[themeCategoryToString(category)] =
          await themesRepo.getThemesByCategory(
              themeCategory: category, isSelectedThemeIDs: isSelectedThemeIDs);
    }
    return themesByCategory;
  }
}

class ThemesState extends Equatable {
  final List<QuoteTheme> freeThemes;
  final Map<String, List<QuoteTheme>> categoryThemes;
  final bool isSubscribed;

  const ThemesState({
    required this.freeThemes,
    required this.categoryThemes,
    required this.isSubscribed,
  });

  //create copyWith function
  ThemesState copyWith({
    List<QuoteTheme>? freeThemes,
    Map<String, List<QuoteTheme>>? categoryThemes,
    List<SelectedTheme>? selectedThemes,
    bool? isSubscribed,
  }) {
    return ThemesState(
      freeThemes: freeThemes ?? this.freeThemes,
      categoryThemes: categoryThemes ?? this.categoryThemes,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  @override
  List<Object> get props => [freeThemes, categoryThemes, isSubscribed];
}

final List<ThemeCategory> themeCategorySections = <ThemeCategory>[
  ThemeCategory.calm,
  ThemeCategory.motivation,
  ThemeCategory.tropical,
  ThemeCategory.dimensions,
];
