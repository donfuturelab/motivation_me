import 'package:motivation_me/models/default_quote.dart';
import 'package:motivation_me/models/enums/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constant/configurations.dart';

import '../models/enums/mood.dart';
import 'categories_repository.dart';
import 'default_quotes_repository.dart';

part 'mood_quotes_repository.g.dart';

class MoodQuotesRepository {
  final DefaultQuotesRepository defaultQuotesRepo;
  final CategoriesRepository categoriesRepo;

  MoodQuotesRepository(this.defaultQuotesRepo, this.categoriesRepo);

  Future<List<DefaultQuote>> getQuotesForMood(MoodType moodType) async {
    List<DefaultQuote> quotes = [];

    for (MoodCategory moodCategory in moodCategories[moodType]!) {
      final quoteNumber = moodCategory.percent *
          numberQuoteForMood ~/
          100; // divide but get int
      final categoryId = await categoriesRepo.getCategoryIdFromTag(
          convertCategoryEnumToString(moodCategory.categoryEnum));
      quotes.addAll(await defaultQuotesRepo.getSomeRandomQuotes(
          numerOfQuotes: quoteNumber, categoryId: categoryId));
    }
    // randomly shuffle the list
    quotes.shuffle();
    return quotes;
  }
}

@riverpod
MoodQuotesRepository moodQuotesRepository(MoodQuotesRepositoryRef ref) {
  return MoodQuotesRepository(ref.watch(defaultQuotesRepositoryProvider),
      ref.watch(categoriesRepositoryProvider));
}

class MoodCategory {
  final CategoryEnum categoryEnum;
  final double percent;

  MoodCategory(this.categoryEnum, this.percent);
}

Map<MoodType, List<MoodCategory>> moodCategories = {
  MoodType.happy: [
    MoodCategory(CategoryEnum.happiness, 50),
    MoodCategory(CategoryEnum.inspirational, 30),
    MoodCategory(CategoryEnum.success, 20),
  ],
  MoodType.sad: [
    MoodCategory(CategoryEnum.hope, 60),
    MoodCategory(CategoryEnum.pain, 10),
    MoodCategory(CategoryEnum.change, 30),
  ],
  MoodType.angry: [
    MoodCategory(CategoryEnum.wisdom, 20),
    MoodCategory(CategoryEnum.truth, 30),
    MoodCategory(CategoryEnum.courage, 30),
    MoodCategory(CategoryEnum.philosophy, 20),
  ],
  MoodType.challenged: [
    MoodCategory(CategoryEnum.inspirational, 40),
    MoodCategory(CategoryEnum.courage, 30),
    MoodCategory(CategoryEnum.success, 30),
  ],
  MoodType.love: [
    MoodCategory(CategoryEnum.love, 50),
    MoodCategory(CategoryEnum.relationships, 30),
    MoodCategory(CategoryEnum.romance, 20),
  ],
  MoodType.bored: [
    MoodCategory(CategoryEnum.inspirational, 10),
    MoodCategory(CategoryEnum.knowledge, 10),
    MoodCategory(CategoryEnum.humor, 80),
  ],
  MoodType.tired: [
    MoodCategory(CategoryEnum.inspirational, 20),
    MoodCategory(CategoryEnum.productivity, 30),
    MoodCategory(CategoryEnum.hope, 50),
  ],
  MoodType.discouraged: [
    MoodCategory(CategoryEnum.hope, 40),
    MoodCategory(CategoryEnum.confidence, 20),
    MoodCategory(CategoryEnum.courage, 20),
    MoodCategory(CategoryEnum.change, 20),
  ],
  MoodType.ok: [
    MoodCategory(CategoryEnum.life, 10),
    MoodCategory(CategoryEnum.happiness, 30),
    MoodCategory(CategoryEnum.inspirational, 30),
    MoodCategory(CategoryEnum.freedom, 10),
    MoodCategory(CategoryEnum.success, 20),
  ],
  MoodType.worried: [
    MoodCategory(CategoryEnum.hope, 40),
    MoodCategory(CategoryEnum.faith, 20),
    MoodCategory(CategoryEnum.courage, 30),
    MoodCategory(CategoryEnum.failure, 10),
  ],
};


//create function with switch case to get random quote from mood type


