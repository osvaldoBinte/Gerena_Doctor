import 'package:flutter/material.dart';
import 'package:gerena/common/services/auth_service.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/publications/domain/entities/myposts/author_entity.dart';
import 'package:gerena/features/publications/domain/entities/myposts/tagged_doctor_entity.dart';
import 'package:gerena/features/publications/presentation/page/comment/comment_modal_widget.dart';
import 'package:gerena/features/publications/presentation/page/post_controller.dart';
import 'package:gerena/features/publications/presentation/page/publication_controller.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:gerena/features/publications/presentation/widget/posh_carousel.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PostCardWidget extends StatefulWidget {
  final int postId;
  final String userRole;
  final List<String> postImages;
  final String description;
  final String likes;
  final String createdAt;
  final bool userHasLiked;
  final double? rating;
  final TaggedDoctorEntity? taggedDoctor;
  final String? userReaction;
  final VoidCallback? onReactionPressed;
  final Map<String, dynamic>? doctorData;
  final AuthorEntity? author;
  final int? commentid;

  const PostCardWidget({
    Key? key,
    required this.postId,
    required this.userRole,
    required this.postImages,
    required this.description,
    required this.likes,
    required this.createdAt,
    required this.userHasLiked,
    this.rating,
    this.taggedDoctor,
    this.userReaction,
    this.onReactionPressed,
    this.doctorData,
    this.author,
    this.commentid
  }) : super(key: key);
  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  late PostController postController;
  bool _initialized = false;
  bool _isExpanded = false;

  final PublicationController publicationController =
      Get.find<PublicationController>();
  @override
@override
void initState() {
  super.initState();
  postController = Get.find<PostController>();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!_initialized) {
      postController.initializeUserReaction(
        widget.postId,
        widget.userReaction,
      );
      _initialized = true;
    }

    if (widget.commentid != null) {
      Get.bottomSheet(
        CommentModalWidget(
          postId: widget.postId,
          highlightCommentId: widget.commentid,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    }
  });
}

  String _formatTextWithLineBreaks(String text) {
    String processedText = text
        .replaceAll('Dr. ', 'TEMP_DR_PLACEHOLDER ')
        .replaceAll('Dra. ', 'TEMP_DRA_PLACEHOLDER ');
    processedText = processedText
        .replaceAll('. ', '.\n\n')
        .replaceAll('.', '.\n')
        .replaceAll('\n\n', '\n');
    processedText = processedText
        .replaceAll('TEMP_DR_PLACEHOLDER ', 'Dr. ')
        .replaceAll('TEMP_DRA_PLACEHOLDER ', 'Dra. ')
        .trim();
    return processedText;
  }

  @override
  Widget build(BuildContext context) {
    return GerenaColors.createPostCard(
      height: MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          kBottomNavigationBarHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: widget.author != null
                      ? () async {
                          AuthService authService = AuthService();
                          int? loggedUserId = await authService.getUsuarioId();
                          int authorId = widget.author!.id;

                          if (loggedUserId == authorId) {
                     
                            return;
                          }

                          if (widget.author != null) {
                            final rol = widget.author!.rol;
                            final startController = Get.find<StartController>();

                            if (rol == 'cliente') {
                              startController.showUserProfilePage(
                                userData: {
                                  'userId': widget.author!.id,
                                  'userName': widget.author!.name ?? 'Usuario',
                                  'username': widget.author!.profilePhoto ??
                                      widget.author!.name
                                          ?.toLowerCase()
                                          .replaceAll(' ', '') ??
                                      'usuario',
                                },
                              );
                            } else if (rol == 'doctor') {
                              print('roll es dcotor');
                              startController.showDoctorProfilePage(
                                doctorData: {
                                  'userId': widget.author!.id,
                                  'userName': widget.author!.name ?? 'Usuario',
                                  'username': widget.author!.profilePhoto ??
                                      widget.author!.name
                                          ?.toLowerCase()
                                          .replaceAll(' ', '') ??
                                      'usuario',
                                },
                              );
                            }

                            return;
                          }
                        }
                      : null,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: widget.author?.profilePhoto != null &&
                            widget.author!.profilePhoto!.isNotEmpty &&
                            widget.author!.profilePhoto!.startsWith('http')
                        ? NetworkImage(widget.author!.profilePhoto!)
                        : (widget.author?.profilePhoto != null &&
                                widget.author!.profilePhoto!.isNotEmpty
                            ? AssetImage(widget.author!.profilePhoto!)
                            : null),
                    child: widget.author?.profilePhoto == null ||
                            widget.author!.profilePhoto!.isEmpty
                        ? const Icon(Icons.person, size: 20)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: widget.author != null
                                    ? () async {
                                        AuthService authService = AuthService();
                                        int? loggedUserId =
                                            await authService.getUsuarioId();
                                        int authorId = widget.author!.id;

                                        if (loggedUserId == authorId) {
                                          return;
                                        }

                                        if (widget.author != null) {
                                          final rol = widget.author!.rol;
                                          final startController =
                                              Get.find<StartController>();

                                          if (rol == 'cliente') {
                                            startController.showUserProfilePage(
                                              userData: {
                                                'userId': widget.author!.id,
                                                'userName':
                                                    widget.author!.name ??
                                                        'Usuario',
                                                'username': widget
                                                        .author!.profilePhoto ??
                                                    widget.author!.name
                                                        ?.toLowerCase()
                                                        .replaceAll(' ', '') ??
                                                    'usuario',
                                              },
                                            );
                                          } else if (rol == 'doctor') {
                                            startController
                                                .showDoctorProfilePage(
                                              doctorData: {
                                                'userId': widget.author!.id,
                                                'userName':
                                                    widget.author!.name ??
                                                        'Usuario',
                                                'username': widget
                                                        .author!.profilePhoto ??
                                                    widget.author!.name
                                                        ?.toLowerCase()
                                                        .replaceAll(' ', '') ??
                                                    'usuario',
                                              },
                                            );
                                          }

                                          return;
                                        }
                                      }
                                    : null,
                                child: Text(
                                  widget.author?.name ?? 'Usuario',
                                  style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        widget.createdAt,
                        style: GoogleFonts.rubik(
                          color: GerenaColors.primaryColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.taggedDoctor != null) ...[
                      GestureDetector(
                        onTap: () {
                          final startController = Get.find<StartController>();
                          startController.showDoctorProfilePage(
                            doctorData: {
                              'userId': widget.taggedDoctor!.id,
                              'doctorName': widget.taggedDoctor!.nombreCompleto,
                              'specialty':
                                  widget.taggedDoctor!.especialidad ?? '',
                              'location': '',
                              'profileImage':
                                  widget.taggedDoctor!.fotoPerfil ?? '',
                              'rating': 0.0,
                              'reviews': '',
                              'info': '',
                            },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Dr./Dra ${widget.taggedDoctor!.nombreCompleto}',
                              style: GoogleFonts.rubik(
                                color: GerenaColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                decorationColor: GerenaColors.primaryColor,
                              ),
                            ),
                            if (widget.taggedDoctor!.especialidad != null)
                              Text(
                                widget.taggedDoctor!.especialidad!,
                                style: GoogleFonts.rubik(
                                  color: GerenaColors.textSecondaryColor,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ] else
                      Text(
                        widget.userRole,
                        style: GoogleFonts.rubik(
                          color: GerenaColors.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: PostCarousel(images: widget.postImages)),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                           
                            const Spacer(),
                            if (widget.rating != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (widget.taggedDoctor != null)
                                    GestureDetector(
                                      onTap: () {
                                        final startController =
                                            Get.find<StartController>();
                                        startController.showDoctorProfilePage(
                                          doctorData: {
                                            'userId': widget.taggedDoctor!.id,
                                            'doctorName': widget
                                                .taggedDoctor!.nombreCompleto,
                                            'specialty': widget.taggedDoctor!
                                                    .especialidad ??
                                                '',
                                            'location': '',
                                            'profileImage': widget
                                                    .taggedDoctor!.fotoPerfil ??
                                                'assets/logo/logo.png',
                                            'rating': 0.0,
                                            'reviews': '',
                                            'info': '',
                                          },
                                        );
                                      },
                                      child: Text(
                                        'Dr./Dra ${widget.taggedDoctor!.nombreCompleto}',
                                        style: GoogleFonts.rubik(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          decorationColor: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Container(height: 30),
                                  const SizedBox(height: 4),
                                  
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  child: GerenaColors.createStoryOverlay(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AbsorbPointer(
          absorbing: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final formattedText =
                  _formatTextWithLineBreaks(widget.description);
              final maxLines = 3;

              final textSpan = TextSpan(
                text: formattedText,
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              );

              final textPainter = TextPainter(
                text: textSpan,
                maxLines: maxLines,
                textDirection: TextDirection.ltr,
              )..layout(maxWidth: constraints.maxWidth);

              final isOverflowing = textPainter.didExceedMaxLines;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedText,
                    maxLines: _isExpanded ? null : maxLines,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (isOverflowing)
                    InkWell(
                      onTap: () {
                        print('Ver más clickeado');
                        setState(() => _isExpanded = !_isExpanded);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _isExpanded ? 'Ver menos' : 'Ver más',
                          style: GoogleFonts.rubik(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        AbsorbPointer(
          absorbing: false,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => Opacity(
                      opacity: postController.isShowingReactionOptions(
                        widget.postId,
                      )
                          ? 0.0
                          : 1.0,
                      child: InkWell(
                        onTap: () {
                          print(
                            "Toggling reactions for post: ${widget.postId}",
                          );
                          postController.toggleReactionOptions(
                            widget.postId,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                postController.hasUserReacted(
                                  widget.postId,
                                )
                                    ? postController
                                        .getSelectedReactionColor(
                                        widget.postId,
                                      )
                                    : Color(0xFFF0F0F0),
                                BlendMode.srcATop,
                              ),
                              child: Image.asset(
                                postController.getSelectedReactionIcon(
                                  widget.postId,
                                )!,
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              postController.getSelectedReactionName(
                                widget.postId,
                              ),
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
                ],
              ),
              SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.bottomSheet(
                        CommentModalWidget(
                          postId: widget.postId,
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          color: Color(0xFFF0F0F0),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Comentar',
                          style: GoogleFonts.rubik(
                            fontSize: 9,
                            color: Color(0xFFF0F0F0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            InkWell(
              onTap: () {
                print('Reacciones clickeadas');
                Get.offAllNamed(
                  RoutesNames.postReactionsPage,
                  arguments: {'publicationId': widget.postId},
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${widget.likes} reacciones',
                  style: GoogleFonts.rubik(
                    fontSize: 12,
                    color: GerenaColors.storyGradientEnd,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const Spacer(),

            if (widget.rating != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.taggedDoctor != null)
                    InkWell(
                      onTap: () {
                        final startController = Get.find<StartController>();
                        startController.showDoctorProfilePage(
                          doctorData: {
                            'userId': widget.taggedDoctor!.id,
                            'doctorName': widget.taggedDoctor!.nombreCompleto,
                            'specialty': widget.taggedDoctor!.especialidad ?? '',
                            'location': '',
                            'profileImage': widget.taggedDoctor!.fotoPerfil ?? 'assets/logo/logo.png',
                            'rating': 0.0,
                            'reviews': '',
                            'info': '',
                          },
                        );
                      },
                      child: Text(
                        'Dr./Dra ${widget.taggedDoctor!.nombreCompleto}',
                        style: GoogleFonts.rubik(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'valoración',
                                        style: GoogleFonts.rubik(
                                          fontSize: 10,
                                          color:
GerenaColors.storyGradientEnd,                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GerenaColors.createStarRating(
                                        rating: widget.rating!,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                ],
              ),
          ],
        ),
        
        const SizedBox(height: 8),
      ],
    ),
  ),
),
                Obx(() {
                  print(
                    "Estado de opciones para post ${widget.postId}: ${postController.isShowingReactionOptions(widget.postId)}",
                  );
                  return postController.isShowingReactionOptions(widget.postId)
                      ? Positioned(
                          bottom: 16,
                          left: 12,
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
                                      "Reacción seleccionada: ${postController.reactionNames[index]}",
                                    );
                                    postController.selectReaction(
                                      widget.postId,
                                      index,
                                    );
                                    final reactionType = postController
                                        .getCurrentReactionType(widget.postId);
                                    publicationController.toggleLike(
                                      widget.postId,
                                      reactionType,
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
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
          ),
        ],
      ),
    );
  }
}
