import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:furniture_flutter_app/widgets/custom_container.dart';
import 'package:furniture_flutter_app/widgets/custom_edit.dart';
import 'package:get/get.dart';

import '../auth_bloc/shop_bloc.dart';
import '../auth_bloc/shop_bloc_event.dart';
import '../auth_bloc/shop_bloc_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool isVisible = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc,ShopBlocState>(
       listener: (context,state){
         if(state is LOADING){
           setState(() {
             isVisible = true;
           });
         }
         if(state is ERROR){
           setState(() {
             isVisible = false;
           });
           Fluttertoast.showToast(msg: state.e.toString());
         }
         if(state is LoginState){
            if(state.userCredential != null){
              setState(() {
                isVisible = false;
              });
              Fluttertoast.showToast(msg: "User successfully logged-in");
              Get.offNamed(Utils.homeRoute);
            }
            else {
              setState(() {
                isVisible = false;
              });
              Fluttertoast.showToast(msg: "Failed to login user");
            }
         }
       },
       child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  height: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/frame.png"),
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover
                      )
                  ),
                  child: Center(child: Text("Shoplify",style: getArimoBold().copyWith(fontSize: 25),),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 30,bottom: 10),
                  child: Text("Login Account",style: getArimoBold().copyWith(fontSize: 25),),),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 30,top: 10,bottom: 10),
                  child: Text("Hello, you must login first to be able to use the application and enjoy all the features in Calashop",
                    style: getArimoRegular().copyWith(fontSize: 17),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 20),
                  child: Text("Email Address",style: getArimoRegular().copyWith(fontSize: 17),),
                ),
                CustomEdit(hint: "JohnDoe@gmail.com",iconData: Icons.email_outlined, textEditingController: _emailController,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                  child: Text("Password",style: getArimoRegular().copyWith(fontSize: 17),),
                ),
                CustomEdit(hint: "******",iconData: Icons.password, textEditingController: _passController,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: (){
                        Get.toNamed(Utils.recoveryRoute);
                      },
                      child: Text("Forgot Password?",style: getArimoBold().copyWith(fontSize: 15,color: Colors.deepOrange),
                        textAlign: TextAlign.end,),
                    ),
                  ),
                ),
                CustomContainer(text: "Login", onClick: (){
                  String email = _emailController.text.toString();
                  String password = _passController.text.toString();

                  if(email.isEmpty){
                    Get.showSnackbar(const GetSnackBar(
                      message: "Email should not be empty",
                      duration: Duration(seconds: 2),
                    ));
                    return;
                  }
                  if(password.isEmpty){
                    Get.showSnackbar(const GetSnackBar(
                      message: "Password should not empty",
                      duration: Duration(seconds: 2),
                    ));
                    return;
                  }
                  if(password.length < 6){
                    Get.showSnackbar(const GetSnackBar(
                      message: "Password Length cannot be less than 6",
                      duration: Duration(seconds: 2),
                    ));
                    return;
                  }

                  BlocProvider.of<ShopBloc>(context).add(LoginUserEvent(email, password));

                }, color: Colors.deepOrange, isLoading: isVisible,),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 30,),
                  child: Row(
                    children: [
                      Text("Don't have an account? ",style: getArimoRegular().copyWith(fontSize: 15),),
                      GestureDetector(
                        onTap: (){
                          Get.toNamed(Utils.registrationRoute);
                        },
                        child:  Text("Join Us",style: getArimoRegular().copyWith(fontSize: 15,
                            color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
