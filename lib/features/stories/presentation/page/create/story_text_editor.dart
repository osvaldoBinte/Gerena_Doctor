import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryTextEditor extends StatefulWidget {
  final Function(String text, Color color, Offset position, double scale) onTextAdded;

  const StoryTextEditor({
    Key? key,
    required this.onTextAdded,
  }) : super(key: key);

  @override
  State<StoryTextEditor> createState() => _StoryTextEditorState();
}

class _StoryTextEditorState extends State<StoryTextEditor> {
  final TextEditingController textController = TextEditingController();
  Color selectedColor = Colors.white;
  
  final List<Color> availableColors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Input de texto
          TextField(
            controller: textController,
            autofocus: true,
            style: GoogleFonts.rubik(
              color: selectedColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Escribe algo...',
              hintStyle: GoogleFonts.rubik(
                color: Colors.grey[400],
                fontSize: 24,
              ),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 20),

          // Selector de colores
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableColors.length,
              itemBuilder: (context, index) {
                final color = availableColors[index];
                final isSelected = color == selectedColor;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.grey[700]!,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Botones
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (textController.text.trim().isNotEmpty) {
                      widget.onTextAdded(
                        textController.text,
                        selectedColor,
                        const Offset(0.5, 0.5), // Centro de la pantalla
                        1.0,
                      );
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Agregar',
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}