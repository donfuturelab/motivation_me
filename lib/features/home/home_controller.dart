import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/default_quote.dart';
import '../../models/enum.dart';

import '../../repositories/default_quotes_repository.dart';
import '../../repositories/likes_repository.dart';
import 'selected_category_provider.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  FutureOr<List<DefaultQuote>> build() async {
    final category = ref.watch(selectedCategoryProvider);
    print('selected category home: ${category.id}');

    final List<DefaultQuote> quotes = await ref
        .read(defaultQuotesRepositoryProvider)
        .getQuotesByCategory(category.id);
    return quotes;
  }

  Future<void> toggleLikeQuote(DefaultQuote quote, int index) async {
    // state = const AsyncLoading();
    if (quote.isLiked) {
      await ref.read(likesRepositoryProvider).unlikeQuote(
          quoteId: quote.id, quoteSource: QuoteSource.defaultQuote);
    } else {
      await ref
          .read(likesRepositoryProvider)
          .likeQuote(quoteId: quote.id, quoteSource: QuoteSource.defaultQuote);
    }
    // List<DefaultQuote> quoteList = state.valueOrNull!;
    List<DefaultQuote> quoteList = List<DefaultQuote>.from(state.value ?? []);
    quoteList[index] = quote.copyWith(isLiked: !quote.isLiked);
    state = AsyncData(quoteList);
  }

  //fetch more quotes by category
  Future<void> fetchMoreQuotes() async {
    final category = ref.watch(selectedCategoryProvider);
    final List<DefaultQuote> quotes = await ref
        .read(defaultQuotesRepositoryProvider)
        .getQuotesByCategory(category.id);
    final List<DefaultQuote> quoteList =
        List<DefaultQuote>.from(state.value ?? []);
    quoteList.addAll(quotes);
    state = AsyncData(quoteList);
  }
}
