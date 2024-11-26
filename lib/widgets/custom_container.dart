import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:furniture_flutter_app/utils.dart';

class CustomContainer extends StatelessWidget {
  final String? text;
  final Function()? onClick;
  final Color? color;
  final bool isLoading;
  const CustomContainer({super.key,required this.text,required this.onClick,required this.color ,
   required this.isLoading });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Center(
        child: Container(
          margin : const EdgeInsets.only(left: 20,right: 20,top: 50,bottom: 20),
          width: 300,
          height: 55,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              color: color
          ),
          child: Center(
            child: isLoading ?
            const SpinKitCubeGrid(size: 25,color: Colors.white) :
            Text(text!,style: getArimoBold().copyWith(fontSize: 18,color: Colors.white),)),
        ),
      ),
    );
  }
}
