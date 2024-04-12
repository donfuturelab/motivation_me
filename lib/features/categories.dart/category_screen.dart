import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/models/enums/category.dart';

import '../../common_widgets/circle_progress_bar.dart';
import '../../core/constant/colors.dart';
import '../../routings/app_routes.dart';
import '../paywall/paywall_screen.dart';
import '../paywall/subscription_controller.dart';
import 'category_controller.dart';

class CategoryScreen extends StatelessWidget {
  final controller = Get.put(CategoryController(categoryRepo: Get.find()));
  final _subscriptionController = Get.find<SubscriptionController>();
  // final controller = CategoryController(categoryRepo: Get.find());
  CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final heightScreen = context.height;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(
        () => controller.isLoading
            ? const CircleProgressBar()
            : CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  // sliver app bar
                  SliverAppBar(
                      backgroundColor: AppColors.black,
                      elevation: 0,
                      title: Obx(() => Visibility(
                            visible: controller.showTitle,
                            child: Text(
                              'Categories',
                              style: context.textTheme.displayLarge,
                            ),
                          )),
                      leading: BackButton(
                        onPressed: () => Get.back(),
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
                      )),

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
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SearchBarDelegate(),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: Obx(() => !controller.isShowSearchResult
                        ? _buildDefaultCategory(heightScreen)
                        : Obx(
                            () => controller.isLoadingSearch
                                ? const CircleProgressBar()
                                : _buildResultGrid(heightScreen),
                          )),
                  ),
                ],
              ),
      ),
    );
  }

  SliverGrid _buildDefaultCategory(double heightScreen) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20),
      // childCount: controller.categories.length,
      delegate: SliverChildBuilderDelegate(
          childCount: controller.categories.length, (context, index) {
        final category = controller.categories[index];
        return GestureDetector(
          onTap: () async {
            final selectStatus = await controller.selectCategory(index);
            // use switch case to handle different status
            switch (selectStatus) {
              case SelectCategoryStatus.success:
                Get.offNamed(Routes.home);
                // Get.delete<
                //     CategoryController>(); // delete controller after navigate
                break;
              case SelectCategoryStatus.notSubscribed:
                _buildPaywallBottomSheet(heightScreen);
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
                        : Obx(() => Visibility(
                              visible: !_subscriptionController.isSubscribed &&
                                  category.type == CategoryType.premium,
                              child: const Icon(Icons.lock,
                                  color: Colors.grey, size: 20),
                            )),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  SliverGrid _buildResultGrid(double heightScreen) {
    return SliverGrid(
      // search result
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20),
      // childCount: controller.searchCategories.length,
      delegate: SliverChildBuilderDelegate(
          childCount: controller.searchCategories.length, (context, index) {
        final category = controller.searchCategories[index];
        return GestureDetector(
          onTap: () async {
            final selectStatus =
                await controller.selectCategoryFromSearch(index);
            // use switch case to handle different status
            switch (selectStatus) {
              case SelectCategoryStatus.success:
                controller
                    .clearSearchState(); // clear search state after select
                Get.toNamed(Routes.home);
                break;
              case SelectCategoryStatus.notSubscribed:
                _buildPaywallBottomSheet(heightScreen);
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
                        : Obx(
                            () => Visibility(
                              visible: !_subscriptionController.isSubscribed &&
                                  category.type == CategoryType.premium,
                              child: const Icon(Icons.lock,
                                  color: Colors.grey, size: 20),
                            ),
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

  void _buildPaywallBottomSheet(double heightScreen) {
    Get.bottomSheet(
        SizedBox(
          height: heightScreen,
          child: PaywallScreen(),
        ),
        isScrollControlled: true);
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final _controller = Get.find<CategoryController>();

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
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _controller.isSearching
                    ? searchBoxWidthFocus
                    : (searchBoxWidthFocus + 80),
                child: TextField(
                  controller: _controller.searchTextController,
                  focusNode: _controller.searchFocusNode,
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.lightBlack,
                    ),
                  ),
                  onChanged: (value) {
                    // Implement your search logic
                  },
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _controller.isSearching ? 80 : 0,
              child: Visibility(
                visible: _controller.isSearching,
                child: TextButton(
                  onPressed: () {
                    _controller.onCanceledSearch();
                  },
                  child: Text(
                    'Cancel',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) => false;
}
