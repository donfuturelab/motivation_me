import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/local_storage/configuration_storage.dart';
import '../../models/enums/category.dart';
import '../../models/quote_category.dart';
import '../../repositories/categories_repository.dart';
import '../home/home_controller.dart';
import '../paywall/subscription_controller.dart';

class CategoryController extends GetxController {
  final _homeController = Get.find<HomeController>();
  final _subscriptionController = Get.find<SubscriptionController>();

  final CategoriesRepository categoryRepo;
  CategoryController({required this.categoryRepo});

  // final RxInt selectedDefaultIndex = (-1).obs;
  // int get selectedDefaultIndexValue => selectedDefaultIndex.value;

  // final RxInt _selectedCategoryIndex = (-1).obs;
  // int get selectedCategoryIndexValue => _selectedCategoryIndex.value;

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  final List<QuoteCategory> _categories = [];
  List<QuoteCategory> get categories => _categories;

  final List<QuoteCategory> _searchCategories = [];
  List<QuoteCategory> get searchCategories => _searchCategories;

  final RxInt _selectedCategoryId = (-1).obs;
  final RxInt _selectedCategoryIndex = (-1).obs;
  int get selectedCategoryIndex => _selectedCategoryIndex.value;
  int get selectedCategoryId => _selectedCategoryId.value;

  final scrollController = ScrollController();
  final RxBool _showTitle = false.obs;
  bool get showTitle => _showTitle.value;

  final TextEditingController searchTextController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  final RxBool _isSearching = false.obs;
  bool get isSearching => _isSearching.value;

  final RxString _searchText = ''.obs;
  String get searchText => _searchText.value;

  final RxBool _isShowSearchResult = false.obs;
  bool get isShowSearchResult => _isShowSearchResult.value;

  final RxBool _isLoadingSearch = false.obs;
  bool get isLoadingSearch => _isLoadingSearch.value;

  @override
  void onInit() async {
    super.onInit();
    _isLoading.value = true;
    _selectedCategoryId.value = ConfigurationStorage.getSelectedCategoryId();
    await _getCategoriesWithSelectedIndex(_selectedCategoryId.value);
    // _selectedCategoryIndex.value = getSelectedCategoryIndex();
    _isLoading.value = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(_scrollListener);
    });

    // use focus node to listen to search text field focus
    searchFocusNode.addListener(() {
      _isSearching.value = searchFocusNode.hasFocus;
    });

    //add listener to search text field
    searchTextController.addListener(() {
      _searchText.value = searchTextController.text;
    });

    //use debounce by getx to listen to search text field changes
    debounce(_searchText, (callback) => performSearch(),
        time: const Duration(milliseconds: 300));
  }

  @override
  void onClose() {
    searchTextController.dispose();
    searchFocusNode.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.offset > 80 && !_showTitle.value) {
      _showTitle.value = true;
    } else if (scrollController.offset <= 80 && _showTitle.value) {
      _showTitle.value = false;
    }
  }

  // function to get selected category index from the list of categories
  //based on category id of stored in local storage
  int getSelectedCategoryIndex() {
    final selectedCategoryId = ConfigurationStorage.getSelectedCategoryId();
    return _categories
        .indexWhere((category) => category.id == selectedCategoryId);
  }

  Future<void> _getCategoriesWithSelectedIndex(int selectedCategoryID) async {
    _categories.assignAll(await categoryRepo.getCategories());
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i].id == selectedCategoryID) {
        _selectedCategoryIndex.value = i;
        categories[i] = categories[i].copyWith(isSelected: true);
        break;
      }
    }
  }

  Future<SelectCategoryStatus> selectCategory(int index) async {
    //check if category is free type
    if (_categories[index].type == CategoryType.free ||
        _subscriptionController.isSubscribed) {
      if (_selectedCategoryIndex.value == index) {
        return SelectCategoryStatus.alreadyAdded;
      } else {
        _categories[_selectedCategoryIndex.value] =
            _categories[_selectedCategoryIndex.value]
                .copyWith(isSelected: false);
        _categories[index] = _categories[index].copyWith(isSelected: true);
        _selectedCategoryIndex.value = index;
        _selectedCategoryId.value = _categories[index].id;
        await ConfigurationStorage.saveSelectedCategory(
            categoryId: _categories[index].id,
            categoryName: _categories[index].name);
        await _homeController.updateNewQuotesByCategory(
            categoryId: _categories[index].id,
            categoryName: _categories[index].name);
        return SelectCategoryStatus.success;
      }
    } else {
      return SelectCategoryStatus.notSubscribed;
    }
  }

  Future<void> performSearch() async {
    if (_searchText.value.isNotEmpty) {
      _isShowSearchResult.value = true;
      _isLoadingSearch.value = true;
      _searchCategories
          .assignAll(await categoryRepo.searchCategories(_searchText.value));
      _isLoadingSearch.value = false;
    } else {
      _isShowSearchResult.value = false;
      // _searchCategories.assignAll(_categories);
    }
  }

  void onCanceledSearch() {
    _isShowSearchResult.value = false;
    _isSearching.value = false;
    searchTextController.clear();
    searchFocusNode.unfocus();
    _searchCategories.clear();
  }

  void clearSearchState() {
    _isShowSearchResult.value = false;
    _isSearching.value = false;
    searchTextController.clear();
    searchFocusNode.unfocus();
    _searchCategories.clear();
  }

  // select a category from search result by using id
  Future<SelectCategoryStatus> selectCategoryFromSearch(int index) async {
    // check if category from _searchCategory is free type
    if (_searchCategories[index].type == CategoryType.free ||
        _subscriptionController.isSubscribed) {
      if (_selectedCategoryIndex.value == index) {
        return SelectCategoryStatus.alreadyAdded;
      } else {
        _searchCategories[_selectedCategoryIndex.value] =
            _searchCategories[_selectedCategoryIndex.value].copyWith(
                isSelected: false); // set old selected category to false

        //find index of selected category in _categories list
        final int indexDefaultList = _categories.indexWhere(
            (category) => category.id == _searchCategories[index].id);
        _categories[indexDefaultList] = _categories[indexDefaultList]
            .copyWith(isSelected: true); // set new selected category to true
        _selectedCategoryIndex.value =
            indexDefaultList; // set new selected category index
        _selectedCategoryId.value =
            _categories[indexDefaultList].id; // set new selected category id
        await ConfigurationStorage.saveSelectedCategory(
            categoryId: _categories[indexDefaultList].id,
            categoryName: _categories[indexDefaultList].name);
        await _homeController.updateNewQuotesByCategory(
            categoryId: _categories[indexDefaultList].id,
            categoryName: _categories[indexDefaultList].name);
        return SelectCategoryStatus.success;
      }
    } else {
      return SelectCategoryStatus.notSubscribed;
    }
  }
}
