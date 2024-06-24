import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:get/get.dart';
import '../auth_bloc/shop_bloc.dart';
import '../auth_bloc/shop_bloc_event.dart';
import '../auth_bloc/shop_bloc_state.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShopBloc>(context).add(UserStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc,ShopBlocState>(
        listener: (context,state){
          if(state is UserStatusState){
             if(state.isSignedIn){
               Future.delayed(const Duration(seconds: 5),(){Get.offNamed(Utils.homeRoute);});
             } else {
               Future.delayed(const Duration(seconds: 5),(){Get.offNamed(Utils.loginRoute);});
             }
          }
        },
        child: SafeArea(
          child: Scaffold(
            body: Center(
              child: Image.asset("assets/images/logo.png",width: 250,height: 250,filterQuality: FilterQuality.high,),
            ),
          ),
        ),);
  }
}
