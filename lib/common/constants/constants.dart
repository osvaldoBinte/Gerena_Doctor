import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String serverBase = dotenv.env['API_BASE'].toString();
  static const String accesos = "accesos";
  static const String cartKey = 'shopping_cart';

  
}