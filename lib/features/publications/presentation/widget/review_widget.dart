import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgets_gobal.dart';
import 'package:gerena/features/publications/presentation/page/post_controller.dart';
import 'package:gerena/features/publications/presentation/page/publication_controller.dart';
import 'package:gerena/movil/widgets/widgets_gobal.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewWidget extends StatefulWidget {
  final int postId;
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
  final bool isReview;
  final String? userReaction;
  final VoidCallback? onReactionPressed;
  final VoidCallback? onDeletePressed;
  final bool showDeleteButton;
  final Map<String, dynamic>? doctorData;

  const ReviewWidget({
    Key? key,
    required this.postId,
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
    this.isReview = true,
    this.userReaction,
    this.onReactionPressed,
    this.onDeletePressed,
    this.showDeleteButton = false,
    this.doctorData,
  }) : super(key: key);

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  late PostController postController;
  bool _initialized = false;
  final PublicationController publicationController =
      Get.find<PublicationController>();
  @override
  void initState() {
    super.initState();
    postController = Get.find<PostController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        postController.initializeUserReaction(
            widget.postId, widget.userReaction);
        _initialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.all(16),
      padding: widget.padding ?? const EdgeInsets.all(16),
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
                backgroundImage:
                    widget.avatarPath != null && widget.avatarPath!.isNotEmpty
                        ? NetworkImage(widget.avatarPath!)
                        : null,
                child: (widget.avatarPath == null || widget.avatarPath!.isEmpty)
                    ? Icon(Icons.person, color: GerenaColors.primaryColor)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: GerenaColors.headingSmall.copyWith(
                        fontSize: 14,
                        color: GerenaColors.textTertiary,
                      ),
                    ),
                    Text(
                      widget.date,
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: GerenaColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.showDeleteButton)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: GerenaColors.errorColor,
                    size: 24,
                  ),
                  onPressed: widget.onDeletePressed,
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.title.isNotEmpty) ...[
            Text(
              widget.title,
              style: GerenaColors.storyText.copyWith(
                color: GerenaColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (widget.content.isNotEmpty) ...[
            Text(
              widget.content,
              style: GerenaColors.storyText.copyWith(
                color: GerenaColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (widget.images.isNotEmpty) ...[
            buildImageGallery(widget.images),
            const SizedBox(height: 16),
          ],
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
                                Obx(
                                  () => Opacity(
                                    opacity:
                                        postController.isShowingReactionOptions(
                                                widget.postId)
                                            ? 0.0
                                            : 1.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        print(
                                            "Toggling reactions for post: ${widget.postId}");
                                        postController.toggleReactionOptions(
                                            widget.postId);
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                              postController.hasUserReacted(
                                                      widget.postId)
                                                  ? postController
                                                      .getSelectedReactionColor(
                                                          widget.postId)
                                                  : GerenaColors
                                                      .textSecondaryColor,
                                              BlendMode.srcATop,
                                            ),
                                            child: Image.asset(
                                              postController
                                                  .getSelectedReactionIcon(
                                                      widget.postId)!,
                                              width: 24,
                                              height: 24,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            postController
                                                .getSelectedReactionName(
                                                    widget.postId),
                                            style: GoogleFonts.rubik(
                                              fontSize: 9,
                                              color: GerenaColors
                                                  .textSecondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${widget.reactions} reacciones',
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
                          if (widget.userRole.isNotEmpty)
                            Text(
                              widget.userRole,
                              style: GerenaColors.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                                color: GerenaColors.textTertiary,
                              ),
                            ),
                          const SizedBox(height: 20),
                          if (widget.isReview) ...[
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
                                  rating: widget.rating,
                                  size: 12,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                print(
                    "Estado de opciones para post ${widget.postId}: ${postController.isShowingReactionOptions(widget.postId)}");
                return postController.isShowingReactionOptions(widget.postId)
                    ? Positioned(
                        bottom: 16,
                        left: -20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              postController.reactionIcons.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  print(
                                      "Reacción seleccionada: ${postController.reactionNames[index]}");
                                  postController.selectReaction(
                                      widget.postId, index);
                                  final reactionType =
                                      postController.getCurrentReactionType(
                                    widget.postId,
                                  );
                                  publicationController.toggleLike(
                                      widget.postId, reactionType);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        postController.reactionIcons[index],
                                        width: 24,
                                        height: 24,
                                      ),
                                      Text(
                                        postController.reactionNames[index],
                                        style: GoogleFonts.rubik(
                                          fontSize: 9,
                                          color: Color(0xFFF0F0F0),
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
                    : const SizedBox.shrink();
              }),
            ],
          ),
        ],
      ),
    );
  }
}
