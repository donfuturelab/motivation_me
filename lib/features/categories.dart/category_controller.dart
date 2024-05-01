import 'package:motivation_me/features/paywall/subscription_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/local_storage/configuration_storage.dart';
import '../../models/enums/category.dart';
import '../../models/quote_category.dart';
import '../../repositories/categories_repository.dart';
import '../home/selected_category_provider.dart';
import '../paywall/subscription_controller.dart';

part 'category_controller.g.dart';

// class CategoryController extends GetxController {
//   final _homeController = Get.find<HomeController>();
//   final _subscriptionController = Get.find<SubscriptionController>();

//   final CategoriesRepository categoryRepo;
//   CategoryController({required this.categoryRepo});

//   // final RxInt selectedDefaultIndex = (-1).obs;
//   // int get selectedDefaultIndexValue => selectedDefaultIndex.value;

//   // final RxInt _selectedCategoryIndex = (-1).obs;
//   // int get selectedCategoryIndexValue => _selectedCategoryIndex.value;

//   final RxBool _isLoading = true.obs;
//   bool get isLoading => _isLoading.value;

//   final List<QuoteCategory> _categories = [];
//   List<QuoteCategory> get categories => _categories;

//   final List<QuoteCategory> _searchCategories = [];
//   List<QuoteCategory> get searchCategories => _searchCategories;

//   final RxInt _selectedCategoryId = (-1).obs;
//   final RxInt _selectedCategoryIndex = (-1).obs;
//   int get selectedCategoryIndex => _selectedCategoryIndex.value;
//   int get selectedCategoryId => _selectedCategoryId.value;

//   final scrollController = ScrollController();
//   final RxBool _showTitle = false.obs;
//   bool get showTitle => _showTitle.value;

//   final TextEditingController searchTextController = TextEditingController();

//   final FocusNode searchFocusNode = FocusNode();

//   final RxBool _isSearching = false.obs;
//   bool get isSearching => _isSearching.value;

//   final RxString _searchText = ''.obs;
//   String get searchText => _searchText.value;

//   final RxBool _isShowSearchResult = false.obs;
//   bool get isShowSearchResult => _isShowSearchResult.value;

//   final RxBool _isLoadingSearch = false.obs;
//   bool get isLoadingSearch => _isLoadingSearch.value;

//   @override
//   void onInit() async {
//     super.onInit();
//     _isLoading.value = true;
//     _selectedCategoryId.value = ConfigurationStorage.getSelectedCategoryId();
//     await _getCategoriesWithSelectedIndex(_selectedCategoryId.value);
//     // _selectedCategoryIndex.value = getSelectedCategoryIndex();
//     _isLoading.value = false;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       scrollController.addListener(_scrollListener);
//     });

//     // use focus node to listen to search text field focus
//     searchFocusNode.addListener(() {
//       _isSearching.value = searchFocusNode.hasFocus;
//     });

//     //add listener to search text field
//     searchTextController.addListener(() {
//       _searchText.value = searchTextController.text;
//     });

//     //use debounce by getx to listen to search text field changes
//     debounce(_searchText, (callback) => performSearch(),
//         time: const Duration(milliseconds: 300));
//   }

//   @override
//   void onClose() {
//     searchTextController.dispose();
//     searchFocusNode.dispose();
//     scrollController.removeListener(_scrollListener);
//     scrollController.dispose();
//     super.onClose();
//   }

//   void _scrollListener() {
//     if (scrollController.offset > 80 && !_showTitle.value) {
//       _showTitle.value = true;
//     } else if (scrollController.offset <= 80 && _showTitle.value) {
//       _showTitle.value = false;
//     }
//   }

//   // function to get selected category index from the list of categories
//   //based on category id of stored in local storage
//   int getSelectedCategoryIndex() {
//     final selectedCategoryId = ConfigurationStorage.getSelectedCategoryId();
//     return _categories
//         .indexWhere((category) => category.id == selectedCategoryId);
//   }

//   Future<void> _getCategoriesWithSelectedIndex(int selectedCategoryID) async {
//     _categories.assignAll(await categoryRepo.getCategories());
//     for (int i = 0; i < _categories.length; i++) {
//       if (_categories[i].id == selectedCategoryID) {
//         _selectedCategoryIndex.value = i;
//         categories[i] = categories[i].copyWith(isSelected: true);
//         break;
//       }
//     }
//   }

//   Future<SelectCategoryStatus> selectCategory(int index) async {
//     //check if category is free type
//     if (_categories[index].type == CategoryType.free ||
//         _subscriptionController.isSubscribed) {
//       if (_selectedCategoryIndex.value == index) {
//         return SelectCategoryStatus.alreadyAdded;
//       } else {
//         _categories[_selectedCategoryIndex.value] =
//             _categories[_selectedCategoryIndex.value]
//                 .copyWith(isSelected: false);
//         _categories[index] = _categories[index].copyWith(isSelected: true);
//         _selectedCategoryIndex.value = index;
//         _selectedCategoryId.value = _categories[index].id;
//         await ConfigurationStorage.saveSelectedCategory(
//             categoryId: _categories[index].id,
//             categoryName: _categories[index].name);
//         await _homeController.updateNewQuotesByCategory(
//             categoryId: _categories[index].id,
//             categoryName: _categories[index].name);
//         return SelectCategoryStatus.success;
//       }
//     } else {
//       return SelectCategoryStatus.notSubscribed;
//     }
//   }

//   Future<void> performSearch() async {
//     if (_searchText.value.isNotEmpty) {
//       _isShowSearchResult.value = true;
//       _isLoadingSearch.value = true;
//       _searchCategories
//           .assignAll(await categoryRepo.searchCategories(_searchText.value));
//       _isLoadingSearch.value = false;
//     } else {
//       _isShowSearchResult.value = false;
//       // _searchCategories.assignAll(_categories);
//     }
//   }

//   void onCanceledSearch() {
//     _isShowSearchResult.value = false;
//     _isSearching.value = false;
//     searchTextController.clear();
//     searchFocusNode.unfocus();
//     _searchCategories.clear();
//   }

//   void clearSearchState() {
//     _isShowSearchResult.value = false;
//     _isSearching.value = false;
//     searchTextController.clear();
//     searchFocusNode.unfocus();
//     _searchCategories.clear();
//   }

//   // select a category from search result by using id
//   Future<SelectCategoryStatus> selectCategoryFromSearch(int index) async {
//     // check if category from _searchCategory is free type
//     if (_searchCategories[index].type == CategoryType.free ||
//         _subscriptionController.isSubscribed) {
//       if (_selectedCategoryIndex.value == index) {
//         return SelectCategoryStatus.alreadyAdded;
//       } else {
//         _searchCategories[_selectedCategoryIndex.value] =
//             _searchCategories[_selectedCategoryIndex.value].copyWith(
//                 isSelected: false); // set old selected category to false

//         //find index of selected category in _categories list
//         final int indexDefaultList = _categories.indexWhere(
//             (category) => category.id == _searchCategories[index].id);
//         _categories[indexDefaultList] = _categories[indexDefaultList]
//             .copyWith(isSelected: true); // set new selected category to true
//         _selectedCategoryIndex.value =
//             indexDefaultList; // set new selected category index
//         _selectedCategoryId.value =
//             _categories[indexDefaultList].id; // set new selected category id
//         await ConfigurationStorage.saveSelectedCategory(
//             categoryId: _categories[indexDefaultList].id,
//             categoryName: _categories[indexDefaultList].name);
//         await _homeController.updateNewQuotesByCategory(
//             categoryId: _categories[indexDefaultList].id,
//             categoryName: _categories[indexDefaultList].name);
//         return SelectCategoryStatus.success;
//       }
//     } else {
//       return SelectCategoryStatus.notSubscribed;
//     }
//   }
// }

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
