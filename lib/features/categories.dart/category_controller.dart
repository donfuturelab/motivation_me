import 'package:motivation_me/features/paywall/subscription_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:equatable/equatable.dart';

import '../../core/local_storage/configuration_storage.dart';
import '../../models/enums/category.dart';
import '../../models/quote_category.dart';
import '../../repositories/categories_repository.dart';
import '../home/selected_category_provider.dart';

part 'category_controller.g.dart';

@riverpod
class CategoryController extends _$CategoryController {
  @override
  FutureOr<CategoryState> build() async {
    final selectedCategoryId = ConfigurationStorage.getSelectedCategoryId();
    // function to get selected category index from the list of categories
    //based on category id of stored in local storage

    final isSubscribed = await ref.watch(subscriptionProvider.future);
    List<QuoteCategory> categories =
        await ref.read(categoriesRepositoryProvider).getCategories();
    categories =
        await _getCategoriesWithSelectedIndex(selectedCategoryId, categories);

    return CategoryState(
      isSubscribed: isSubscribed,
      selectedCategory: QuoteCategory(
        id: ConfigurationStorage.getSelectedCategoryId(),
        name: ConfigurationStorage.getSelectedCategoryName(),
        type: CategoryType.free,
        isSelected: true,
      ),
      categories: categories,
      searchCategories: const [],
    );
  }

  // int _getSelectedCategoryIndex(List<QuoteCategory> categories) {
  //   return categories
  //       .indexWhere((category) => category.id == selectedCategoryId);
  // }

  Future<List<QuoteCategory>> _getCategoriesWithSelectedIndex(
      int selectedCategoryID, List<QuoteCategory> categories) async {
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].id == selectedCategoryID) {
        categories[i] = categories[i].copyWith(isSelected: true);
        break;
      }
    }
    return categories;
  }

  Future<SelectCategoryStatus> selectCategory(QuoteCategory category) async {
    final categories = state.value?.categories;
    final isSubscribed = state.value?.isSubscribed;
    final selectedCategory = state.value?.selectedCategory;
    //check if category is free type
    if (category.type == CategoryType.free || isSubscribed!) {
      if (selectedCategory!.id == category.id) {
        return SelectCategoryStatus.alreadyAdded;
      } else {
        final previousIndex =
            categories!.indexWhere((category) => category.isSelected);

        print('previousIndex: $previousIndex');

        // change isSelected to false for previous selected category
        categories[previousIndex] =
            categories[previousIndex].copyWith(isSelected: false);

        // get index of selected category
        final index =
            categories.indexWhere((element) => element.id == category.id);

        categories[index] = categories[index].copyWith(isSelected: true);
        await ConfigurationStorage.saveSelectedCategory(
            categoryId: categories[index].id,
            categoryName: categories[index].name);

        ref
            .read(selectedCategoryProvider.notifier)
            .changeSelectedCategory(category);
        return SelectCategoryStatus.success;
      }
    } else {
      print('not subscribed');
      return SelectCategoryStatus.notSubscribed;
    }
  }

  Future<SelectCategoryStatus> selectCategoryFromSearch(
      QuoteCategory category) async {
    final selectedCategory =
        state.unwrapPrevious().valueOrNull?.selectedCategory;

    final isSubscribed = await ref.read(subscriptionProvider.future);

    // check if category from _searchCategory is free type
    if (category.type == CategoryType.free || isSubscribed) {
      if (selectedCategory!.id == category.id) {
        return SelectCategoryStatus.alreadyAdded;
      } else {
        //find index of selected category in _categories list
        final int indexDefaultList = state.value!.categories
            .indexWhere((element) => element.id == category.id);
        state.value!.categories[indexDefaultList] = state
            .value!.categories[indexDefaultList]
            .copyWith(isSelected: true);
        state = AsyncData(state.value!.copyWith(
          selectedCategory: state.value!.categories[indexDefaultList]
              .copyWith(isSelected: true),
        ));
        // set new selected category to true
        // set new selected category id
        await ConfigurationStorage.saveSelectedCategory(
            categoryId: category.id, categoryName: category.name);

        ref
            .read(selectedCategoryProvider.notifier)
            .changeSelectedCategory(category);

        return SelectCategoryStatus.success;
      }
    } else {
      return SelectCategoryStatus.notSubscribed;
    }
  }

  Future<void> performSearch(String query) async {
    if (query.isNotEmpty) {
      // state = AsyncData(state.value!.copyWith(searchCategories: const []));
      final searchCategories =
          await ref.read(categoriesRepositoryProvider).searchCategories(query);

      state =
          AsyncData(state.value!.copyWith(searchCategories: searchCategories));
    } else {
      state = AsyncData(state.value!.copyWith(searchCategories: const []));
    }
  }

  void onCanceledSearch() {
    state = AsyncData(state.value!.copyWith(searchCategories: const []));
  }
}

class CategoryState extends Equatable {
  final bool isSubscribed;
  final QuoteCategory selectedCategory;
  final List<QuoteCategory> categories;
  final List<QuoteCategory> searchCategories;

  const CategoryState({
    required this.isSubscribed,
    required this.selectedCategory,
    required this.categories,
    required this.searchCategories,
  });

  //create copywith to update new quote state
  CategoryState copyWith({
    bool? isSubscribed,
    QuoteCategory? selectedCategory,
    List<QuoteCategory>? categories,
    List<QuoteCategory>? searchCategories,
  }) {
    return CategoryState(
      isSubscribed: isSubscribed ?? this.isSubscribed,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      searchCategories: searchCategories ?? this.searchCategories,
    );
  }

  @override
  List<Object?> get props =>
      [isSubscribed, selectedCategory, categories, searchCategories];
}

@riverpod
class IsSearchingCategory extends _$IsSearchingCategory {
  @override
  bool build() {
    return false;
  }

  void setIsSearching(bool value) {
    state = value;
  }
}
