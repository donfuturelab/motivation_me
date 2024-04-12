import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/local_storage/quote_theme_storage.dart';
import '../../models/enum.dart';
import '../../models/theme/quote_theme.dart';
import '../../models/user_quote.dart';
import '../../repositories/likes_repository.dart';
import '../../repositories/user_quotes_repository.dart';

class MyQuotesController extends GetxController
    with GetTickerProviderStateMixin {
  final LikesRepository likesRepo;
  final UserQuotesRepository userQuoteRepo;
  MyQuotesController({required this.userQuoteRepo, required this.likesRepo});

  final _box = QuoteThemeStorage();

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  final _quoteThemes = <QuoteTheme>[];
  List<QuoteTheme> get quoteThemes => _quoteThemes;

  final List<UserQuote> _quotes = <UserQuote>[];
  List<UserQuote> get quotes => _quotes;

  final RxBool _isEmptyQuote = true.obs;
  bool get isEmptyQuote => _isEmptyQuote.value;

  AnimationController? _animationController;
  AnimationController? get animationController => _animationController;
  // Animation<double>? _scaleAnimation;
  Animation<double>? scaleAnimation;

  @override
  void onInit() {
    super.onInit();
    _getUserQuotes();
    _quoteThemes.addAll(_box.getThemes()); //get all themes from local storage
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    scaleAnimation =
        Tween<double>(begin: 1, end: 1.2).animate(_animationController!);
    _animationController!.forward();
  }

  @override
  void onClose() {
    _animationController!.dispose();
    super.onClose();
  }

  Future<void> refreshData() async {
    _quotes.clear();
    await _getUserQuotes();
    return Future.value();
  }

  Future<void> _getUserQuotes() async {
    _isLoading.value = true;
    final List<UserQuote> quotes = await userQuoteRepo.getQuotes(page: 1);

    if (quotes.isEmpty) {
      _isEmptyQuote.value = true;
    } else {
      _isEmptyQuote.value = false;
      _quotes.addAll(quotes);
    }

    _isLoading.value = false;
  }

  void resetScaleAnimation() {
    _animationController!.reset();
    _animationController!.forward();
  }

  Future<void> toggleLikeQuote(UserQuote quote, int index) async {
    if (quote.isLiked.value) {
      await likesRepo.unlikeQuote(
          quoteId: quote.id, quoteSource: QuoteSource.userQuote);
    } else {
      await likesRepo.likeQuote(
          quoteId: quote.id, quoteSource: QuoteSource.userQuote);
    }
    quote.isLiked.value = !quote.isLiked.value;
  }

  void updateQuoteThemes(List<QuoteTheme> themes) {
    _quoteThemes.clear();
    _quoteThemes.addAll(themes);
  }
}
