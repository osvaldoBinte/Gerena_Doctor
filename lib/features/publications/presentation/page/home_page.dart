import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:gerena/features/appointment/presentation/page/addappointment/modal_agregar_cita.dart';
import 'package:gerena/features/appointment/presentation/page/calendar/calendar_controller.dart';
import 'package:gerena/features/appointment/presentation/page/perfil/PatientProfileScreen.dart';
import 'package:gerena/features/appointment/presentation/widget/citas_loading.dart';
import 'package:gerena/features/banners/presentation/page/banners/banners_list_widget.dart';
import 'package:gerena/features/doctors/presentation/page/editperfildoctor/movil/controller_perfil_configuration.dart';
import 'package:gerena/features/doctors/presentation/page/prefil_dortor_controller.dart';
import 'package:gerena/features/publications/domain/entities/myposts/publication_entity.dart';
import 'package:gerena/features/publications/presentation/page/post_controller.dart';
import 'package:gerena/features/publications/presentation/page/publication_controller.dart';
import 'package:gerena/features/publications/presentation/widget/post_card_widget.dart';
import 'package:gerena/features/stories/presentation/page/storyring/my_story_ring_widget.dart';
import 'package:gerena/features/stories/presentation/page/story_controller.dart';
import 'package:gerena/features/stories/presentation/page/story_modal_widget.dart';
import 'package:gerena/features/stories/presentation/page/storyring/story_ring_widget.dart';
import 'package:gerena/features/stories/presentation/widgets/story_ring_loading.dart';
import 'package:gerena/movil/home/start_controller.dart';
import 'package:gerena/movil/homePage/PostController/post_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageMovil extends StatefulWidget {
  const HomePageMovil({Key? key}) : super(key: key);

  @override
  State<HomePageMovil> createState() => _GerenaFeedScreenState();
}

class _GerenaFeedScreenState extends State<HomePageMovil> {
  final CalendarControllerGetx calendarController =
      Get.find<CalendarControllerGetx>();

  final PrefilDortorController doctorController =
      Get.find<PrefilDortorController>();
  final ControllerPerfilConfiguration profileController =
      Get.put(ControllerPerfilConfiguration());

  final StoryController storyController = Get.find<StoryController>();

  final PublicationController publicationController =
      Get.find<PublicationController>();

  final ScrollController _internalScrollController = ScrollController();

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    //final fechaInicial = DateTime(2025, 9, 1);
    // calendarController.loadAppointmentsForDate(fechaInicial);

    _pageController = PageController();

    _internalScrollController.addListener(_scrollListener);

    _pageController.addListener(_pageViewListener);
  }

  @override
  void dispose() {
    _internalScrollController.removeListener(_scrollListener);
    _pageController.removeListener(_pageViewListener);
    _internalScrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_internalScrollController.position.pixels >=
        _internalScrollController.position.maxScrollExtent - 50) {}
  }

  void _pageViewListener() {
    if (!_pageController.hasClients) return;

    final currentPage = _pageController.page ?? 0;
    final totalItems = _getTotalPageViewItems();

    if (currentPage >= totalItems - 3 &&
        !publicationController.isLoading.value &&
        publicationController.hasMore.value) {
      publicationController.loadMorePosts();
    }
  }

  int _getTotalPageViewItems() {
    return 1 + publicationController.posts.length;
  }

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        kBottomNavigationBarHeight;

    return Scaffold(
      backgroundColor: GerenaColors.backgroundColorFondo,
      appBar: AppBar(
        backgroundColor: GerenaColors.backgroundColorFondo,
        elevation: 4,
        shadowColor: GerenaColors.shadowColor,
        title: Row(
          children: [
            Text(
              'GERENA',
              style: GoogleFonts.rubik(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            Container(
              width: 140,
              child: GerenaColors.createSearchContainer(
                height: 26,
                heightcontainer: 15,
                iconSize: 18,
                onTap: () {
                  final StartController controller =
                      Get.find<StartController>();
                  controller.showSearch();
                },
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (profileController.showPatientProfile.value) {
          final appointment = profileController.selectedAppointment.value;
          final appointmentEntity =
              calendarController.getAppointmentEntity(appointment.id);

          if (appointmentEntity != null) {
            return PatientProfileScreen(
              appointmentEntity: appointmentEntity,
              onClose: () {
                profileController.hidePatientProfileView();
              },
            );
          }
        }

        if (publicationController.isLoading.value &&
            publicationController.posts.isEmpty) {
          return _buildLoadingState(availableHeight);
        }

        if (publicationController.hasError.value &&
            publicationController.posts.isEmpty) {
          return _buildErrorState();
        }

        List<Widget> allItems = [
          _buildFirstPageWithScroll(availableHeight),
        ];

        if (publicationController.posts.isNotEmpty) {
          allItems.addAll(
            publicationController.posts.map((post) => Container(
                  height: availableHeight,
                  child: _buildPostFromEntity(post),
                )),
          );

          if (publicationController.hasMore.value) {
            allItems.add(
              Container(
                height: availableHeight,
                child: _buildLoadingMoreIndicator(),
              ),
            );
          } else {
            allItems.add(
              Container(
                height: availableHeight,
                child: _buildNoMorePostsMessage(),
              ),
            );
          }
        } else {
          allItems.add(
            Container(
              height: availableHeight,
              child: _buildEmptyPostsMessage(),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await publicationController.refreshPosts();
            await calendarController.loadAppointmentsForDate(
              calendarController.focusedDate.value,
            );
          },
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: allItems.length,
            itemBuilder: (context, index) {
              return allItems[index];
            },
            physics: const BouncingScrollPhysics(),
          ),
        );
      }),
    );
  }

  Widget _buildFirstPageWithScroll(double availableHeight) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          if (_internalScrollController.position.pixels >=
              _internalScrollController.position.maxScrollExtent - 10) {
            Future.delayed(Duration(milliseconds: 100), () {
              if (_pageController.hasClients && mounted) {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
          }
        }
        return false;
      },
      child: Container(
        height: availableHeight,
        child: Column(
          children: [
            Container(
              height: 100,
              color: GerenaColors.backgroundColorFondo,
              child: Obx(() {
                if (storyController.isLoading.value &&
                    storyController.allStories.isEmpty) {
                  return const StoryRingLoading(multiple: true);
                }

                final totalStories = storyController.allStories.length;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: totalStories + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return MyStoryRingWidget(
                        size: 80,
                      );
                    }

                    return Container(
                      margin:
                          const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                      child: StoryRingWidget(
                        index: index - 1,
                        size: 80,
                      ),
                    );
                  },
                );
              }),
            ),

            // NUEVO: RefreshIndicator envolviendo el Expanded
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await publicationController.refreshPosts();
                  await calendarController.loadAppointmentsForDate(
                    calendarController.focusedDate.value,
                  );
                },
                // IMPORTANTE: Necesario para que funcione en la parte superior
                displacement: 40,
                edgeOffset: 0,
                child: SingleChildScrollView(
                  controller: _internalScrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: GerenaColors.paddingMedium),
                      _buildCitasSection(),
                      SizedBox(height: GerenaColors.paddingMedium),
                      BannersListWidget(
                        height: 200,
                        maxBanners: 2,
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onVerticalDragEnd: (details) {
                          if (details.primaryVelocity! < -500) {
                            if (_pageController.hasClients) {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: GerenaColors.textSecondaryColor,
                                size: 32,
                              ),
                              Text(
                                'Desliza para ver publicaciones',
                                style: GoogleFonts.rubik(
                                  fontSize: 12,
                                  color: GerenaColors.textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(double availableHeight) {
    return Container(
      height: availableHeight,
      child: Column(
        children: [
          Container(
            height: 100,
            color: GerenaColors.backgroundColorFondo,
            child: const StoryRingLoading(multiple: true),
          ),
          Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: GerenaColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Error al cargar publicaciones',
            style: GoogleFonts.rubik(fontSize: 16),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => publicationController.loadFeedPosts(),
            child: Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPostsMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.post_add,
            size: 60,
            color: GerenaColors.textSecondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'No hay publicaciones disponibles',
            style: GoogleFonts.rubik(
              fontSize: 16,
              color: GerenaColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: GerenaColors.primaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'Cargando más publicaciones...',
            style: GoogleFonts.rubik(
              fontSize: 14,
              color: GerenaColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMorePostsMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 60,
            color: GerenaColors.primaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'Has visto todas las publicaciones',
            style: GoogleFonts.rubik(
              fontSize: 16,
              color: GerenaColors.textSecondaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Desliza hacia abajo para refrescar',
            style: GoogleFonts.rubik(
              fontSize: 12,
              color: GerenaColors.textTertiaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostFromEntity(PublicationEntity post) {
    final PostController postController = Get.find<PostController>();

    postController.initializeUserReaction(post.id, post.userreaction);

    String userRole;
    if (post.isReview && post.taggedDoctor != null) {
      userRole = post.taggedDoctor!.nombreCompleto ?? 'Doctor';
    } else if (post.isReview) {
      userRole = 'Reseña verificada';
    } else {
      userRole = 'Publicación';
    }

    return PostCardWidget(
      postId: post.id,
      author: post.author,
      userRole: userRole,
      postImages: publicationController.getOrderedImages(post),
      description: post.description,
      likes: post.reactions.total.toString(),
      rating: post.rating?.toDouble(),
      createdAt: publicationController.formatDate(post.createdAt),
      userHasLiked: post.userHasLiked,
      taggedDoctor: post.taggedDoctor,
      userReaction: post.userreaction,
      onReactionPressed: () {
        final reactionType = postController.getCurrentReactionType(post.id);
        publicationController.toggleLike(post.id, reactionType);
      },
      doctorData: {
        'doctorName': post.taggedDoctor?.nombreCompleto ?? 'Doctor',
        'specialty':
            post.taggedDoctor?.especialidad ?? 'Especialidad no especificada',
        'rating': post.rating?.toDouble() ?? 0.0,
        'reviews': post.reactions.total.toString(),
        'profileImage': post.taggedDoctor?.fotoPerfil ?? "assets/logo/logo.png",
        'userId': post.taggedDoctor?.id ?? 0,
      },
    );
  }

  Widget _buildCitasSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'CITAS',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GerenaColors.textPrimaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: Obx(() => calendarController.isLoading.value
                    ? Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: GerenaColors.primaryColor,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: Icon(Icons.refresh, size: 20),
                        onPressed: () {
                          calendarController.loadAppointmentsForDate(
                            calendarController.focusedDate.value,
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        iconSize: 20,
                      )),
              ),
            ],
          ),
          SizedBox(height: GerenaColors.paddingSmall),
          LayoutBuilder(
            builder: (context, constraints) {
              return Obx(() {
                if (calendarController.isLoading.value &&
                    calendarController.appointments.isEmpty) {
                  return CitasLoading();
                }

                final upcomingAppointments = _getUpcomingAppointments();

                if (upcomingAppointments.isEmpty) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: GerenaColors.backgroundColor,
                      borderRadius: GerenaColors.mediumBorderRadius,
                      boxShadow: [GerenaColors.lightShadow],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 48,
                            color: GerenaColors.textSecondaryColor,
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'No tienes citas próximas',
                              style: GoogleFonts.rubik(
                                fontSize: 14,
                                color: GerenaColors.textSecondaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: GerenaColors.widgetButton(
                                showShadow: false,
                                text: 'Agendar Cita',
                                onPressed: () {
                                  ModalAgregarCita.show();
                                },
                              )),
                        ],
                      ),
                    ),
                  );
                }

                final hasIndicators = upcomingAppointments.length > 1;
                final indicatorSpace = hasIndicators ? 30.0 : 0.0;
                final availableHeight = constraints.maxHeight;

                final citaCardHeight = hasIndicators
                    ? (availableHeight - indicatorSpace).clamp(150.0, 200.0)
                    : availableHeight.clamp(150.0, 220.0);

                return SizedBox(
                  height: citaCardHeight + indicatorSpace,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.85),
                          itemCount: upcomingAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = upcomingAppointments[index];
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: _buildCitaCard(appointment),
                            );
                          },
                        ),
                      ),
                      if (hasIndicators) ...[
                        SizedBox(height: 8),
                        SizedBox(
                          height: 20,
                          child:
                              _buildPageIndicators(upcomingAppointments.length),
                        ),
                      ],
                    ],
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  List<dynamic> _getUpcomingAppointments() {
    final allAppointments = calendarController.appointments.toList();

    if (allAppointments.isEmpty) {
      return [];
    }

    final confirmedAppointments = allAppointments.where((appointment) {
      final appointmentId = appointment.id as int;
      final entity = calendarController.getAppointmentEntity(appointmentId);

      return entity != null && entity.status.toLowerCase() == 'confirmada';
    }).toList();

    confirmedAppointments.sort((a, b) => a.startTime.compareTo(b.startTime));

    return confirmedAppointments.take(5).toList();
  }

  Widget _buildCitaCard(dynamic appointment) {
    final String formattedTime = _formatTime(appointment.startTime);
    final String formattedDate = _formatDate(appointment.startTime);

    final String doctorName = appointment.subject ?? 'Sin nombre';
    final String appointmentType = appointment.location ?? 'Cita general';
    final String treatment = appointment.notes ?? 'Sin descripción';

    // NUEVO: Obtenemos la foto desde el controller
    final String? photoUrl =
        calendarController.getAppointmentPhoto(appointment.id);

    return Container(
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: GerenaColors.mediumBorderRadius,
        boxShadow: [GerenaColors.lightShadow],
      ),
      child: ClipRRect(
        borderRadius: GerenaColors.mediumBorderRadius,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            doctorName,
                            style: GoogleFonts.rubik(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: GerenaColors.textPrimaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            appointmentType,
                            style: GoogleFonts.rubik(
                              fontSize: 12,
                              color: GerenaColors.textSecondaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            treatment,
                            style: GoogleFonts.rubik(
                              fontSize: 11,
                              color: GerenaColors.textTertiaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [GerenaColors.lightShadow],
                          ),
                          child: ClipOval(
                            child: photoUrl != null && photoUrl.isNotEmpty
                                ? Image.network(
                                    photoUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: GerenaColors.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: GerenaColors.textLightColor,
                                          size: 25,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: GerenaColors.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: GerenaColors.textLightColor,
                                      size: 25,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          formattedTime,
                          style: GoogleFonts.rubik(
                            fontSize: 12,
                            color: GerenaColors.textQuaternary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: GoogleFonts.rubik(
                            fontSize: 10,
                            color: GerenaColors.textTertiaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Center(
                  child: IntrinsicWidth(
                    child: GerenaColors.widgetButton(
                      onPressed: () {
                        profileController.showPatientProfileView(appointment);
                      },
                      text: 'Ver Ficha',
                      showShadow: false,
                      borderRadius: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicators(int count) {
    if (count <= 1) return SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            color: GerenaColors.backgroundColor,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [GerenaColors.mediumShadow],
          ),
        ),
        SizedBox(width: 6),
        Container(
          width: 80,
          height: 5,
          decoration: BoxDecoration(
            color: GerenaColors.backgroundColor,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [GerenaColors.mediumShadow],
          ),
        ),
        SizedBox(width: 6),
        Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            color: GerenaColors.backgroundColor,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [GerenaColors.mediumShadow],
          ),
        ),
        SizedBox(width: 6),
        Container(
          width: 20,
          height: 5,
          decoration: BoxDecoration(
            color: GerenaColors.backgroundColor,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [GerenaColors.mediumShadow],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'P.M.' : 'A.M.';
    return '$hour:$minute $period';
  }

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    return '$day/$month/$year';
  }
}
