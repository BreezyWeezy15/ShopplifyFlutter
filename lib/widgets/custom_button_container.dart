import 'package:flutter/material.dart';

import '../utils.dart';

class CustomButtonContainer extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  final Color? color;
  final double marginTop;
  const CustomButtonContainer({super.key,required this.text,required this.onTap,required this.color,
        required this.marginTop});

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
        child: Center(child: Text(text!,style: getArimoBold().copyWith(fontSize: 20,color: Colors.white),),),
      ),
    );
  }
}
