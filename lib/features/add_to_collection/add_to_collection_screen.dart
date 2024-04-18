import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/common_widgets/buttons.dart';
import '/core/constant/colors.dart';
import '/models/collection.dart';
import '/models/enum.dart';

import 'add_to_collection_provider.dart';

class AddToCollectionScreen extends HookConsumerWidget {
  final int quoteId;
  final QuoteSource quoteSource;

  const AddToCollectionScreen(
      {super.key, required this.quoteId, required this.quoteSource});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAddNew = useState(false);
    final textController = useTextEditingController(text: '');
    final focusText = useFocusNode();
    final context = useContext();

    void addNewCollection() async {
      await ref
          .read(addToCollectionProvider.notifier)
          .addNewCollection(textController.text);

      textController.clear();
      isAddNew.value = false;
    }

    void addToCollection(int collectionId) async {
      if (!context.mounted) return;
      await ref.read(addToCollectionProvider.notifier).addQuoteToCollection(
          quoteId: quoteId,
          quoteSource: quoteSource,
          collectionId: collectionId);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    ListView buildCollections(List<Collection> collections) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index];
          return GestureDetector(
            onTap: () async {
              addToCollection(collection.id);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: AppColors.middleBlack,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(collection.name, style: context.textTheme.displayMedium),
                  const SizedBox(height: 10),
                  Text('${collection.quoteCount.toString()} quotes',
                      style: context.textTheme.displayMedium),
                ],
              ),
            ),
          );
        },
      );
    }

    Widget buildAddToCollection() {
      final collections = ref.watch(addToCollectionProvider);

      return Column(
        key: const Key('add_to_collection'),
        children: [
          Text('Add to collection', style: context.textTheme.displayLarge),
          const SizedBox(height: 20),
          SizedBox(
            width: context.width,
            child: collections.when(
                data: (collections) {
                  return collections.isEmpty
                      ? _emptyCollection(context)
                      : buildCollections(collections);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                      child: Text('Error: $error'),
                    )),
          ),
        ],
      );
    }

    Widget buildAddNewCollection() {
      return GestureDetector(
        onTap: () {
          focusText.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            key: const Key('add_new_collection'),
            children: [
              Text('Add new collection', style: context.textTheme.displayLarge),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: context.width - 32,
                child: TextField(
                  controller: textController,
                  focusNode: focusText,
                  autocorrect: true,
                  style: context.textTheme.displayMedium,
                  decoration: InputDecoration(
                    hintText: 'Collection name',
                    hintStyle: context.textTheme.displayMedium
                        ?.copyWith(color: AppColors.textGreyColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: context.width - 32,
                child: ElevatedButton(
                  onPressed: () => addNewCollection(),
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

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Scaffold(
        backgroundColor: AppColors.black,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.black,
          elevation: 0,
          leading: !isAddNew.value
              ? IconButton(
                  icon: const ButtonToClose(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : BackButton(
                  onPressed: () {
                    isAddNew.value = false;
                    //remove focus node if close add new collection
                    focusText.unfocus();
                  },
                  color: AppColors.textColor,
                ),
          actions: [
            !isAddNew.value
                ? TextButton(
                    child:
                        Text('Add new', style: context.textTheme.displayMedium),
                    onPressed: () {
                      isAddNew.value = true;
                      //add focus node to text field if add new collection
                      focusText.requestFocus();
                    },
                  )
                : const SizedBox()
          ],
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: isAddNew.value ? -context.width : 0,
              child: buildAddToCollection(),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: isAddNew.value ? 0 : context.width,
              child: buildAddNewCollection(),
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
