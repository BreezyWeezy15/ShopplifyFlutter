import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../auth_bloc/shop_bloc.dart';
import '../auth_bloc/shop_bloc_event.dart';
import '../auth_bloc/shop_bloc_state.dart';
import '../utils.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_edit.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool isVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
             Fluttertoast.showToast(msg: state.e.toString());
             setState(() {
               isVisible = false;
             });
           }
           if(state is RegisterState){
             if(state.userCredential != null){
               _showSnackBar("Success");
               context.read<ShopBloc>().add(UploadDataEvent(state.userImage,state.name,state.email,state.phone));
             }
             else {
               _showSnackBar("Failed to create an account");
               setState(() {
                 isVisible = false;
               });
             }
           }
           if(state is UploadDataState){
              _showSnackBar("Account successfully created");
              if(state.isSuccess){
                setState(() {
                  isVisible = false;
                });
                Get.offNamed(Utils.homeRoute);
              } else {
                _showSnackBar("Failed to create an account");
                setState(() {
                  isVisible = false;
                });
                BlocProvider.of<ShopBloc>(context).add(DeleteAccountEvent());
              }
           }
           if(state is DeleteAccountState){
              if(state.isDeleted){
                print("Account Deleted");
              } else {
                print("Account Not Deleted");
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
                    child: Text("Join Us",style: getArimoBold().copyWith(fontSize: 25),),),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 30,top: 10,bottom: 10),
                    child: Text("Hello, you must join us to be able to use the application and enjoy all the features in Calashop",
                      style: getArimoRegular().copyWith(fontSize: 17),),
                  ),
                  CustomEdit(hint: "John Doe",iconData: Icons.person, textEditingController: _nameController,),
                  CustomEdit(hint: "JohnDoe@gmail.com",iconData: Icons.email_outlined, textEditingController: _emailController,),
                  CustomEdit(hint: "+1 800-578-574",iconData: Icons.phone, textEditingController: _phoneController,),
                  CustomEdit(hint: "******",iconData: Icons.password, textEditingController: _passController,),
                  CustomContainer(text: "Register", onClick: (){
                    String name = _nameController.text.toString();
                    String email = _emailController.text.toString();
                    String phone = _phoneController.text.toString();
                    String password = _phoneController.text.toString();

                    if(name.isEmpty){
                      _showSnackBar("Name should not be empty");
                      return;
                    }
                    if(email.isEmpty){
                      _showSnackBar("Email should not be empty");
                      return;
                    }
                    if(phone.isEmpty){
                      _showSnackBar("Phone should not be empty");
                      return;
                    }
                    if(password.isEmpty){
                      _showSnackBar("Password should not be empty");
                      return;
                    }
                    if(password.length < 6){
                      _showSnackBar("Password cannot be less than 6");
                      return;
                    }

                    context.read<ShopBloc>().add(RegisterUserEvent(Utils.userImageUrl,name,email,password,phone));

                  }, color: Colors.deepOrange, isLoading: isVisible,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: Row(
                      children: [
                        Text("Have an account? ",style: getArimoRegular(),),
                        GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: Text("Login",style: getArimoRegular().copyWith(color: Colors.deepOrange,
                              fontSize: 15),),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),);
  }

  _showSnackBar(String errorMsg){
    Get.showSnackbar(GetSnackBar(
      message: errorMsg,
      duration: const Duration(seconds: 2),
    ));
  }
}
