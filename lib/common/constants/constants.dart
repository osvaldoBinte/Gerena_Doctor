import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String serverBase = dotenv.env['API_BASE'].toString();
  static const String accesos = "accesos";
  static const String cartKey = 'shopping_cart';
  static const String buynowKey = 'buy_now_Key';
  static const String wishlistKey = 'wishlist_Key';
  static  String stripePublishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'].toString();
  static  String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'].toString();
  static String serverBaseStripe = dotenv.env['STRIPE_API_BASE'].toString();
  
}