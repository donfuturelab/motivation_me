import 'package:motivation_me/core/local_storage/quote_theme_storage.dart';
import '../../models/enums/theme.dart';
import '/models/theme/quote_theme.dart';
import 'package:motivation_me/models/theme/selected_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constant/limitation.dart';
import '../../models/enums/add_theme_status.dart';
import '../paywall/subscription_provider.dart';

part 'selected_theme_provider.g.dart';

@riverpod
class SelectedThemes extends _$SelectedThemes {
  final _box = QuoteThemeStorage();
  final _setSelectedThemesIDs = <int>{};

  @override
  List<SelectedTheme> build() {
    final selectedThemes = _box.getThemes();
    _setSelectedThemesIDs.addAll(selectedThemes.map((e) => e.themeID));
    return selectedThemes;
  }

  Future<AddThemeStatus> addTheme(QuoteTheme theme) async {
    // 1. check if user is subscribed
    final isSubscribed = await ref.watch(subscriptionProvider.future);
    // check if user is subscribed
    if (isSubscribed) {
      if (_setSelectedThemesIDs.contains(theme.themeID)) {
        // 2. check if theme is  already added
        return AddThemeStatus.exist;
      } else {
        // 3. check if over maximum limit even user is subscribed
        if (state.length >= addedSubscribedThemeLimit) {
          return AddThemeStatus.overMaxLimit;
        }

        // 4. add theme to selected themes
        state = [SelectedTheme.fromQuoteTheme(theme), ...state];
        _setSelectedThemesIDs.add(theme.themeID);
        await _box.addTheme(SelectedTheme.fromQuoteTheme(theme));
        // theme.isSelected.value = true;

        return AddThemeStatus.success;
      }
    } else {
      // 5. check if theme is free
      if (theme.themeType == ThemeType.free) {
        // 6. check if theme is already added
        if (_setSelectedThemesIDs.contains(theme.themeID)) {
          return AddThemeStatus.exist;
        } else if (state.length >= addedFreeThemeLimit) {
          return AddThemeStatus.overLimitForFree;
        } else {
          // 7. add theme to selected themes

          _setSelectedThemesIDs.add(theme.themeID);
          await _box.addTheme(SelectedTheme.fromQuoteTheme(theme));
          // 4. add theme to selected themes
          state = [SelectedTheme.fromQuoteTheme(theme), ...state];
          return AddThemeStatus.success;
        }
      } else {
        return AddThemeStatus.notFree;
      }
    }
  }

  void removeTheme(int themeIndex) async {
    final theme = state[themeIndex];
    _setSelectedThemesIDs.remove(theme.themeID);
    List<SelectedTheme> newState = List<SelectedTheme>.from(state);
    newState.removeAt(themeIndex);
    state = newState;
    await _box.updateNewThemeList(state.toList());
  }

  Future<Set<int>> getSelectedThemesIDs() async {
    return _setSelectedThemesIDs;
  }
}
