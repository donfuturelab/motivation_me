import 'package:motivation_me/models/enum.dart';
import 'package:motivation_me/repositories/likes_repository.dart';

import '../../core/constant/configurations.dart';
import '../paywall/subscription_provider.dart';
import '/features/mood_asking/mood_asking_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/default_quote.dart';
import '../../repositories/mood_quotes_repository.dart';

part 'moode_asking_provider.g.dart';

@riverpod
class MoodAsking extends _$MoodAsking {
  @override
  FutureOr<List<DefaultQuote>> build(MoodModal mood) async {
    final quotes = await ref
        .watch(moodQuotesRepositoryProvider)
        .getQuotesForMood(mood.code);
    final isSubscribed = await ref.watch(subscriptionProvider.future);

    if (!isSubscribed) {
      //get the first 3 quotes
      return quotes.sublist(0, maximumQuoteForMoodNotSubscribed + 1);
    } else {
      return quotes;
    }
  }

  //like quote function
  Future<void> toggleLikeQuote(DefaultQuote quote, int index) async {
    final isLikedQuote = state.value![index].isLiked;
    final likesRepository = ref.watch(likesRepositoryProvider);

    if (isLikedQuote) {
      await likesRepository.unlikeQuote(
        quoteId: quote.id,
        quoteSource: QuoteSource.defaultQuote,
      );
    } else {
      await likesRepository.likeQuote(
        quoteId: quote.id,
        quoteSource: QuoteSource.defaultQuote,
      );
    }

    // update the quote list for index
    final quotes = state.value!;
    quotes[index] = quotes[index].copyWith(isLiked: !isLikedQuote);
    state = AsyncValue.data(quotes);
  }
}
