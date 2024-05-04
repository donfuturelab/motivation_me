//import riverpod annotations, riverpod
import 'package:motivation_me/features/my_quotes/my_quote_controller.dart';
import 'package:motivation_me/repositories/user_quotes_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/user_quote.dart';

part 'create_quote_provider.g.dart';

@riverpod
class CreateQuoteController extends _$CreateQuoteController {
  final _userQuoteRepo = UserQuotesRepository();

  @override
  FutureOr<void> build() async {}

  Future<void> saveQuote(String quote) async {
    final UserQuoteMap quoteMap = UserQuoteMap(
      quoteContent: quote,
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _userQuoteRepo.createQuote(quoteMap));

    ref.invalidate(myQuoteControllerProvider);
  }
}
// Future<void> saveQuote(SaveQuoteRef ref, {required String quote}) async {
//   final userQuoteRepo = UserQuotesRepository();
//   final UserQuoteMap quoteMap = UserQuoteMap(
//     quoteContent: quote,
//   );
//   await userQuoteRepo.createQuote(quoteMap);
// }
