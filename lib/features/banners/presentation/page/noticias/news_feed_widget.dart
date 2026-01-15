import 'package:flutter/material.dart';
import 'package:gerena/features/banners/presentation/controller/banner_controller.dart';
import 'package:gerena/features/banners/presentation/page/banners/banners_list_widget.dart';
import 'package:gerena/features/banners/presentation/page/noticias/wigget/feed_widget.dart';
import 'package:gerena/features/banners/presentation/widgets/loading/news_feed_loading.dart';
import 'package:gerena/features/blog/presentation/widget/mixed_blog_feed.dart';
import 'package:gerena/features/marketplace/presentation/page/medications/desktop/GlobalShopInterface.dart';
import 'package:gerena/features/subscription/presentation/page/subscription_controller.dart';
import 'package:get/get.dart'; 
import 'package:gerena/common/theme/App_Theme.dart';

class NewsFeedWidget extends StatelessWidget {
  final bool isCompact;
  
  const NewsFeedWidget({
    Key? key,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return _buildFullNewsFeed();
  }

  Widget _buildFullNewsFeed() {
    final BannerController controller = Get.find<BannerController>();
    
    final SubscriptionController? subscriptionController = Get.isRegistered<SubscriptionController>() 
        ? Get.find<SubscriptionController>() 
        : null;
    
    return Obx(() {
      if (controller.isLoading.value) {
        return NewsFeedLoading(isCompact: false);
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.refreshBanners(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      }

      final subscription = subscriptionController?.currentSubscription.value;
      final planId = subscription?.subscriptionplanId;
      final shouldShowBlog = planId == 4;

      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          BannersListWidget(
            height: 200,
            maxBanners: 2, 
          ),
          const SizedBox(height: 30),
          
          if (shouldShowBlog) MixedBlogFeed(),
        ],
      );
    });
  }

  void _navigateToForum() {
    Get.find<ShopNavigationController>().navigateToBlogGerena();
    Get.to(() => GlobalShopInterface());
  }
}