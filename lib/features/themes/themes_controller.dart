import 'package:get/get.dart';

import '../../core/constant/limitation.dart';
import '../../core/local_storage/quote_theme_storage.dart';
import '../../models/enums/add_theme_status.dart';
import '../../models/enums/theme.dart';
import '../../models/theme/quote_theme.dart';
import '../../repositories/themes_repository.dart';
import '../home/home_controller.dart';
import '../my_quotes/my_quote_controller.dart';
import '../paywall/subscription_controller.dart';

class ThemesController extends GetxController {
  final _subscriptionController = Get.find<SubscriptionController>();

  final ThemesRepository themesRepo;

  ThemesController({required this.themesRepo});

  final _box = QuoteThemeStorage();

  final _homeController = Get.find<HomeController>();
  final _myQuotesController = Get.find<MyQuotesController>();

  final RxBool _isEditingUserTheme = false.obs;
  bool get isEditingUserTheme => _isEditingUserTheme.value;

  final RxList<QuoteTheme> _selectedThemes = <QuoteTheme>[].obs;
  List<QuoteTheme> get selectedThemes => _selectedThemes.toList();

  final Set<int> _setSelectedThemesIDs = {};

  final List<QuoteTheme> _freeThemes = <QuoteTheme>[];
  List<QuoteTheme> get freeThemes => _freeThemes;

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  final List<ThemeCategory> themeCategorySections = <ThemeCategory>[
    ThemeCategory.calm,
    ThemeCategory.motivation,
    ThemeCategory.tropical,
    ThemeCategory.dimensions,
  ];

  final Map<String, List<QuoteTheme>> themeByCategories = {};

  @override
  void onInit() async {
    await _getAllThemes();
    super.onInit();
  }

  Future<void> _getAllThemes() async {
    _isLoading.value = true;
    final List<QuoteTheme> themes = _box.getThemes();

    //add themeID to set of selected ThemeID to check if theme is already added
    _setSelectedThemesIDs.addAll(themes.map((e) => e.themeID));

    _selectedThemes.addAll(themes);
    _freeThemes.addAll(await themesRepo.getFreeThemes(
        isSelectedThemeIDs: _setSelectedThemesIDs));
    themeByCategories.addAll(
        await getThemesByCategories(isSelectedThemeIDs: _setSelectedThemesIDs));
    _isLoading.value = false;
  }

  Future<Map<String, List<QuoteTheme>>> getThemesByCategories(
      {required isSelectedThemeIDs}) async {
    final Map<String, List<QuoteTheme>> themesByCategory = {};
    for (final category in themeCategorySections) {
      themesByCategory[themeCategoryToString(category)] =
          await themesRepo.getThemesByCategory(
              themeCategory: category, isSelectedThemeIDs: isSelectedThemeIDs);
    }
    return themesByCategory;
  }

  void toggleEditTheme() {
    _isEditingUserTheme.value = !_isEditingUserTheme.value;
  }

  Future<AddThemeStatus> addTheme(QuoteTheme theme) async {
    // 1. check if user is subscribed
    bool isSubscribed = _subscriptionController.isSubscribed;

    // check if user is subscribed
    if (isSubscribed) {
      // 2. check if theme is already added
      if (_setSelectedThemesIDs.contains(theme.themeID)) {
        return AddThemeStatus.exist;
      } else {
        // 3. check if over maximum limit even user is subscribed
        if (_selectedThemes.length >= addedSubscribedThemeLimit) {
          return AddThemeStatus.overMaxLimit;
        }

        // 4. add theme to selected themes
        _selectedThemes.insert(0, theme);
        _setSelectedThemesIDs.add(theme.themeID);
        await _box.addTheme(theme);
        theme.isSelected.value = true;
        _homeController.updateQuoteThemes(
            _selectedThemes.toList()); //update theme in home screen
        _myQuotesController.updateQuoteThemes(
            _selectedThemes.toList()); //update theme in my quotes screen
        return AddThemeStatus.success;
      }
    } else {
      // 5. check if theme is free
      if (theme.themeType == ThemeType.free) {
        // 6. check if theme is already added
        if (_setSelectedThemesIDs.contains(theme.themeID)) {
          return AddThemeStatus.exist;
        } else if (_selectedThemes.length >= addedFreeThemeLimit) {
          return AddThemeStatus.overLimitForFree;
        } else {
          // 7. add theme to selected themes
          _selectedThemes.insert(0, theme);
          _setSelectedThemesIDs.add(theme.themeID);
          await _box.addTheme(theme);
          theme.isSelected.value = true;
          _homeController.updateQuoteThemes(
              _selectedThemes.toList()); //update theme in home screen
          _myQuotesController.updateQuoteThemes(
              _selectedThemes.toList()); //update theme in my quotes screen
          return AddThemeStatus.success;
        }
      } else {
        return AddThemeStatus.notFree;
      }
    }
  }

  Future<void> removeTheme(QuoteTheme theme) async {
    //loop through selected themes and remove theme
    _selectedThemes.removeWhere((element) => element.themeID == theme.themeID);
    _setSelectedThemesIDs.remove(theme.themeID);
    await _box.updateNewThemeList(_selectedThemes.toList());
    _homeController.updateQuoteThemes(
        _selectedThemes.toList()); //update theme in home screen
    _myQuotesController.updateQuoteThemes(
        _selectedThemes.toList()); //update theme in my quotes screen
  }
}
