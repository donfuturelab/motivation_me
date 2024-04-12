import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivation_me/common_widgets/buttons.dart';
import 'package:motivation_me/core/constant/colors.dart';
import 'package:motivation_me/models/enum.dart';

import 'add_to_collection_controller.dart';

class AddToCollectionScreen2 extends StatelessWidget {
  final int quoteId;
  final QuoteSource quoteSource;

  AddToCollectionScreen2(
      {super.key, required this.quoteId, required this.quoteSource});

  final _controller = Get.put(AddToCollectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: Obx(
          () => !_controller.isAddNew
              ? IconButton(
                  icon: const ButtonToClose(),
                  onPressed: () {
                    Get.back();
                  },
                )
              : BackButton(
                  onPressed: () => _controller.addNewStatus(false),
                  color: AppColors.textColor,
                ),
        ),
        actions: [
          Obx(() => !_controller.isAddNew
              ? TextButton(
                  child:
                      Text('Add new', style: context.textTheme.displayMedium),
                  onPressed: () {
                    _controller.addNewStatus(true);
                  },
                )
              : const SizedBox())
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(color: Colors.blue, child: _buildAddNewCollection(context)),
          SizedBox(
            height: 600,
          ),
        ],
      )),
    );
  }

  // double _getBottomPadding(BuildContext context) {
  //   final viewInsets = context.mediaQueryViewInsets.bottom;
  //   return viewInsets > 0 ? viewInsets + 16 : 0;
  // }

  // Widget _buildAddToCollection(BuildContext context) {
  //   return Column(
  //     key: const Key('add_to_collection'),
  //     children: [
  //       Text('Add to collection', style: context.textTheme.displayLarge),
  //       const SizedBox(height: 20),
  //       SizedBox(
  //         width: context.width,
  //         child: Obx(
  //           () => _controller.collections.isEmpty
  //               ? _emptyCollection(context)
  //               : Obx(
  //                   () => ListView.builder(
  //                     shrinkWrap: true,
  //                     itemCount: _controller.collections.length,
  //                     itemBuilder: (context, index) {
  //                       final collection = _controller.collections[index];
  //                       return GestureDetector(
  //                         onTap: () async {
  //                           await _controller.addQuoteToCollection(
  //                               quoteId: quoteId,
  //                               quoteSource: quoteSource,
  //                               collectionId: collection.id);
  //                           Get.back();
  //                           print('Add to collection');
  //                         },
  //                         child: Container(
  //                           padding: const EdgeInsets.all(16),
  //                           margin: const EdgeInsets.symmetric(
  //                               horizontal: 16, vertical: 8),
  //                           decoration: BoxDecoration(
  //                               color: AppColors.middleBlack,
  //                               borderRadius: BorderRadius.circular(15)),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(collection.name,
  //                                   style: context.textTheme.displayMedium),
  //                               const SizedBox(height: 10),
  //                               Text(
  //                                   '${collection.quoteCount.toString()} quotes',
  //                                   style: context.textTheme.displayMedium),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _buildAddNewCollection(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: SingleChildScrollView(
        child: Column(
          key: const Key('add_new_collection'),
          children: [
            Text('Add new collection', style: context.textTheme.displayLarge),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: context.width - 32,
              color: Colors.red,
              child: TextField(
                controller: _controller.textController,
                focusNode: _controller.focusText,
                style: context.textTheme.displayMedium,
                decoration: InputDecoration(
                  hintText: 'Collection name',
                  hintStyle: context.textTheme.displayMedium,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: context.width - 32,
              child: ElevatedButton(
                onPressed: () async {
                  await _controller
                      .addNewCollection(_controller.textController.text);
                  _controller.clearText();
                  _controller.addNewStatus(false);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.textColor),
                  minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  'Save',
                  style: context.textTheme.displayMedium?.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCollection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      decoration: BoxDecoration(
          color: AppColors.middleBlack,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('There is no exist collection',
              style: context.textTheme.displayLarge),
          const SizedBox(height: 10),
          Text('Please Add new collection',
              style: context.textTheme.displayMedium),
        ],
      ),
    );
  }
}
