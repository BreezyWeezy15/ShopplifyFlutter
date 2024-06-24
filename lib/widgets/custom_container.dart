import 'package:flutter/material.dart';
import 'package:furniture_flutter_app/utils.dart';

class CustomContainer extends StatelessWidget {
  final String? text;
  final Function()? onClick;
  final Color? color;
  const CustomContainer({super.key,required this.text,required this.onClick,required this.color});

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
          child: Center(child: Text(text!,style: getArimoBold().copyWith(fontSize: 18,color: Colors.white),),),
        ),
      ),
    );
  }
}
