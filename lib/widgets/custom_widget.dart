import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils.dart';

class CustomWidget extends StatelessWidget {
  final double? height;
  final String? widget;
  final String? message;
  const CustomWidget({super.key,required this.height,required this.widget,required this.message});

  @override
  Widget build(BuildContext context) {
    if(widget == "progressBar"){
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / height!,
        child:  const Center(child: SpinKitFadingFour(size: 50,color: Colors.black54),),
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / height!,
      child: Center(
        child: Text(message!,style: getArimoBold().copyWith(fontSize: 20),),
      ),
    );
  }
}
