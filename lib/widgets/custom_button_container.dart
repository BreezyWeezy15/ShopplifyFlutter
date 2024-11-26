import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils.dart';

class CustomButtonContainer extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  final Color? color;
  final double marginTop;
  final bool isLoading;
  const CustomButtonContainer({super.key,required this.text,required this.onTap,required this.color,
        required this.marginTop , required this.isLoading });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: marginTop),
        width: 220,
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: color
        ),
        child: Center(
          child: isLoading ?
          SpinKitCubeGrid(size: 25,color: Colors.white,) :
          Text(text!,style: getArimoBold().copyWith(fontSize: 20,color: Colors.white)),
        ),
      ),
    );
  }
}
