import 'package:flutter/material.dart';
import 'package:gerena/common/theme/App_Theme.dart';

class ImageViewerDialog extends StatelessWidget {
  final String imageUrl;

  const ImageViewerDialog({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: GerenaColors.backgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Image.asset(
                                  'assets/icons/close.png',
                                  color: GerenaColors.textSecondaryColor,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                        ),

                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: GerenaColors.backgroundColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              child: InteractiveViewer(
                                minScale: 0.5,
                                maxScale: 4.0,
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 200,
                                      width: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                          color: GerenaColors.primaryColor,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      width: 200,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              size: 48,
                                              color: GerenaColors.textTertiary,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Error al cargar imagen',
                                              style: TextStyle(
                                                color:
                                                    GerenaColors.textTertiary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static void show(BuildContext context, String imageUrl, {String? title}) {
    showDialog(
      context: context,
      barrierColor: GerenaColors.textTertiary.withOpacity(0.7),
      builder: (context) => ImageViewerDialog(
        imageUrl: imageUrl,
      ),
    );
  }
}
