//import riverpod annotation
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/collection.dart';
import '../../models/enum.dart';
import '../../repositories/collections_repository.dart';
import '../../repositories/save_repository.dart';

part 'add_to_collection_provider.g.dart';

@riverpod
class AddToCollection extends _$AddToCollection {
  final _collectionRepo = CollectionsRepository();
  final _saveRepo = SavesRepository();

  List<Collection> _collections = [];

  @override
  Future<List<Collection>> build() async {
    _collections = await _collectionRepo.getCollections();
    return _collections;
  }

  Future<List<Collection>> fetchCollections() async {
    return await _collectionRepo.getCollections();
  }

  // add quote to collection
  Future<void> addQuoteToCollection({
    required int collectionId,
    required int quoteId,
    required QuoteSource quoteSource,
  }) async {
    // check if quote is already in collection
    final isQuoteInCollection = await _saveRepo.isQuoteInCollection(
      collectionId: collectionId,
      quoteId: quoteId,
      quoteSource: quoteSource,
    );

    if (isQuoteInCollection) {
      return;
    } else {
      await _saveRepo.addQuoteToCollection(
        collectionId: collectionId,
        quoteId: quoteId,
        quoteSource: quoteSource,
      );
      //update quote count in collection
      await _collectionRepo.increaseQuoteCount(collectionId);

      //check selected collection in state
      // then update quote count
    }
  }

  Future<void> addNewCollection(String name) async {
    final newCollection = await _collectionRepo.addCollection(name);

    final previousState = await future;

    state = AsyncValue.data([...previousState, newCollection]);
  }
}
