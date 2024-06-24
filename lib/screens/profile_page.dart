
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_event.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_state.dart';
import 'package:furniture_flutter_app/utils.dart';
import 'package:furniture_flutter_app/widgets/custom_button_container.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../widgets/profile_custom_edit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProgressDialog pr;
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isPhoneEnabled = false;
  bool isNameEnabled = false;
  String buttonName = "Edit";
  String oldImageUrl = "";
  XFile? _pickedFile;
  File? _imageUri;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ShopBloc>(context).add(GetUserDataEvent());
    pr = ProgressDialog(context,type: ProgressDialogType.normal, isDismissible: false, showLogs: false);
  }

  _pickPicture() async {
    _pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if(_pickedFile != null){
      setState(() {
        _imageUri = File(_pickedFile!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc,ShopBlocState>(
        listener: (context,state){
          if(state is GetUserDataState){
            setState(() {
              oldImageUrl = state.userModel.userImage!;
              _emailController.text = state.userModel.email!;
              _nameController.text = state.userModel.name!;
              _phoneController.text = state.userModel.phone!;
            });
          }
          if(state is GetUploadUserImageState){
             if(state.downloadUrl!.isNotEmpty){
               setState(() {
                   oldImageUrl = state.downloadUrl!;
               });
             }
             BlocProvider.of<ShopBloc>(context).add(UploadDataEvent(state.downloadUrl!, state.name,state.email,state.phone));
          }
          if(state is UploadDataState){
             if(state.isSuccess){
               pr.hide();
               BlocProvider.of<ShopBloc>(context).add(GetUserDataEvent());
               Fluttertoast.showToast(msg: "User Data Successfully Update");
               setState(() {
                 setState(() {
                   buttonName = "Edit";
                   isPhoneEnabled = false;
                   isNameEnabled = false;
                 });
               });
             } else {
               pr.hide();
               Fluttertoast.showToast(msg: "Failed to update user data");
             }
          }
          if(state is LogoutState){
             bool isSuccess = state.isSuccess;
             if(isSuccess){
               Fluttertoast.showToast(msg: "Successfully logged out");
               Get.offNamed(Utils.loginRoute);
             } else {
               Fluttertoast.showToast(msg: "Failed to logout");
             }
          }
        },
        child: SafeArea(
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16),bottomLeft: Radius.circular(16)),
                    color: Colors.grey.shade200
                  ),
                  child: Center(
                    child: Text("Profile",style: getArimoRegular().copyWith(fontSize: 25),),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ShopBloc,ShopBlocState>(
                    builder: (context,state){
                      if(state is GetUserDataState){
                        var data = state.userModel;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(30),
                            GestureDetector(
                              onTap: () async {
                                await _pickPicture();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: _imageUri != null ? Image.file(_imageUri!,width: 80,height: 80,fit: BoxFit.cover,) :
                                 Image.network(state.userModel.userImage!,width: 80,height: 80,fit: BoxFit.cover,),
                              ),
                            ),
                            const Gap(20),
                            ProfileCustomEdit(isEnabled: false,hint: data.email,iconData: Icons.email,textEditingController: _emailController,),
                            ProfileCustomEdit(isEnabled: isPhoneEnabled,hint: data.name,iconData: Icons.person,textEditingController: _nameController,),
                            ProfileCustomEdit(isEnabled: isNameEnabled,hint: data.phone,iconData: Icons.phone,textEditingController: _phoneController,),
                            CustomButtonContainer(text: buttonName, onTap: (){
                              if(buttonName == "Edit"){
                                setState(() {
                                  buttonName = "Update";
                                  isPhoneEnabled = true;
                                  isNameEnabled = true;
                                });
                              }
                              else if (buttonName == "Update"){
                                String email = _emailController.text.toString();
                                String name = _nameController.text.toString();
                                String phone = _phoneController.text.toString();

                                if(name.isEmpty){
                                  Fluttertoast.showToast(msg: "Name cannot be empty");
                                  return;
                                }
                                if(phone.isEmpty){
                                  Fluttertoast.showToast(msg: "Phone cannot be empty");
                                  return;
                                }
                                pr.show();
                                if(_imageUri != null){
                                  BlocProvider.of<ShopBloc>(context).add(GetUploadUserImageEvent(_imageUri,name,email,phone));
                                } else {
                                  BlocProvider.of<ShopBloc>(context).add(UploadDataEvent(oldImageUrl,name,email,phone));
                                }
                              }
                            }, color: Colors.deepOrange,marginTop: 30,),
                            CustomButtonContainer(text: "Logout", onTap: (){

                              showDialog(
                                  context: context,
                                  builder: (_){
                                     return AlertDialog(
                                       title: Text("Logout",style: getArimoRegular().copyWith(fontSize: 20),),
                                       content: Text("Are you sure you want to logout ?",style: getArimoRegular().copyWith(fontSize: 20),),
                                       actions: [
                                         ElevatedButton(onPressed: (){
                                           BlocProvider.of<ShopBloc>(context).add(LogoutEvent());
                                           Navigator.pop(context);
                                         }, child: Text("Yes",style: getArimoBold().copyWith(fontSize: 20),)),
                                         ElevatedButton(onPressed: (){
                                           Navigator.pop(context);
                                         }, child: Text("No",style: getArimoBold().copyWith(fontSize: 20),))
                                       ],
                                     );
                                  });

                            }, color: Colors.deepOrange,marginTop: 30,)
                          ],
                        );
                      } else {
                        return const Center(child: SpinKitFadingFour(size: 50,color: Colors.black54,),);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),);
  }
}
