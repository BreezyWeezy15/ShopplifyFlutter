import 'dart:ui';
import 'package:flutter/src/painting/text_style.dart';
import 'package:furniture_flutter_app/firebase/login_page.dart';
import 'package:furniture_flutter_app/firebase/password_page.dart';
import 'package:furniture_flutter_app/firebase/registration_page.dart';
import 'package:furniture_flutter_app/screens/payment_success_page.dart';
import 'package:furniture_flutter_app/screens/view_all_page.dart';
import 'package:furniture_flutter_app/ui/cart_page.dart';
import 'package:furniture_flutter_app/ui/details_screen.dart';
import 'package:furniture_flutter_app/ui/home_page.dart';
import 'package:furniture_flutter_app/ui/splash_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  static String publishableKey = "pk_test_51IVasBFP6YK87V1sCbMrswWJDG0nl4qdHUBsvzWqbDAKS4UwPTL5MKR1hulV26gQTYgRFPsZqk9zlg0Cw7RCA0Vc00Lzgmtm5n";
  static String secretKey = "sk_test_51IVasBFP6YK87V1sTrKbMuwQYmPC6ykldO9fbabCoZQ2O7BjpHuleUECnJ5KWr5BpTBRR3Ji77801GUxIUc3Bjbx00RHTmROSZ";
  static String userImageUrl = "https://firebasestorage.googleapis.com/v0/b/shoplify-8a6b4.appspot.com/o/profile.png?alt=media&token=56a894db-c322-47e7-be83-81ed7f421873";
  static String databaseUrl = "https://shoplify-8a6b4-default-rtdb.firebaseio.com/";
  static String splashRoute = "/splash";
  static String loginRoute = "/login";
  static String registrationRoute = "/registration";
  static String recoveryRoute = "/password";
  static String homeRoute = "/home";
  static String detailsRoute = "/details";
  static String cartRoute = "/cart";
  static String viewAllRoute = "/viewAll";
  static String successRoute = "/success";

}

List<GetPage> pages = [
  GetPage(name: Utils.splashRoute, page: () => const SplashPage()),
  GetPage(name: Utils.loginRoute, page: () => const LoginPage()),
  GetPage(name: Utils.registrationRoute, page: () => const RegistrationPage()),
  GetPage(name: Utils.recoveryRoute, page: () => const PasswordPage()),
  GetPage(name: Utils.homeRoute, page: () => const HomePage()),
  GetPage(name: Utils.detailsRoute, page: () => const DetailsPage()),
  GetPage(name: Utils.cartRoute, page: () => const CartPage()),
  GetPage(name: Utils.viewAllRoute, page: () => const ViewAllPage()),
  GetPage(name: Utils.successRoute, page: () => const PaymentSuccessPage())
];

TextStyle getArimoBold(){
  return GoogleFonts.arimo(fontWeight : FontWeight.bold);
}

TextStyle getArimoRegular(){
  return GoogleFonts.arimo(fontWeight : FontWeight.normal);
}