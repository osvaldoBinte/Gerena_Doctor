import 'package:flutter/material.dart';
import 'package:gerena/common/settings/routes_names.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/features/publications/domain/entities/postreaction/post_reaction_entity.dart';
import 'package:gerena/features/publications/presentation/page/getPostReaction/get_post_reaction_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PostReactionsPage extends StatelessWidget {
  const PostReactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetPostReactionController>();

    return Scaffold(
      backgroundColor: GerenaColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: GerenaColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: GerenaColors.textPrimaryColor),
          onPressed: () => Get.offAllNamed(RoutesNames.homePage),
        ),
        title: Obx(() => Text(
              'Reacciones · ${controller.totalReactions}',
              style: GoogleFonts.rubik(
                fontSize: 18,
                color: GerenaColors.textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            )),
      ),
      body: Column(
        children: [
          _buildFilterTabs(controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.reactions.isEmpty) {
                return _buildLoadingState();
              }

              if (controller.reactions.isEmpty) {
                return _buildEmptyState();
              }

              return _buildReactionsList(controller);
            }),
          ),
        ],
      ),
    );
  }

 Widget _buildFilterTabs(GetPostReactionController controller) {
  return Obx(() => Container(
        decoration: BoxDecoration(
          color: GerenaColors.backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: GerenaColors.dividerColor,
              width: 1,
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _buildFilterTab(
                controller: controller,
                label: 'Todas',
                value: 'all',
                count: controller.totalReactions,
                icon: Icons.emoji_emotions,
                color: GerenaColors.textSecondaryColor,
              ),
              _buildFilterTab(
                controller: controller,
                label: 'Me gusta',
                value: 'like',
                count: controller.likesCount.value,
                imagePath: 'assets/icons/reacciones/recomendar.png',
                color: GerenaColors.primaryColor,
              ),
              _buildFilterTab(
                controller: controller,
                label: 'Me encanta',
                value: 'meencanta',
                count: controller.iLoveCount.value,
                imagePath: 'assets/icons/reacciones/meencanta.png',
                color: GerenaColors.errorColor,
              ),
              _buildFilterTab(
                controller: controller,
                label: 'Me asombra',
                value: 'measombra',
                count: controller.amazesMeCount.value,
                imagePath: 'assets/icons/reacciones/measombra.png',
                color: GerenaColors.warningColor,
              ),
              _buildFilterTab(
                controller: controller,
                label: 'Lo necesito',
                value: 'lonecesito',
                count: controller.iNeedItCount.value,
                imagePath: 'assets/icons/reacciones/lonecesito.png',
                color: GerenaColors.successColor,
              ),
            ],
          ),
        ),
      ));
}

 Widget _buildFilterTab({
  required GetPostReactionController controller,
  required String label,
  required String value,
  required int count,
  String? imagePath, 
  IconData? icon,
  required Color color,
}) {
  final isSelected = controller.selectedFilter.value == value;

  return GestureDetector(
    onTap: () => controller.setFilter(value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? GerenaColors.primaryColor : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != 'all' && imagePath != null)
            ColorFiltered(
              colorFilter: isSelected
                  ? ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                  : ColorFilter.mode(
                      GerenaColors.textSecondaryColor,
                      BlendMode.srcATop,
                    ),
              child: Image.asset(
                imagePath,
                width: 20,
                height: 20,
              ),
            )
          else if (value != 'all' && icon != null)
            Icon(
              icon,
              size: 20,
              color: isSelected ? color : GerenaColors.textSecondaryColor,
            ),
          if (value != 'all') const SizedBox(width: 6),
          Text(
            '$count',
            style: GoogleFonts.rubik(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? GerenaColors.textPrimaryColor
                  : GerenaColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildReactionsList(GetPostReactionController controller) {
    return Obx(() {
      final filteredReactions = controller.filteredReactions;

      if (filteredReactions.isEmpty) {
        return _buildNoResultsState();
      }

      return RefreshIndicator(
        onRefresh: controller.refreshReactions,
        color: GerenaColors.primaryColor,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: filteredReactions.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            thickness: 1,
            color: GerenaColors.dividerColor,
          ),
          itemBuilder: (context, index) {
            final reaction = filteredReactions[index];
            return _buildReactionCard(reaction);
          },
        ),
      );
    });
  }

Widget _buildReactionCard(PostReactionEntity reaction) {
  final reactionType = reaction.type.toLowerCase();

  String imagePath;
  Color color;

  switch (reactionType) {
    case 'like':
      imagePath = 'assets/icons/reacciones/recomendar.png';
      color = GerenaColors.primaryColor;
      break;
    case 'meencanta':
      imagePath = 'assets/icons/reacciones/meencanta.png';
      color = GerenaColors.errorColor;
      break;
    case 'measombra':
      imagePath = 'assets/icons/reacciones/measombra.png';
      color = GerenaColors.warningColor;
      break;
    case 'lonecesito':
      imagePath = 'assets/icons/reacciones/lonecesito.png';
      color = GerenaColors.successColor;
      break;
    default:
      imagePath = 'assets/icons/reacciones/recomendar.png';
      color = GerenaColors.textSecondaryColor;
  }

  return Container(
    color: GerenaColors.backgroundColor,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: GerenaColors.backgroundColorfondo,
              backgroundImage: reaction.fotouser != null &&
                      reaction.fotouser!.isNotEmpty
                  ? NetworkImage(reaction.fotouser!)
                  : null,
              child: reaction.fotouser == null || reaction.fotouser!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 20,
                      color: GerenaColors.textSecondaryColor,
                    )
                  : null,
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: GerenaColors.backgroundColor,
                    width: 1.5,
                  ),
                ),
                child: Image.asset(
                  imagePath,
                  width: 16,
                  height: 16,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            reaction.nameuser ?? 'Usuario desconocido',
            style: GoogleFonts.rubik(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          GerenaColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_emotions_outlined,
            size: 64,
            color: GerenaColors.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Sin reacciones',
            style: GoogleFonts.rubik(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: GerenaColors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sé el primero en reaccionar',
            style: GoogleFonts.rubik(
              fontSize: 14,
              color: GerenaColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: GerenaColors.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay reacciones de este tipo',
              style: GoogleFonts.rubik(
                fontSize: 16,
                color: GerenaColors.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}