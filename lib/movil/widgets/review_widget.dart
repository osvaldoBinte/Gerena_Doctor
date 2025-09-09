import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/movil/homePage/PostController/post_controller.dart';
import 'package:gerena/movil/widgets/widgets_gobal.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewWidget extends StatelessWidget {
  final String userName;
  final String date;
  final String title;
  final String content;
  final List<String> images;
  final String userRole;
  final double rating;
  final int reactions;
  final String? avatarPath;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool showAgendarButton;
  final VoidCallback? onAgendarPressed;

  const ReviewWidget({
    Key? key,
    required this.userName,
    required this.date,
    required this.title,
    required this.content,
    required this.images,
    required this.userRole,
    required this.rating,
    required this.reactions,
    this.avatarPath,
    this.margin,
    this.padding,
    this.showAgendarButton = true,
    this.onAgendarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();
    
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: GerenaColors.backgroundColorFondo,
                backgroundImage: avatarPath != null && avatarPath!.isNotEmpty
                  ? AssetImage(avatarPath!)
                  : null,
                child: (avatarPath == null || avatarPath!.isEmpty)
                  ? Icon(
                    Icons.person,
                    color: GerenaColors.primaryColor,
                  )
                  : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: GerenaColors.headingSmall.copyWith(
                        fontSize: 14,
                        color: GerenaColors.textTertiary,
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: GerenaColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            title,
            style: GerenaColors.storyText.copyWith(
              color: GerenaColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            content,
            style: GerenaColors.storyText.copyWith(
              color: GerenaColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          buildImageGallery(images),
          
          const SizedBox(height: 16),
          
          Stack(
            children: [
              Container(
                color: GerenaColors.backgroundColor,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Obx(() => Opacity(
                                  opacity: postController.showReactionOptions.value ? 0.0 : 1.0,
                                  child: GestureDetector(
                                    onTap: () => postController.toggleReactionOptions(),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Image.asset(
                                            postController.getSelectedReactionIcon()!,
                                            width: 24,
                                            height: 24,
                                            color: GerenaColors.textSecondaryColor,
                                          ),
                                        ),
                                        Text(
                                          postController.getSelectedReactionName(),
                                          style: GoogleFonts.rubik(
                                            fontSize: 9,
                                            color: GerenaColors.textSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                                const SizedBox(height: 8),
                                Text(
                                  '$reactions reacciones',
                                  style: GerenaColors.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            userRole,
                            style: GerenaColors.bodySmall.copyWith(
                              fontWeight: FontWeight.w500,
                              color: GerenaColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          
                          if (showAgendarButton)
                            GerenaColors.widgetButton(
                              onPressed: onAgendarPressed,
                            ),
                          
                          const SizedBox(height: 4),
                          
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'valoración',
                                style: GerenaColors.bodySmall.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GerenaColors.createStarRating(
                                rating: rating,
                                size: 12,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              Obx(() => postController.showReactionOptions.value
                ? Positioned(
                    bottom: 16,
                    left: -20,
                    child: Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          postController.reactionIcons.length,
                          (index) => GestureDetector(
                            onTap: () => postController.selectReaction(index),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      postController.reactionIcons[index],
                                      width: 24,
                                      height: 24,
                                      color: GerenaColors.textSecondaryColor,
                                    ),
                                  ),
                                  Text(
                                    postController.reactionNames[index],
                                    style: GoogleFonts.rubik(
                                      fontSize: 9,
                                      color: GerenaColors.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }
  
}