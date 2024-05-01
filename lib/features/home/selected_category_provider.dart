import 'package:riverpod_annotation/riverpod_annotation.dart';

import '/core/local_storage/configuration_storage.dart';
import '/models/quote_category.dart';

import '../../models/enums/category.dart';

part 'selected_category_provider.g.dart';

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  QuoteCategory build() {
    return QuoteCategory(
      id: ConfigurationStorage.getSelectedCategoryId(),
      name: ConfigurationStorage.getSelectedCategoryName(),
      type: CategoryType.free,
      isSelected: true,
    );
  }

  void changeSelectedCategory(QuoteCategory category) {
    state = category;
  }
}
