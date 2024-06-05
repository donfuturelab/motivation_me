import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:motivation_me/models/quote_category.dart';

import '../../core/ultils/helpers/debounce.dart';
import '/models/enums/category.dart';

import '../../common_widgets/circle_progress_bar.dart';
import '../../core/constant/colors.dart';
import '../../routings/app_routes.dart';
import '../paywall/paywall_screen.dart';
import 'category_controller.dart';

class CategoryScreen extends HookConsumerWidget {
  // final _subscriptionController = Get.find<SubscriptionController>();
  // final controller = CategoryController(categoryRepo: Get.find());
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heightScreen = context.height;

    final statusBarHeight = MediaQuery.of(context).padding.top;

    final scrollController = useScrollController();
    final isShowTitle = useState(false);
    final isShowSearchResult = useState(false);
    // final isSearching = useState(false);
    final textSearchController = useTextEditingController();
    final searchFocusNode = useFocusNode();

    final controller = ref.watch(categoryControllerProvider);

    // create debouncer to handle search
    final debouncer =
        useMemoized(() => Debouncer(delay: const Duration(milliseconds: 500)));

    useEffect(() {
      // Add listener to scroll controller to show/hide title
      scrollController.addListener(() {
        if (scrollController.offset >= 40) {
          isShowTitle.value = true;
        } else {
          isShowTitle.value = false;
        }
      });
      return;
      // Add listener to search focus node to show/hide cancel button
    }, []);

    //search function
    void onSearch() {
      ref
          .read(categoryControllerProvider.notifier)
          .performSearch(textSearchController.text);
      isShowSearchResult.value = true;
    }

    useEffect(() {
      textSearchController.addListener(() {
        debouncer.call(onSearch);
      });
      return;
    }, []);

    void onCanceledSearch() {
      isShowSearchResult.value = false;
      ref.read(isSearchingCategoryProvider.notifier).setIsSearching(false);
      textSearchController.clear();
      searchFocusNode.unfocus();
      // ref.read(categoryControllerProvider.notifier).cancelSearch();
    }

    // void buildPaywallBottomSheet() {
    // showBottomSheet(
    //   context: context,
    //   builder: (context) {
    //     return SizedBox(
    //       height: MediaQuery.of(context).size.height,
    //       child: const PaywallScreen(),
    //     );
    //   },
    // );

    void buildPaywallBottomSheet(statusBarHeight) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Container(
                color: AppColors.black,
                padding: EdgeInsets.only(top: statusBarHeight),
                child: const PaywallScreen());
          });
    }

    SliverGrid buildDefaultCategory(List<QuoteCategory> categories,
        double heightScreen, bool isSubscribed) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20),
        // childCount: controller.categories.length,
        delegate: SliverChildBuilderDelegate(childCount: categories.length,
            (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () async {
              final selectStatus = await ref
                  .read(categoryControllerProvider.notifier)
                  .selectCategory(category);
              // use switch case to handle different status
              switch (selectStatus) {
                case SelectCategoryStatus.success:
                  if (context.mounted) {
                    context.go(Routes.mainScreen);
                  }
                  break;
                case SelectCategoryStatus.notSubscribed:
                  buildPaywallBottomSheet(statusBarHeight);
                  break;
                case SelectCategoryStatus.alreadyAdded:
                  break;
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.middleBlack,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.name,
                          style: context.textTheme.labelMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.category, color: AppColors.textColor)
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: category.isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.textColor,
                              size: 20,
                            )
                          : Visibility(
                              visible: !isSubscribed &&
                                  category.type == CategoryType.premium,
                              child: const Icon(Icons.lock,
                                  color: Colors.grey, size: 20),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    }

    SliverGrid buildResultGrid(List<QuoteCategory> searchCategories,
        double heightScreen, bool isSubscribed) {
      return SliverGrid(
        // search result
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20),
        // childCount: controller.searchCategories.length,
        delegate: SliverChildBuilderDelegate(
            childCount: searchCategories.length, (context, index) {
          final category = searchCategories[index];
          return GestureDetector(
            onTap: () async {
              final selectStatus = await ref
                  .read(categoryControllerProvider.notifier)
                  .selectCategory(category);
              // use switch case to handle different status

              switch (selectStatus) {
                case SelectCategoryStatus.success:
                  // clear search state after select
                  if (context.mounted) {
                    context.go(Routes.home);
                  }
                  break;
                case SelectCategoryStatus.notSubscribed:
                  buildPaywallBottomSheet(statusBarHeight);
                  break;
                case SelectCategoryStatus.alreadyAdded:
                  break;
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.middleBlack,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.name,
                          style: context.textTheme.labelMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.category, color: AppColors.textColor)
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: category.isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.textColor,
                              size: 20,
                            )
                          : Visibility(
                              visible: isSubscribed &&
                                  category.type == CategoryType.premium,
                              child: const Icon(Icons.lock,
                                  color: Colors.grey, size: 20),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      body: controller.when(
          data: (state) {
            final categories = state.categories;
            final searchCategories = state.searchCategories;
            final isSubscribed = state.isSubscribed;

            return CustomScrollView(
              controller: scrollController,
              slivers: [
                // sliver app bar
                SliverAppBar(
                  backgroundColor: AppColors.black,
                  elevation: 0,
                  title: Visibility(
                    visible: isShowTitle.value,
                    child: Text(
                      'Categories',
                      style: context.textTheme.displayLarge,
                    ),
                  ),
                  leading: BackButton(
                    onPressed: () => context.pop(),
                    color: AppColors.textColor,
                  ),
                  floating: true,
                  snap: true,
                  pinned: true,
                  expandedHeight: 50,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: AppColors.black,
                    ),
                  ),
                ),
                //title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Categories',
                      style: context.textTheme.displayLarge,
                    ),
                  ),
                ),
                SearchBarWidget(
                  textSearchController: textSearchController,
                  searchFocusNode: searchFocusNode,
                  onCancelSearch: onCanceledSearch,
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: !isShowSearchResult.value
                      ? buildDefaultCategory(
                          categories, heightScreen, isSubscribed)
                      : buildResultGrid(
                          searchCategories, heightScreen, isSubscribed),
                ),
              ],
            );
          },
          loading: () => const CircleProgressBar(),
          error: (e, s) => Text('Error: $e')),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController textSearchController;
  final FocusNode searchFocusNode;
  final VoidCallback onCancelSearch;
  final bool isSearching;
  final WidgetRef ref;

  _SearchBarDelegate({
    required this.isSearching,
    required this.textSearchController,
    required this.searchFocusNode,
    required this.onCancelSearch,
    required this.ref,
  });

  @override
  double get minExtent => 70; // Minimum extent
  @override
  double get maxExtent => 70; // Maximum extent

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final searchBoxWidthFocus = context.width - 32 - 80;
    return Container(
      color: AppColors.black, // Adjust as needed
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 70,
      child: Row(
        children: [
          Flexible(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSearching
                  ? searchBoxWidthFocus
                  : (searchBoxWidthFocus + 80),
              child: TextField(
                controller: textSearchController,
                focusNode: searchFocusNode,
                textAlignVertical: TextAlignVertical.center,
                style: context.textTheme.labelMedium?.copyWith(
                  color: AppColors.textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: context.textTheme.labelMedium?.copyWith(
                    color: AppColors.lightBlack,
                  ),
                  fillColor: AppColors.middleBlack,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.lightBlack,
                  ),
                ),
                onChanged: (value) {
                  // ref.read(isSearchingCategoryProvider.notifier).setIsSearching(true);
                },
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSearching ? 80 : 0,
            child: Visibility(
              visible: isSearching,
              child: TextButton(
                onPressed: onCancelSearch,
                child: Text(
                  'Cancel',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: AppColors.textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) => true;
}

class SearchBarWidget extends HookConsumerWidget {
  final TextEditingController textSearchController;
  final FocusNode searchFocusNode;
  final VoidCallback onCancelSearch;

  const SearchBarWidget({
    super.key,
    required this.textSearchController,
    required this.searchFocusNode,
    required this.onCancelSearch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = useState(false);

    useEffect(() {
      searchFocusNode.addListener(() {
        isSearching.value = searchFocusNode.hasFocus;
      });

      return;
    }, [searchFocusNode]);

    // final searchBoxWidthFocus = context.width - 32 - 80;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SearchBarDelegate(
        textSearchController: textSearchController,
        searchFocusNode: searchFocusNode,
        onCancelSearch: onCancelSearch,
        isSearching: isSearching.value,
        ref: ref,
      ),
    );
  }
}
