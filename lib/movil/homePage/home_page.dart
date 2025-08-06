import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';
import 'package:gerena/movil/homePage/PostController/post_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageMovil extends StatefulWidget {
  const HomePageMovil({Key? key}) : super(key: key);

  @override
  State<HomePageMovil> createState() => _GerenaFeedScreenState();
}

class _GerenaFeedScreenState extends State<HomePageMovil> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _buscarController = TextEditingController();
    final double availableHeight = MediaQuery.of(context).size.height - 
                                  AppBar().preferredSize.height - 
                                  kBottomNavigationBarHeight;

    String _getStoryUserImage(int index) {
      final List<String> userImages = [
        'assets/perfil.png',
        'assets/perfil.png',
        'assets/perfil.png',
        'assets/perfil.png',
        'assets/perfil.png',
        'assets/perfil.png'
      ];
      return userImages[index];
    }

    List<Widget> allItems = [
      Container(
        height: availableHeight,
        child: Column(
          children: [
            Container(
              height: 100,
              color: GerenaColors.backgroundColorFondo,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 6,
                itemBuilder: (context, index) {
                  if (index == 0) {
                   return Container(
                          margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Agregar mi historia");
                                },
                                child: Stack(
                                  children: [
                                    GerenaColors.createStoryRing(
                                      child: Image.asset(
                                        'assets/perfil.png',
                                        fit: BoxFit.cover,
                                      ),
                                      hasStory: false,
                                      size: 80,
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: SizedBox(
                                        width: 29,
                                        height: 29,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(
                                            'assets/icons/aadHistory.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                  }
                  
                  return Container(
                    margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                          //  openStoryFromHistoriasList(context, index);
                          },
                          child: GerenaColors.createStoryRing(
                            child: Image.asset(
                              _getStoryUserImage(index),
                              fit: BoxFit.cover,
                            ),
                            hasStory: true,
                            isViewed: false,
                            size: 80,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ),
            Expanded(
              child: Column(
                children: [
                  
                ],
              ),
            ),
          ],
        ),
      ),
     
    ];

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
                
                },)

            ),
          ],
        ),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: allItems.length,
        itemBuilder: (context, index) {
          return allItems[index];
        },
        physics: const BouncingScrollPhysics(),
      ),
    );
  }



}