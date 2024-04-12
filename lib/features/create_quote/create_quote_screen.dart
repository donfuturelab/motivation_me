import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constant/colors.dart';
import '../../routings/app_routes.dart';
import '../main_screen/main_controller.dart';
import '../my_quotes/my_quote_controller.dart';
import 'create_quote_controller.dart';

class CreateQuoteScreen extends StatelessWidget {
  CreateQuoteScreen({super.key});

  final _controller = Get.find<CreateQuoteController>();
  final _myQuotesController = Get.find<MyQuotesController>();
  final _mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        backgroundColor: AppColors.black,
        leading: CloseButton(
          onPressed: () => Get.back(),
          color: Colors.white,
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (_controller.createTextController.text.isEmpty) {
                  Get.snackbar('Error', 'Quote cannot be empty',
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                } else {
                  await _controller.saveQuote();
                  await _myQuotesController.refreshData();
                  _mainController.selectScreen(1);
                  Get.toNamed(Routes.mainScreen);
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColors.main),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Quote', style: context.textTheme.labelMedium!),
            Container(
              padding: const EdgeInsets.only(left: 0),
              margin: const EdgeInsets.only(top: 10),
              // decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(25),
              //     border: Border.all(color: AppColors.black, width: 2)),
              child: TextField(
                controller: _controller.createTextController,
                // focusNode: ,
                autofocus: true,

                style: context.textTheme.displayLarge!.copyWith(height: 1.5),
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'create your quote or note...',
                    hintStyle: context.textTheme.labelMedium!.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
