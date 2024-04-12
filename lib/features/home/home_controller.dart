import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/local_storage/configuration_storage.dart';
import '../../core/local_storage/quote_theme_storage.dart';
import '../../models/default_quote.dart';
import '../../models/enum.dart';
import '../../models/theme/quote_theme.dart';
import '../../repositories/default_quotes_repository.dart';
import '../../repositories/likes_repository.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final DefaultQuotesRepository dfQuotesRepo;
  final LikesRepository likesRepo;

  HomeController({required this.dfQuotesRepo, required this.likesRepo});

  final _box = QuoteThemeStorage();

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  final RxList<DefaultQuote> _quotes = <DefaultQuote>[].obs;
  List<DefaultQuote> get quotes => _quotes.toList();

  AnimationController? _animationController;
  AnimationController? get animationController => _animationController;
  // Animation<double>? _scaleAnimation;
  Animation<double>? scaleAnimation;

  final _quoteThemes = <QuoteTheme>[];
  List<QuoteTheme> get quoteThemes => _quoteThemes;

  final RxString _selectedCategoryName = 'General'.obs;
  String get selectedCategoryName => _selectedCategoryName.value;

  final RxBool isShowInitReminder = false.obs;

  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _quoteThemes.addAll(_box.getThemes()); //get all themes from local storage
    _getRandomQuotesByCategory(ConfigurationStorage
        .getSelectedCategoryId()); //get quotes by selected category
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    scaleAnimation =
        Tween<double>(begin: 1, end: 1.2).animate(_animationController!);
    _animationController!.forward();

    // Show reminder init bottomsheet after 30 second if user not set init reminder
    if (!ConfigurationStorage.getIsSetInitReminder()) {
      _timer = Timer(const Duration(seconds: 15), () {
        isShowInitReminder.value = true;
      });
    }
  }

  @override
  void onClose() {
    _animationController!.dispose();
    _timer.cancel();
    super.onClose();
  }

  // Future<void> _getRandomQuotes() async {
  //   _isLoading.value = true;
  //   final List<DefaultQuote> quotes = await dfQuotesRepo.getRandomQuotes();
  //   _quotes.addAll(quotes);
  //   _isLoading.value = false;
  // }
  Future<void> _getRandomQuotesByCategory(int categoryId) async {
    _isLoading.value = true;
    final List<DefaultQuote> quotes =
        await dfQuotesRepo.getQuotesByCategory(categoryId);
    _quotes.addAll(quotes);
    _isLoading.value = false;
  }

  Future<void> updateNewQuotesByCategory(
      {required int categoryId, required String categoryName}) async {
    _quotes.clear();
    await _getRandomQuotesByCategory(categoryId);
    _selectedCategoryName.value = categoryName;
  }

  void resetScaleAnimation() {
    _animationController!.reset();
    _animationController!.forward();
  }

  Future<void> toggleLikeQuote(DefaultQuote quote, int index) async {
    if (quote.isLiked) {
      await likesRepo.unlikeQuote(
          quoteId: quote.id, quoteSource: QuoteSource.defaultQuote);
    } else {
      await likesRepo.likeQuote(
          quoteId: quote.id, quoteSource: QuoteSource.defaultQuote);
    }
    _quotes[index] = quote.copyWith(isLiked: !quote.isLiked);
    // _quotes.refresh();
  }

  void updateQuoteThemes(List<QuoteTheme> themes) {
    _quoteThemes.clear();
    _quoteThemes.addAll(themes);
  }
}
