import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GerenaColors {
  // Colores principales
  static const Color primaryColor = Color(0xFF00535C);       // Color principal verde azulado oscuro
  static const Color secondaryColor = Color(0xFF63C2A7);     // Color secundario turquesa claro

  static const Color accentColor = Color(0xFF00A99D);        // Color de acento verde azulado medio
  static const Color backgroundlogin = Color(0xFF004346);
  static const Color backgroundcalendart = Color(0xFF005B5F);
  static const Color backgroundproductcategory = Color(0xFF00919A);
  static const Color backgroundColorFondo = Color(0xFFF0F0F0);
 static const Color backgroundCalendar = Color(0xFF005B5F); // Fondo de calendario
  static const Color rowColorCalendar = Color(0xFF00597D);

  static const Color colorinput = Color(0xFFA7A7A7); // Fondo de Gerena
  // Colores de fondo y superficie
  static const Color backgroundColor = Colors.white;         // Fondo blanco como en las interfaces
  static const Color surfaceColor = Colors.white;           // Superficies blancas
  static const Color cardColor = Colors.white;              // Cards blancas
  static final Color backgroundColorfondo = Colors.grey[100]!;
  // Colores de texto
  static const Color textPrimaryColor = Color(0xFF00535C);  // Texto principal en verde azulado oscuro
  static const Color textSecondaryColor = Colors.grey;  
  static const Color textTertiaryColor = Color(0xFF656565); // Texto terciario gris claro
  static const Color textLightColor = Colors.white;         // Texto en color claro para fondos oscuros
  static const Color textDarkColor = Color(0xFF004346);   
  static const Color textchatDefault = Color(0xFFEDEDED); // Texto secundario claro
  static const Color textchatAnswer = Color(0xFFBAFFEB);
  static const Color textchat = Color(0xFF656565); // Texto de pregunta en gris claro
  static const Color textTertiary = Color(0xFF000000);     
  static const Color textQuaternary = Color(0xFF00A6AD);

  // Colores de estado
  static const Color successColor = Color(0xFF4CAF50);      // Verde para éxito
  static const Color warningColor = Color(0xFFF7770E); 
  static const Color descuento = Color(0xFFFF3B3B);        // Rojo para errores
  static const Color errorColor = Color(0xFFFF3B3B);        // Rojo para errores
  static const Color infoColor = Color(0xFF2196F3);         // Azul para información
  
  static const Color storyGradientStart = Color(0xFF004346);  // Rosa
  static const Color storyGradientMiddle = Color(0xFF63C2A7); // Naranja
  static const Color storyGradientEnd = Color(0xFF004346);
  // Colores específicos para la aplicación
  static const Color colorFondo = backgroundColor;
  static const Color colorNavbar = primaryColor;            // Navbar verde azulado oscuro
  static const Color colorTexto = textPrimaryColor;
  static const Color colorCabezeraTabla = Color(0xFFE0E0E0);
  static const Color colorRowPar = Colors.white;
  static const Color colorRowNoPar = Color(0xFFF5F5F5);
  static const Color colordCard = cardColor;
  static const Color colorAccionButtons = secondaryColor;   // Botones de acción turquesa
  static const Color colorCancelar = Color(0xFFE0E0E0);     // Gris claro para cancelar
  static const Color colorBotonNavbar = textLightColor;
  static const Color colorHoverRow = secondaryColor;
  static const Color colorback =  Color.fromARGB(255, 0, 0, 0);
  
  // Colores para la card de suscripciones
  static const Color colorSubsCardBackground = Colors.white;
  static const Color colorSubsCardTitle = textPrimaryColor;
  static const Color colorSubsCardPrice = Color(0xFF00A99D);
  static const Color colorSubsCardDuration = Color(0xFF607D8B);
  
  // Utilidades con valores computados
  static final Color shadoCard = Colors.black.withOpacity(0.1);
  static final Color dividerColor = Colors.grey.withOpacity(0.2);


static final Color shadowColor = Colors.grey.withOpacity(0.5);
  static final Color disabledColor = Colors.grey;
  static final Color colorSubsCardBorder = Colors.grey[300]!;
  static final Color colorSubsCardSecondaryText = Colors.grey[600]!;
  static final Color buttoninformation = Color(0xFF63C2A7); // Color para botones de información
  
  // Lista de colores para el degradado
  static final List<Color> gerenaGradientColors = [
    primaryColor,
    accentColor, 
    secondaryColor,
  ];
  
  // Gradientes
  static LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryColor, accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get secondaryGradient => LinearGradient(
    colors: [secondaryColor, accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundlogin],
  );
  
  // Valores constantes para dimensiones
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 20.0;
  
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  
  // Objetos BorderRadius
  static BorderRadius get smallBorderRadius => BorderRadius.circular(smallRadius);
  static BorderRadius get mediumBorderRadius => BorderRadius.circular(mediumRadius);
  static BorderRadius get largeBorderRadius => BorderRadius.circular(largeRadius);
  
  // Sombras
  static BoxShadow get lightShadow => BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 4,
    offset: const Offset(0, 2),
  );
  
  static BoxShadow get mediumShadow => BoxShadow(
    color: Colors.black.withOpacity(0.3),
    blurRadius: 8,
    offset: const Offset(0, 4),
  );
  static BoxShadow get darkShadow => BoxShadow(
    color: Colors.black.withOpacity(0.5),
    blurRadius: 12,
    offset: const Offset(0, 6),
  );
  static BoxShadow get storyShadow => BoxShadow(
    color: Colors.black.withOpacity(0.15),
    spreadRadius: 2,
    blurRadius: 8,
    offset: const Offset(0, 4),
  );
  // Decoraciones
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: mediumBorderRadius,
    boxShadow: [lightShadow],
  );
  
  static BoxDecoration get storeCardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: smallBorderRadius,
    boxShadow: [lightShadow],
  );
  
  // Estilos de texto con GoogleFonts.rubik
  static TextStyle get headingLarge => GoogleFonts.rubik(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );
  
  static TextStyle get headingMedium => GoogleFonts.rubik(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );
  
  static TextStyle get headingSmall => GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );
  
  static TextStyle get subtitleLarge => GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textSecondaryColor,
  );
  
  static TextStyle get subtitleMedium => GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textDarkColor,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.rubik(
    fontSize: 16,
    color: textPrimaryColor,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.rubik(
    fontSize: 14,
    color: textTertiaryColor,
  );
  
  static TextStyle get bodySmall => GoogleFonts.rubik(
    fontSize: 12,
    color: textSecondaryColor,
  );
  
  static TextStyle get buttonText => GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textLightColor,
  );
  
  static TextStyle get navbarText => GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textLightColor,
  );
    static LinearGradient get storyGradient => LinearGradient(
    colors: [storyGradientStart, storyGradientMiddle, storyGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
 static Widget createStarRating({
    required double rating,
    int maxStars = 5,
    double size = 16,
    Color filledColor = const Color(0xFF00597D),
    Color emptyColor = const Color(0xFF929292),
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        maxStars,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            Icons.star,
            size: size,
            color: index < rating.floor() ? filledColor : emptyColor,
          ),
        ),
      ),
    );
  }

  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      onPrimary: textLightColor,
      secondary: secondaryColor,
      onSecondary: textLightColor,
      tertiary: accentColor,
      error: errorColor,
      onError: textLightColor,
      background: backgroundColor,
      onBackground: textPrimaryColor,
      surface: surfaceColor,
      onSurface: textPrimaryColor,
    ),
    
    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: colorNavbar,
      foregroundColor: textLightColor,
      elevation: 0,
      titleTextStyle: navbarText,
    ),
    
    // Card
    cardTheme: CardThemeData(
      color: colorSubsCardBackground,
      elevation: elevationSmall,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: mediumBorderRadius,
      ),
    ),
    
    // Botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorAccionButtons,
        foregroundColor: textLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: smallBorderRadius,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        textStyle: buttonText,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: smallBorderRadius,
        ),
        textStyle: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // DataTable
    dataTableTheme: DataTableThemeData(
      headingRowColor: MaterialStateProperty.all(colorCabezeraTabla),
      dataRowColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return colorHoverRow.withOpacity(0.1);
          }
          return Colors.transparent;
        },
      ),
      dividerThickness: 1,
      headingTextStyle: GoogleFonts.rubik(
        color: textPrimaryColor,
        fontWeight: FontWeight.bold,
      ),
    ),
    
    // Estilos de texto
    textTheme: TextTheme(
      bodyMedium: bodyMedium,
      bodyLarge: bodyLarge,
      titleMedium: subtitleMedium,
      titleLarge: headingSmall,
    ),
    
    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: smallBorderRadius,
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: smallBorderRadius,
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: smallBorderRadius,
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      labelStyle: GoogleFonts.rubik(color: textSecondaryColor),
      hintStyle: GoogleFonts.rubik(color: textSecondaryColor.withOpacity(0.7)),
    ),
    
    // Bottom navigation bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorNavbar,
      selectedItemColor: secondaryColor,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: GoogleFonts.rubik(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: GoogleFonts.rubik(fontSize: 12),
      elevation: 8,
    ),
    
    // Divider
    dividerTheme: DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 1,
    ),
    
    // Icon theme
    iconTheme: IconThemeData(
      color: primaryColor,
      size: 24,
    ),
  );
  
  // Helper methods para widgets comunes específicos de Gerena
  
  // Botón primario con estilo Gerena
  static Widget createPrimaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isFullWidth = false,
    double? height, 
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallRadius),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.rubik(),
        ),
      ),
    );
  }
  
  // Botón secundario (gris) con estilo Gerena
  static Widget createSecondaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isFullWidth = false,
    double? height, 
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorCancelar,
          foregroundColor: textPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(smallRadius),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.rubik(),
        ),
      ),
    );
  }
  
  // Tarjeta de producto para la tienda
  static Widget createProductCard({
    required String name,
    required String price,
    required String imagePath,
    required VoidCallback onViewInfoPressed,
    required VoidCallback onFavoritePressed,
  }) {
    return Container(
      decoration: storeCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with background
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(smallRadius)),
                image: const DecorationImage(
                  image: AssetImage('assets/tienda-producto.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Image.asset(
                  imagePath,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          // Product info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.rubik(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: onViewInfoPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        textStyle: GoogleFonts.rubik(fontSize: 10),
                      ),
                      child: const Text('VER INFORMACIÓN'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.grey),
                      onPressed: onFavoritePressed,
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // Tarjeta para noticias o artículos - VERSIÓN CON CONTENIDO FIJO ABAJO
static Widget createArticleCard({
  required String title, 
  required String content, 
  required String date,
  required String imagePath,
  required VoidCallback onReadMorePressed,
  double? height, // Altura opcional para controlar el tamaño de la card
}) {
  return Container(
    height: height ?? 400, // Altura fija o por defecto
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(smallRadius),
      boxShadow: [lightShadow],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen con altura fija
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(smallRadius),
            topRight: Radius.circular(smallRadius),
          ),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        
        // Contenido expandible que empuja el footer hacia abajo
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  title,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: GerenaColors.textPrimaryColor,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Contenido expandible que toma el espacio disponible
                Expanded(
                  child: Text(
                    content,
                    style: GoogleFonts.rubik(
                      fontSize: 12,
                      color: GerenaColors.textPrimaryColor,
                    ),
                    maxLines: null, // Permitir múltiples líneas
                    overflow: TextOverflow.fade, // Fade en lugar de ellipsis
                  ),
                ),
                
                // Footer fijo en la parte inferior
                Row(
                  children: [
                    // Fecha
                    Expanded(
                      flex: 2,
                      child: Text(
                        date,
                        style: GoogleFonts.rubik(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Botón "Continuar leyendo"
                    TextButton(
                      onPressed: onReadMorePressed,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        'Continuar leyendo...',
                        style: GoogleFonts.rubik(
                          color: GerenaColors.accentColor,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

static Widget createAppLogo({
  String imagePath = 'assets/gerena-logo.png',
  double size = 150,
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 60.0, vertical: 70.0),
}) {
  return Padding(
    padding: padding,
    child: Center(
      child: ClipOval(
        child: Container(
          width: size,  
          height: size,
          child: Center(
            child: Image.asset(
              imagePath,
              width: size,
              height: size,
              fit: BoxFit.cover, 
            ),
          ),
        ),
      ),
    ),
  );
}

 static Widget createMainScaffold({
    required Widget body,
    required int currentIndex,
    required Function(int) onNavigationTap,
    required List<String> iconPaths,
    Color? backgroundColor,
    Color? bottomNavBackgroundColor,
  }) {
    return Scaffold(
      backgroundColor: backgroundColor ?? backgroundColorFondo,
      
      body: body,
      bottomNavigationBar: createBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onNavigationTap,
        iconPaths: iconPaths,
        backgroundColor: bottomNavBackgroundColor,
      ),
    );
  }

static Widget createBottomNavigationBar({
  required int currentIndex,
  required Function(int) onTap,
  required List<String> iconPaths,
  Color? backgroundColor,
  Color? selectedItemColor,
  Color? unselectedItemColor,
}) {
  return Container(
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 4,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: SafeArea(
      child: Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(iconPaths.length, (index) {
            return GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.asset(
                  iconPaths[index],
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                  // SIN propiedad color
                ),
              ),
            );
          }),
        ),
      ),
    ),
  );
}
 static Widget createLoginTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.rubik(
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.rubik(
            color: Colors.grey,
            fontSize: 16,
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 9,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: secondaryColor),
          ),
          isDense: true,
        ),
      ),
    );
  }

   static Widget createLoginTextButton({
    required String text,
    required VoidCallback onPressed,
    Color color = Colors.white,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.rubik(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decorationColor: Colors.white,
        ),
      ),
    );
  }
   static Widget createLoginButton({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = true,
    double width = 220,
    Widget? icon,
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: textTertiaryColor,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: icon != null 
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(width: 8),
                Text(
                  text,
                  style: GoogleFonts.rubik(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Text(
              text,
              style: GoogleFonts.rubik(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
      ),
    );
  }
   static Widget createLoginLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.rubik(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
static Widget createArticleCardFlexible({
  required String title, 
  required String content, 
  required String date,
  required String imagePath,
  required VoidCallback onReadMorePressed,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(smallRadius),
      boxShadow: [lightShadow],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Importante: tamaño mínimo
      children: [
        // Imagen
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(smallRadius),
            topRight: Radius.circular(smallRadius),
          ),
          child: Image.asset(
            imagePath,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        
        // Contenido con Spacer para empujar el footer hacia abajo
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Text(
                title,
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: GerenaColors.textPrimaryColor,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Contenido
              Text(
                content,
                style: GoogleFonts.rubik(
                  fontSize: 12,
                  color: GerenaColors.textPrimaryColor,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Espacio flexible que empuja el footer hacia abajo
              const SizedBox(height: 16),
              
              // Footer siempre en la parte inferior
              Row(
                children: [
                  // Fecha
                  Expanded(
                    flex: 2,
                    child: Text(
                      date,
                      style: GoogleFonts.rubik(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Botón "Continuar leyendo"
                  TextButton(
                    onPressed: onReadMorePressed,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      'Continuar leyendo...',
                      style: GoogleFonts.rubik(
                        color: GerenaColors.accentColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// VERSIÓN PARA USAR EN GRIDS: Con altura fija y footer siempre abajo
static Widget createArticleCardForGrid({
  required String title, 
  required String content, 
  required String date,
  required String imagePath,
  required VoidCallback onReadMorePressed,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight, // Usa la altura disponible del grid
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(smallRadius),
          boxShadow: [lightShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen proporcional
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(smallRadius),
                topRight: Radius.circular(smallRadius),
              ),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: constraints.maxHeight * 0.4, // 40% de la altura para la imagen
                fit: BoxFit.cover,
              ),
            ),
            
            // Contenido expandible
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      title,
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: GerenaColors.textPrimaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    
                    // Contenido expandible
                    Expanded(
                      child: Text(
                        content,
                        style: GoogleFonts.rubik(
                          fontSize: 11,
                          color: GerenaColors.textPrimaryColor,
                        ),
                        maxLines: null,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    
                    // Footer fijo
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            date,
                            style: GoogleFonts.rubik(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton(
                          onPressed: onReadMorePressed,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: Size.zero,
                          ),
                          child: Text(
                            'Leer más',
                            style: GoogleFonts.rubik(
                              color: GerenaColors.accentColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
 static Widget createStoryRing({
    required Widget child,
    bool hasStory = true,
    bool isViewed = false,
    double size = 80,
    double borderWidth = 2,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hasStory && !isViewed ? storyGradient : null,
        border: !hasStory || isViewed 
          ? Border.all(color: Colors.grey[300]!, width: borderWidth)
          : null,
        boxShadow: [storyShadow],
      ),
      child: Container(
        margin: EdgeInsets.all(hasStory && !isViewed ? 3 : 0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: hasStory && !isViewed 
            ? Border.all(color: Colors.white, width: borderWidth)
            : null,
        ),
        child: ClipOval(child: child),
      ),
    );
  }
static Widget createSearchContainer({
  VoidCallback? onTap,
  double? height,
  Color? backgroundColor,
  Color? textColor,
  Widget? leadingIcon,
  Widget? trailingIcon,
  double? borderRadius,
  EdgeInsets? padding,
  double?heightcontainer,
  double?  iconSize,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height ?? 35,
      decoration: BoxDecoration(
        color: backgroundColor ?? GerenaColors.primaryColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 25),
        boxShadow: [
          BoxShadow(
            color: GerenaColors.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 10),
            child: leadingIcon ?? 
              Image.asset(
                'assets/icons/search.png',
                width: iconSize ?? 20,
                height: iconSize ?? 20,
                color: textColor ?? GerenaColors.textLightColor,
              ),
          ),
          
         Expanded(
  child: Container(
    margin: const EdgeInsets.only(top: 5),
    child: Container(
      height: heightcontainer ?? 19,
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 0,
      ),
      decoration: BoxDecoration(
        color: GerenaColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
),
          
          if (trailingIcon != null) 
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: trailingIcon,
            )
          else
            const SizedBox(width: 8),
        ],
      ),
    ),
  );
}



static Widget widgetButton({
  VoidCallback? onPressed,
  String text = 'AGENDAR CITA',
  Color? backgroundColor,
  Color? textColor,
  double? fontSize,
  EdgeInsets? padding,
  double? borderRadius,
  bool showShadow = true,
  Color? borderColor,
  double? borderWidth,
  FontWeight? fontWeight,
  BoxShadow? customShadow,
}) {
  VoidCallback defaultOnPressed = () {
    try {
     
    } catch (e) {
      print('Error: StartController no encontrado');
    }
  };

  VoidCallback finalOnPressed = onPressed ??
      (text == 'AGENDAR CITA' ? defaultOnPressed : () {});

  return GestureDetector(
    onTap: finalOnPressed,
    child: Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 13, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? GerenaColors.secondaryColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 5),
        border: borderColor != null
            ? Border.all(
                color: borderColor,
                width: borderWidth ?? 1.0,
              )
            : null,
        boxShadow: showShadow 
            ? [customShadow ?? darkShadow] 
            : null,
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.rubik(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 12,
            fontWeight: fontWeight ?? FontWeight.w500,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
}