// import 'package:get/get.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/enum.dart';
import '../../models/theme/quote_theme.dart';
import '../../models/user_quote.dart';
import '../../repositories/likes_repository.dart';
import '../../repositories/user_quotes_repository.dart';

part 'my_quote_controller.g.dart';

@riverpod
class MyQuoteController extends _$MyQuoteController {
  @override
  Future<List<UserQuote>> build() async {
    return await ref.watch(userQuotesRepositoryProvider).getQuotes(page: 1);
  }

  Future<void> toggleLikeQuote(UserQuote quote, int index) async {
    if (quote.isLiked) {
      await ref
          .read(likesRepositoryProvider)
          .unlikeQuote(quoteId: quote.id, quoteSource: QuoteSource.userQuote);
    } else {
      await ref
          .read(likesRepositoryProvider)
          .likeQuote(quoteId: quote.id, quoteSource: QuoteSource.userQuote);
    }
    List<UserQuote> quoteList = state.unwrapPrevious().valueOrNull!;
    quoteList[index] = quote.copyWith(isLiked: !quote.isLiked);
    state = AsyncData(quoteList);
  }

  void updateQuoteThemes(List<QuoteTheme> themes) {}
}
