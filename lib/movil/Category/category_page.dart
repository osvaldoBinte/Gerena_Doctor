import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/common/widgets/widgts.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<CategoryItem> categories = [
    CategoryItem(
      name: 'TOXINAS',
      imagePath: 'assets/categoryItem/producto.png',
    ),
    CategoryItem(
      name: 'RELLENO FACIAL',
      imagePath: 'assets/categoryItem/producto.png',
    ),
    CategoryItem(
      name: 'RELLENO CORPORAL',
      imagePath: 'assets/categoryItem/producto.png',
    ),
    CategoryItem(
      name: 'ENZIMAS',
      imagePath: 'assets/categoryItem/producto.png',
    ),
    CategoryItem(
      name: 'BIOESTIMULADORES',
      imagePath: 'assets/categoryItem/producto.png',
    ),
    CategoryItem(
      name: 'SKINBOOSTER',
      imagePath: 'assets/categoryItem/producto.png',
    ),
    CategoryItem(
      name: 'ANESTESIA',
      imagePath: 'assets/categoryItem/producto.png',
    ),
    CategoryItem(
      name: 'ANTIOBESIDAD',
      imagePath: 'assets/categoryItem/producto.png',
    ),
    CategoryItem(
      name: 'INSUMOS',
      imagePath: 'assets/categoryItem/producto.pngg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(GerenaColors.paddingMedium),
              child: buildWishlistButton(),
            ),
            
            Expanded(
             child: _buildCategoryGridWithLines(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGridWithLines() {
    final int crossAxisCount = 2;
    final int rowCount = (categories.length / crossAxisCount).ceil();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return  Column(
        children: List.generate(rowCount, (rowIndex) {
          return Expanded(
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(crossAxisCount, (colIndex) {
                        final index = rowIndex * crossAxisCount + colIndex;
                        
                        return Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: isSmallScreen ? 80 : 100,
                                  ),
                                  child: index < categories.length
                                      ? _buildCategoryCard(categories[index])
                                      : Container(),
                                ),
                              ),
                              if (colIndex < crossAxisCount - 1)
                                Container(
                                  width: 1,
                                  color: GerenaColors.dividerColor,
                                ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  if (rowIndex < rowCount - 1)
                    Container(
                      height: 1,
                      color: GerenaColors.dividerColor,
                    ),
                ],
              ),
            ),
          );
        }),
     
    );
  }

  Widget _buildCategoryCard(CategoryItem category) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight;
        final double availableWidth = constraints.maxWidth;
        
        final double margin = availableWidth > 150 ? 12 : 4;
        final double imageSize = availableWidth > 150 ? 70 : 35;
        final double fontSize = availableWidth > 150 ? 14 : 9;
        final double iconSize = availableWidth > 150 ? 35 : 15;
        final double spacing = availableHeight > 120 ? 12 : 4;
        
        return GestureDetector(
          onTap: () {
            _navigateToCategory(category);
          },
          child: Container(
           
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 3,
                  child: Image.asset(
                    category.imagePath,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          color: GerenaColors.primaryColor,
                          borderRadius: GerenaColors.smallBorderRadius,
                          boxShadow: [
                            BoxShadow(
                              color: GerenaColors.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.category,
                          color: GerenaColors.textLightColor,
                          size: iconSize,
                        ),
                      );
                    },
                  ),
                ),
                
                SizedBox(height: spacing),
                
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: margin),
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: GerenaColors.textPrimaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToCategory(CategoryItem category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: GerenaColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: GerenaColors.mediumBorderRadius,
          ),
          title: Text(
            category.name,
            style: GerenaColors.headingMedium,
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: GerenaColors.primaryColor,
                    borderRadius: GerenaColors.smallBorderRadius,
                  ),
                  child: Icon(
                    Icons.category,
                    color: GerenaColors.textLightColor,
                  ),
                ),
                SizedBox(height: GerenaColors.paddingSmall),
                Text(
                  'Próximamente disponible',
                  style: GerenaColors.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: GerenaColors.accentColor,
              ),
              child: Text(
                'Cerrar',
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CategoryItem {
  final String name;
  final String imagePath;

  CategoryItem({
    required this.name,
    required this.imagePath,
  });
}

class CategoryPageWithNavigation extends StatefulWidget {
  @override
  _CategoryPageWithNavigationState createState() => _CategoryPageWithNavigationState();
}

class _CategoryPageWithNavigationState extends State<CategoryPageWithNavigation> {
  int _currentIndex = 1;
  
  final List<String> iconPaths = [
    'assets/icons/home.png',
    'assets/icons/categories.png',
    'assets/icons/cart.png',
    'assets/icons/profile.png',
  ];

  @override
  Widget build(BuildContext context) {
    return GerenaColors.createMainScaffold(
      body: CategoryPage(),
      currentIndex: _currentIndex,
      onNavigationTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        
        switch (index) {
          case 0:
            break;
          case 1:
            break;
          case 2:
            break;
          case 3:
            break;
        }
      },
      iconPaths: iconPaths,
      backgroundColor: GerenaColors.backgroundColorFondo,
      bottomNavBackgroundColor: GerenaColors.backgroundColor,
    );
  }
}