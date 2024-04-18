import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motivation_me/common_widgets/buttons.dart';
import 'package:motivation_me/common_widgets/circle_progress_bar.dart';
import 'package:motivation_me/core/extensions/async_value_extension.dart';

import '/features/create_quote/create_quote_provider.dart';
import '/features/my_quotes/my_quotes_screen.dart';

import '../../core/constant/colors.dart';

class CreateQuoteScreen extends HookConsumerWidget {
  const CreateQuoteScreen({super.key});

  // final _controller = Get.find<CreateQuoteController>();
  // final _myQuotesController = Get.find<MyQuotesController>();
  // final _mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController(text: '');
    final focusNode = useFocusNode();
    final AsyncValue<void> state = ref.watch(createQuoteControllerProvider);

    ref.listen<AsyncValue<void>>(createQuoteControllerProvider,
        (_, state) => state.showSnackbarOnError(context));

    return Container(
      color: AppColors.black,
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.black,
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 60,
              backgroundColor: AppColors.black,
              leading: IconButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(const Duration(milliseconds: 350));
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                icon: const ButtonToClose(),
              ),
              actions: [
                TextButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            if (textController.text.isEmpty) {
                              Get.snackbar('Error', 'Quote cannot be empty',
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM);
                              return;
                            } else {
                              await ref
                                  .read(createQuoteControllerProvider.notifier)
                                  .saveQuote(textController.text);

                              // Navigator.of(context).pus

                              // await _myQuotesController.refreshData();
                            }
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
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
                  const SizedBox(height: 20),
                  Text('Your Quote', style: context.textTheme.labelMedium!),
                  Container(
                    padding: const EdgeInsets.only(left: 0),
                    margin: const EdgeInsets.only(top: 10),
                    // decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(25),
                    //     border: Border.all(color: AppColors.black, width: 2)),
                    child: TextField(
                      controller: textController,
                      focusNode: focusNode,
                      // focusNode: ,
                      autofocus: true,

                      style:
                          context.textTheme.displayLarge!.copyWith(height: 1.5),
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
          ),
        ),
      ),
    );
  }
}
