import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user_quote.dart';
import '../../repositories/user_quotes_repository.dart';

class CreateQuoteController extends GetxController {
  final UserQuotesRepository userQuoteRepo;
  CreateQuoteController({required this.userQuoteRepo});

  // final RxString _quoteContent = ''.obs;
  // String get quoteContent => _quoteContent.value;

  final TextEditingController _createTextController = TextEditingController();
  TextEditingController get createTextController => _createTextController;

  //create function to create quote
  Future<void> saveQuote() async {
    if (_createTextController.text.isEmpty) {
      return;
    }
    final UserQuoteMap quoteMap = UserQuoteMap(
      quoteContent: _createTextController.text,
    );
    await userQuoteRepo.createQuote(quoteMap);
    _createTextController.clear();
  }
}
