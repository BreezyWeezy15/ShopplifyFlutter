import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_flutter_app/auth/cart_service.dart';
import 'package:furniture_flutter_app/auth/firebase_auth.dart';
import 'package:furniture_flutter_app/auth_bloc/furniture_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/payment_bloc.dart';
import 'package:furniture_flutter_app/sql/furniture_db.dart';
import 'package:furniture_flutter_app/ui/splash_page.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:get/get.dart';
import 'auth_bloc/shop_bloc.dart';

FurnitureDatabase furnitureDatabase = FurnitureDatabase.instance;
void main() async {
  await GetStorage.init();
  Stripe.publishableKey = Utils.publishableKey;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCExpUW6cQcQZjEB-8uL_UBqcRW1-Msp0Q",
          appId: "1:683552874113:android:f698e2a948b51b3867b780",
          messagingSenderId: "683552874113",
          projectId: "shoplify-8a6b4",
          storageBucket: "shoplify-8a6b4.appspot.com")
  );
  runApp(MultiBlocProvider(
     providers: [
        BlocProvider(create: (_) => ShopBloc(FirebaseAuthService())),
        BlocProvider(create: (_) => FurnitureBloc(FirebaseAuthService(),CartService())),
        BlocProvider(create: (_) => PaymentBloc(CartService(),FirebaseAuthService()))
     ],
    child: GetMaterialApp(
      home: const MyApp(),
      debugShowCheckedModeBanner: false,
      getPages: pages,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}


