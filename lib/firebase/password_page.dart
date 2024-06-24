import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../auth_bloc/shop_bloc.dart';
import '../auth_bloc/shop_bloc_event.dart';
import '../auth_bloc/shop_bloc_state.dart';
import '../utils.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_edit.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc,ShopBlocState>(
      listener: (context,state){
        if(state is RecoverPassState){
          if(state.isSuccess){
             _emailController.clear();
             Fluttertoast.showToast(msg: "Reset email has been sent to you");
          } else {
            _emailController.clear();
             Fluttertoast.showToast(msg: "Failed to send reset email , Try again later");
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
                  child: Text("Reset Password",style: getArimoBold().copyWith(fontSize: 25),),),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 30,top: 10,bottom: 10),
                  child: Text("Password Lost! Recover it now",
                    style: getArimoRegular().copyWith(fontSize: 17),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 20),
                  child: Text("Email Address",style: getArimoRegular().copyWith(fontSize: 17),),
                ),
                CustomEdit(hint: "JohnDoe@gmail.com",iconData: Icons.email_outlined, textEditingController: _emailController,),
                CustomContainer(text: "Reset", onClick: (){
                  String email = _emailController.text.toString();
                  if(email.isEmpty){
                    Fluttertoast.showToast(msg: "Email should not be empty");
                    return;
                  }
                  BlocProvider.of<ShopBloc>(context).add(RecoverPassEvent(email));
                }, color: Colors.deepOrange),
              ],
            ),
          ),
        ),
      ),
    );
  }
}