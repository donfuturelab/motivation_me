import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivation_me/models/enum.dart';

import '../../models/collection.dart';
import '../../repositories/collections_repository.dart';
import '../../repositories/save_repository.dart';

class AddToCollectionController extends GetxController {
  final _collectionRepo = Get.find<CollectionsRepository>();
  final _saveRepo = Get.find<SavesRepository>();

  AddToCollectionController();
  final RxBool _isAddNew = false.obs;
  bool get isAddNew => _isAddNew.value;
  final RxList<Collection> _collections = <Collection>[].obs;
  List<Collection> get collections => _collections.toList();

  final textController = TextEditingController();
  final focusText = FocusNode();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    textController.dispose();
    focusText.dispose();
    super.onClose();
  }

  void addNewStatus(bool status) {
    _isAddNew.value = status;
    //add focus node to text field if add new collection
    if (status) {
      FocusScope.of(Get.context!).requestFocus(focusText);
    }
    //remove focus node if close add new collection
    if (!status) {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    }
    //clear text field if close add new collection
    if (!status) {
      textController.clear();
    }
  }

  Future<void> addNewCollection(String name) async {
    if (name.isEmpty) {
      return;
    }
    final newCollection = await _collectionRepo.addCollection(name);
    _collections.add(newCollection);
  }

  void clearText() {
    textController.clear();
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
    }
  }
}
